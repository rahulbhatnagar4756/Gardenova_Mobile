package com.gardenova.digisoft

import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.firebase.messaging.RemoteMessage
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingReceiver

/**
 * Shows one native tray notification with an explicit MainActivity PendingIntent.
 * FCM may also auto-post a non-tappable tray entry for notification payloads; that entry
 * is cleared in [GardenovaPushNotifier] so only the tappable notification remains.
 */
class GardenovaMessagingReceiver : FlutterFirebaseMessagingReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        try {
            val extras = intent.extras
            if (extras != null && !GardenovaPushNotifier.isAppInForeground(context)) {
                GardenovaPushNotifier.showFromRemoteMessage(context, RemoteMessage(extras))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to post native push notification", e)
        }

        super.onReceive(context, intent)
    }

    companion object {
        private const val TAG = "GardenovaFcmReceiver"
    }
}
