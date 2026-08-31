package com.gardenova.digisoft

import android.app.ActivityManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.google.firebase.messaging.RemoteMessage
import org.json.JSONObject

object GardenovaPushNotifier {
    private const val CHANNEL_ID = "plant_reminders"
    private const val CHANNEL_NAME = "Plant Reminders"
    private const val NOTIFICATION_TAG = "gardenova_reminder"
    private const val SELECT_NOTIFICATION = "SELECT_NOTIFICATION"
    private const val NOTIFICATION_ID_KEY = "notificationId"
    private const val PAYLOAD_KEY = "payload"
    private const val REMINDERS_ROUTE = "/plant_reminders_listing"
    private const val PREFS_NAME = "FlutterSharedPreferences"
    private const val PENDING_PAYLOAD_KEY = "pending_notification_payload"
    private const val NOTIFICATIONS_ENABLED_KEY = "notifications_enabled"
    private const val FLUTTER_NOTIFICATIONS_ENABLED_KEY = "flutter.notifications_enabled"
    private const val LAST_MESSAGE_ID_KEY = "gardenova_last_fcm_message_id"
    private const val LAST_MESSAGE_AT_KEY = "gardenova_last_fcm_message_at"
    private const val DEDUPE_WINDOW_MS = 15_000L
    private const val PENDING_INTENT_REQUEST_CODE = 0x6A617264
    private const val MAX_NOTIFICATION_BODY_WORDS = 50
    private const val TAG = "GardenovaPushNotifier"

    fun ellipsizeNotificationBody(
        body: String,
        maxWords: Int = MAX_NOTIFICATION_BODY_WORDS,
    ): String {
        val words = body.trim().split(Regex("\\s+")).filter { it.isNotEmpty() }
        if (words.size <= maxWords) return body.trim()
        return words.take(maxWords).joinToString(" ") + "..."
    }

    fun showFromRemoteMessage(context: Context, message: RemoteMessage) {
        val messageId = message.messageId ?: message.data["google.message_id"] ?: message.data["message_id"]
        if (messageId != null && isDuplicateMessage(context, messageId)) {
            Log.i(TAG, "[PUSH][skipped] duplicate message id=$messageId")
            return
        }

        val data = message.data
        val title = message.notification?.title
            ?: data["title"]
            ?: data["notification_title"]
            ?: data["Title"]
        val body = message.notification?.body
            ?: data["body"]
            ?: data["message"]
            ?: data["notification_body"]
            ?: data["Body"]
        if (title.isNullOrBlank() || body.isNullOrBlank()) {
            Log.w(TAG, "[PUSH][skipped] missing title/body id=$messageId data=$data")
            return
        }
        if (!areNotificationsEnabled(context)) {
            Log.i(TAG, "[PUSH][skipped] notifications disabled in prefs id=$messageId")
            return
        }

        if (messageId != null) {
            markMessageShown(context, messageId)
        }

        val payload = payloadJsonFor(message, title, body)
        val logId = data["notification_log_id"]
        val notificationId =
            when {
                !logId.isNullOrBlank() -> logId.hashCode()
                message.messageId != null -> message.messageId.hashCode()
                else -> message.hashCode()
            }

        show(context, title, body, payload, notificationId)
    }

    fun show(
        context: Context,
        title: String,
        body: String,
        payload: String,
        notificationId: Int,
    ) {
        val appContext = context.applicationContext
        ensureChannel(appContext)
        val displayBody = ellipsizeNotificationBody(body)
        val builtNotification = buildNotification(appContext, title, displayBody, payload, notificationId)
        val manager = appContext.getSystemService(NotificationManager::class.java)
        manager.notify(NOTIFICATION_TAG, notificationId, builtNotification)
        Log.i(TAG, "[PUSH][shown] user received notification id=$notificationId title=\"$title\"")
    }

    private fun buildNotification(
        context: Context,
        title: String,
        displayBody: String,
        payload: String,
        notificationId: Int,
    ) =
        NotificationCompat
            .Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_notify)
            .setContentTitle(title)
            .setContentText(displayBody)
            .setStyle(NotificationCompat.BigTextStyle().bigText(displayBody))
            .setDefaults(NotificationCompat.DEFAULT_ALL)
            .setVibrate(longArrayOf(0, 250, 250, 250))
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setColor(Color.parseColor("#01AF55"))
            .setContentIntent(createTapPendingIntent(context, payload, notificationId))
            .build()

    private fun createTapPendingIntent(
        context: Context,
        payload: String,
        notificationId: Int,
    ): PendingIntent {
        val intent =
            Intent(context, MainActivity::class.java).apply {
                action = SELECT_NOTIFICATION
                flags =
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
                putExtra(NOTIFICATION_ID_KEY, notificationId)
                putExtra(PAYLOAD_KEY, payload)
            }

        return PendingIntent.getActivity(
            context,
            PENDING_INTENT_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    fun isAppInForeground(context: Context): Boolean {
        val keyguard = context.getSystemService(Context.KEYGUARD_SERVICE) as? android.app.KeyguardManager
        if (keyguard?.isKeyguardLocked == true) return false

        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val processes = activityManager.runningAppProcesses ?: return false
        for (process in processes) {
            if (process.processName == context.packageName) {
                return process.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND
            }
        }
        return false
    }

    fun persistNotificationPayload(context: Context, payload: String) {
        context
            .getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putString(PENDING_PAYLOAD_KEY, payload)
            .commit()
    }

    private fun ensureChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = context.getSystemService(NotificationManager::class.java)
        val existing = manager.getNotificationChannel(CHANNEL_ID)
        if (existing != null && existing.importance >= NotificationManager.IMPORTANCE_HIGH) return
        if (existing != null) {
            manager.deleteNotificationChannel(CHANNEL_ID)
        }
        val channel =
            NotificationChannel(CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_HIGH).apply {
                description = "Plant care reminder notifications"
                enableVibration(true)
                enableLights(true)
                lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
                setShowBadge(true)
            }
        manager.createNotificationChannel(channel)
    }

    private fun areNotificationsEnabled(context: Context): Boolean {
        return try {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val stored = prefs.all[FLUTTER_NOTIFICATIONS_ENABLED_KEY]
                ?: prefs.all[NOTIFICATIONS_ENABLED_KEY]
            when (stored) {
                is Boolean -> stored
                is String -> stored.equals("true", ignoreCase = true)
                is Number -> stored.toInt() != 0
                else -> true
            }
        } catch (e: Exception) {
            Log.w(TAG, "Could not read notifications_enabled, defaulting to on", e)
            true
        }
    }

    private fun isDuplicateMessage(context: Context, messageId: String): Boolean {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val lastId = prefs.getString(LAST_MESSAGE_ID_KEY, null) ?: return false
        val lastAt = prefs.getLong(LAST_MESSAGE_AT_KEY, 0L)
        val elapsed = System.currentTimeMillis() - lastAt
        return lastId == messageId && elapsed < DEDUPE_WINDOW_MS
    }

    private fun markMessageShown(context: Context, messageId: String) {
        context
            .getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putString(LAST_MESSAGE_ID_KEY, messageId)
            .putLong(LAST_MESSAGE_AT_KEY, System.currentTimeMillis())
            .apply()
    }

    fun payloadJsonFor(
        message: RemoteMessage,
        title: String,
        body: String,
    ): String {
        val data = message.data
        val json = JSONObject()
        for ((key, value) in data) {
            json.put(key, value)
        }
        if (!json.has("title")) json.put("title", title)
        if (!json.has("body")) json.put("body", body)
        json.put("openedFromNotification", true)

        val hasReminderData =
            data.containsKey("activity_type") ||
                data.containsKey("activityType") ||
                data.containsKey("user_plant_id") ||
                data.containsKey("userPlantId") ||
                data["type"] == "plant_reminder" ||
                data["action"] == "plant_reminder" ||
                data["type"] == "reminder" ||
                data["route"] == REMINDERS_ROUTE

        if (!hasReminderData) {
            json.put("type", "plant_reminder")
            json.put("route", REMINDERS_ROUTE)
        }

        return json.toString()
    }
}
