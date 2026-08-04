package com.gardenova.digisoft

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/** Sends notification tap events from Android to Flutter immediately. */
object GardenovaPushBridge {
    private const val CHANNEL = "com.gardenova.digisoft/push_events"
    private var channel: MethodChannel? = null

    fun register(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, CHANNEL)
    }

    fun notifyTap(payload: String) {
        channel?.invokeMethod("onNotificationTap", payload)
    }
}
