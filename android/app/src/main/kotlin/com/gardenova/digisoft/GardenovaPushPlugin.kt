package com.gardenova.digisoft

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class GardenovaPushPlugin(
    private val context: Context,
) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "showNotification" -> {
                val title = call.argument<String>("title").orEmpty()
                val body = call.argument<String>("body").orEmpty()
                val payload = call.argument<String>("payload").orEmpty()
                val id = call.argument<Int>("id") ?: 0
                if (title.isNotEmpty() && body.isNotEmpty()) {
                    GardenovaPushNotifier.show(context, title, body, payload, id)
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    companion object {
        private const val CHANNEL = "com.gardenova.digisoft/push"

        fun register(messenger: BinaryMessenger, context: Context) {
            MethodChannel(messenger, CHANNEL).setMethodCallHandler(GardenovaPushPlugin(context))
        }
    }
}
