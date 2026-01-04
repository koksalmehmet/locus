package dev.locus.core

import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import dev.locus.service.ForegroundService

class ForegroundServiceController(private val context: Context) {

    fun start(config: ConfigManager) {
        val intent = Intent(context, ForegroundService::class.java).apply {
            putExtra("title", config.notificationTitle)
            putExtra("text", config.notificationText)
            putExtra("icon", config.notificationIcon)
            putExtra("id", config.notificationId)
            putExtra("importance", config.notificationImportance)
            
            config.notificationActions?.takeIf { it.isNotEmpty() }?.let { actions ->
                putExtra("actions", actions.toTypedArray())
            }
        }

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        } catch (e: Exception) {
            Log.w(TAG, "Failed to start foreground service: ${e.message}")
        }
    }

    fun stop() {
        val intent = Intent(context, ForegroundService::class.java)
        context.stopService(intent)
    }

    companion object {
        private const val TAG = "ForegroundServiceController"
    }
}
