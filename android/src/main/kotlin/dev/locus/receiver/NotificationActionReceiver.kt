package dev.locus.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import dev.locus.LocusPlugin
import dev.locus.service.HeadlessService
import org.json.JSONException
import org.json.JSONObject

class NotificationActionReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "NotificationAction"
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (context == null) return

        val action = intent?.action ?: return

        val preferences = context.getSharedPreferences(LocusPlugin.PREFS_NAME, Context.MODE_PRIVATE)

        preferences.edit()
            .putString(LocusPlugin.KEY_NOTIFICATION_ACTION, action)
            .apply()

        // Dispatch to headless service if enabled
        if (preferences.getBoolean("bg_enable_headless", false)) {
            val dispatcher = preferences.getLong("bg_headless_dispatcher", 0L)
            val callback = preferences.getLong("bg_headless_callback", 0L)
            if (dispatcher != 0L && callback != 0L) {
                try {
                    val eventPayload = JSONObject().apply {
                        put("type", "notificationaction")
                        put("data", action)
                    }

                    val headlessIntent = Intent(context, HeadlessService::class.java).apply {
                        putExtra("dispatcher", dispatcher)
                        putExtra("callback", callback)
                        putExtra("event", eventPayload.toString())
                    }
                    HeadlessService.enqueueWork(context, headlessIntent)
                } catch (e: JSONException) {
                    Log.w(TAG, "Failed to build headless action payload", e)
                }
            }
        }
    }
}
