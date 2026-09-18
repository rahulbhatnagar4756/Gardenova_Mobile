package com.gardenova.digisoft

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.util.Log
import com.google.firebase.messaging.FirebaseMessaging

class GardenovaApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        setupCrashFiltering()
        createNotificationChannels()
        disableFcmNotificationDelegation()
    }

    /**
     * Intercepts and ignores non-actionable crashes before they reach Firebase Crashlytics.
     * Specifically filters ABI mismatch errors (ARM64 vs x86_64) commonly caused by
     * bots or incorrect emulator architectures.
     */
    private fun setupCrashFiltering() {
        val defaultHandler = Thread.getDefaultUncaughtExceptionHandler()
        Thread.setDefaultUncaughtExceptionHandler { thread, throwable ->
            val msg = throwable.toString().lowercase()
            val isAbiMismatch = msg.contains("em_aarch64") && msg.contains("em_x86_64")
            val isProxyBillingNpe = msg.contains("proxybillingactivity") && msg.contains("nullpointerexception")

            if (isAbiMismatch || isProxyBillingNpe) {
                Log.e(TAG, "Intercepted non-actionable crash: $msg")
                // Terminate process silently without invoking the Crashlytics handler
                android.os.Process.killProcess(android.os.Process.myPid())
                System.exit(10)
            } else {
                defaultHandler?.uncaughtException(thread, throwable)
            }
        }
    }

    private fun disableFcmNotificationDelegation() {
        FirebaseMessaging.getInstance()
            .setNotificationDelegationEnabled(false)
            .addOnFailureListener { error ->
                Log.w(TAG, "Could not disable FCM notification delegation", error)
            }
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val channel = NotificationChannel(
            NOTIFICATION_CHANNEL_ID,
            "Plant Reminders",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = "Plant care reminder notifications"
            enableVibration(true)
        }

        val notificationManager = getSystemService(NotificationManager::class.java)
        notificationManager?.createNotificationChannel(channel)
    }

    companion object {
        private const val TAG = "GardenovaApplication"
        const val NOTIFICATION_CHANNEL_ID = "plant_reminders"
    }
}
