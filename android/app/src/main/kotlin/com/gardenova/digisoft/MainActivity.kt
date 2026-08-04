package com.gardenova.digisoft

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GardenovaPushPlugin.register(flutterEngine.dartExecutor.binaryMessenger, this)
        GardenovaPushBridge.register(flutterEngine.dartExecutor.binaryMessenger)
        GardenovaAlternateBillingPlugin.register(flutterEngine.dartExecutor.binaryMessenger, this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        deliverLaunchIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        deliverLaunchIntent(intent)
    }

    private fun deliverLaunchIntent(intent: Intent?) {
        if (intent == null) return

        val payload = intent.getStringExtra(PAYLOAD_KEY)
        if (payload.isNullOrBlank()) return

        GardenovaPushNotifier.persistNotificationPayload(this, payload)
        GardenovaPushBridge.notifyTap(payload)

        intent.removeExtra(PAYLOAD_KEY)
        intent.removeExtra(NOTIFICATION_ID_KEY)
        intent.action = Intent.ACTION_MAIN
        setIntent(intent)
    }

    companion object {
        private const val TAG = "MainActivity"
        private const val NOTIFICATION_ID_KEY = "notificationId"
        private const val PAYLOAD_KEY = "payload"
    }
}
