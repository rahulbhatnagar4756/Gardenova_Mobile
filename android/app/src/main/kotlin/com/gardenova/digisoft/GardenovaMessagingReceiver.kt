package com.gardenova.digisoft

import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.firebase.messaging.RemoteMessage
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingReceiver

/**
 * Background/terminated data-only messages are not shown by the system, so we
 * post a tray notification here. Notification-payload messages are left to the
 * OS (and [GardenovaFirebaseMessagingService] while the app is in the
 * foreground) so we never cancel a working system banner.
 */
class GardenovaMessagingReceiver : FlutterFirebaseMessagingReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        try {
            val extras = intent.extras
            if (extras != null) {
                val message = RemoteMessage(extras)
                val inForeground = GardenovaPushNotifier.isAppInForeground(context)
                val dataOnly = message.notification == null
                val title = message.notification?.title ?: message.data["title"].orEmpty()
                Log.i(
                    TAG,
                    "[PUSH][received] receiver id=${message.messageId} foreground=$inForeground " +
                        "dataOnly=$dataOnly title=\"$title\" data=${message.data}",
                )
                if (!inForeground && dataOnly) {
                    GardenovaPushNotifier.showFromRemoteMessage(context, message)
                } else {
                    Log.i(
                        TAG,
                        "[PUSH][skipped] receiver — OS/service will display " +
                            "(foreground=$inForeground dataOnly=$dataOnly)",
                    )
                }
            } else {
                Log.w(TAG, "[PUSH][skipped] receiver — intent had no extras")
            }
        } catch (e: Exception) {
            Log.e(TAG, "[PUSH][error] Failed to post native push notification", e)
        }

        super.onReceive(context, intent)
    }

    companion object {
        private const val TAG = "GardenovaFcmReceiver"
    }
}
