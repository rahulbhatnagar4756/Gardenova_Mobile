package com.gardenova.digisoft

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/** Sends notification tap and foreground push events from Android to Flutter. */
object GardenovaPushBridge {
    private const val CHANNEL = "com.gardenova.digisoft/push_events"
    private var channel: MethodChannel? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    fun register(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, CHANNEL)
    }

    fun notifyTap(payload: String) {
        invokeOnMain("onNotificationTap", payload)
    }

    fun notifyForegroundMessage(payload: String) {
        if (payload.isBlank()) return
        invokeOnMain("onForegroundPush", payload)
    }

    private fun invokeOnMain(method: String, payload: String) {
        mainHandler.post {
            channel?.invokeMethod(method, payload)
        }
    }
}
