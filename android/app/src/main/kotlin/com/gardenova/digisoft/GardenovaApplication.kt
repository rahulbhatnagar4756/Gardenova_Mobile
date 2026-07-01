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
        createNotificationChannels()
        disableFcmNotificationDelegation()
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
