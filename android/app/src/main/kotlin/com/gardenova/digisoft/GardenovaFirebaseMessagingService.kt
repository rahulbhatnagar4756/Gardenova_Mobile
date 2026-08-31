package com.gardenova.digisoft

import android.util.Log
import com.google.firebase.messaging.RemoteMessage
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService

/**
 * FCM delivers foreground messages (and data-only messages in every state)
 * here. Always post a tray notification — the system does not auto-display
 * while the app is open.
 */
class GardenovaFirebaseMessagingService : FlutterFirebaseMessagingService() {
    override fun onMessageReceived(message: RemoteMessage) {
        val title = message.notification?.title ?: message.data["title"].orEmpty()
        val body =
            message.notification?.body
                ?: message.data["body"]
                ?: message.data["message"].orEmpty()
        Log.i(
            TAG,
            "[PUSH][received] service id=${message.messageId} " +
                "hasNotification=${message.notification != null} title=\"$title\" body=\"$body\" data=${message.data}",
        )
        try {
            GardenovaPushNotifier.showFromRemoteMessage(applicationContext, message)
        } catch (e: Exception) {
            Log.e(TAG, "[PUSH][error] Failed to show push notification", e)
        }
        try {
            GardenovaPushBridge.notifyForegroundMessage(
                GardenovaPushNotifier.payloadJsonFor(message, title, body),
            )
        } catch (e: Exception) {
            Log.e(TAG, "[PUSH][error] Failed to notify Flutter of foreground push", e)
        }
        super.onMessageReceived(message)
    }

    companion object {
        private const val TAG = "GardenovaFcmService"
    }
}
