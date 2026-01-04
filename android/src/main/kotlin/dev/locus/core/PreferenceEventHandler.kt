package dev.locus.core

import android.content.SharedPreferences
import android.util.Log
import dev.locus.activity.MotionManager
import org.json.JSONException

class PreferenceEventHandler(
    private val config: ConfigManager,
    private val motionManager: MotionManager,
    private val geofenceEventProcessor: GeofenceEventProcessor,
    private val eventDispatcher: EventDispatcher
) {
    fun handlePreferenceChange(sharedPreferences: SharedPreferences, key: String?) {
        when (key) {
            KEY_ACTIVITY_EVENT -> handleActivityEvent(sharedPreferences)
            KEY_GEOFENCE_EVENT -> handleGeofenceEvent(sharedPreferences)
            KEY_NOTIFICATION_ACTION -> handleNotificationAction(sharedPreferences)
        }
    }

    private fun handleActivityEvent(sharedPreferences: SharedPreferences) {
        if (config.disableMotionActivityUpdates) return
        
        val raw = sharedPreferences.getString(KEY_ACTIVITY_EVENT, null) ?: return
        val tokens = raw.split(",")
        
        if (tokens.size >= 2) {
            try {
                val type = tokens[0]
                val confidence = tokens[1].toInt()
                motionManager.onActivityEvent(type, confidence)
            } catch (e: NumberFormatException) {
                Log.w(TAG, "Invalid activity event format: $raw")
            }
        }
    }

    private fun handleGeofenceEvent(sharedPreferences: SharedPreferences) {
        val raw = sharedPreferences.getString(KEY_GEOFENCE_EVENT, null) ?: return

        try {
            geofenceEventProcessor.handle(raw)
        } catch (e: JSONException) {
            Log.e(TAG, "Failed to parse geofence event: ${e.message}")
        }
    }

    private fun handleNotificationAction(sharedPreferences: SharedPreferences) {
        val action = sharedPreferences.getString(KEY_NOTIFICATION_ACTION, null) ?: return
        
        val event = mapOf(
            "type" to "notificationaction",
            "data" to action
        )
        eventDispatcher.sendEvent(event)
    }

    companion object {
        private const val TAG = "locus"
        private const val KEY_ACTIVITY_EVENT = "bg_activity_event"
        private const val KEY_GEOFENCE_EVENT = "bg_geofence_event"
        private const val KEY_NOTIFICATION_ACTION = "bg_notification_action"
    }
}
