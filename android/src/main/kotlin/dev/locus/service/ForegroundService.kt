package dev.locus.service

import android.annotation.TargetApi
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import dev.locus.receiver.NotificationActionReceiver

class ForegroundService : Service() {

    companion object {
        private const val TAG = "ForegroundService"
    }

    override fun onCreate() {
        super.onCreate()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val extras = intent?.extras
        if (extras != null) {
            startPluginForegroundService(extras)
        } else {
            Log.e(TAG, "Attempted to start foreground service with null intent or extras.")
            stopSelf(startId)
            return START_NOT_STICKY
        }
        return START_STICKY
    }

    @TargetApi(26)
    private fun startPluginForegroundService(extras: Bundle) {
        val context = applicationContext
        val channelId = "foreground.service.channel"

        // Get notification channel importance
        val importanceValue = extras.getInt("importance", 1)
        val importance = when (importanceValue) {
            2 -> NotificationManager.IMPORTANCE_DEFAULT
            3 -> NotificationManager.IMPORTANCE_HIGH
            else -> NotificationManager.IMPORTANCE_LOW
        }

        // Create notification channel
        val channel = NotificationChannel(
            channelId,
            "Background Services",
            importance
        ).apply {
            description = "Enables background processing for motion detection."
        }
        getSystemService(NotificationManager::class.java)?.createNotificationChannel(channel)

        // Get notification icon
        val iconName = extras.getString("icon")
        var icon = 0
        if (iconName != null) {
            icon = resources.getIdentifier(iconName, "drawable", context.packageName)
        }
        if (icon == 0) {
            icon = resources.getIdentifier("ic_launcher", "mipmap", context.packageName)
        }

        val builder = Notification.Builder(context, channelId)
            .setContentTitle(extras.getString("title"))
            .setContentText(extras.getString("text"))
            .setOngoing(true)
            .setSmallIcon(if (icon != 0) icon else 17301514) // Default is the star icon

        // Add notification actions if present
        extras.getStringArray("actions")?.forEach { actionId ->
            val actionIntent = Intent(context, NotificationActionReceiver::class.java).apply {
                action = actionId
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                actionId.hashCode(),
                actionIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            builder.addAction(0, actionId, pendingIntent)
        }

        val notification = builder.build()
        val id = extras.getInt("id", 197812504)

        // Put service in foreground and show notification
        // Android 14 (API 34) requires specifying the foreground service type
        when {
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE -> {
                startForeground(id, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
            }
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q -> {
                // Android 10+ supports foreground service types
                startForeground(id, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
            }
            else -> {
                // Fallback for older Android versions
                startForeground(id, notification)
            }
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
