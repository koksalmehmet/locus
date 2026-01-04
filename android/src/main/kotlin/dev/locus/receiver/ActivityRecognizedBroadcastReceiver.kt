package dev.locus.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.android.gms.location.ActivityRecognitionResult
import com.google.android.gms.location.DetectedActivity
import dev.locus.LocusPlugin
import dev.locus.service.HeadlessService
import org.json.JSONException
import org.json.JSONObject

class ActivityRecognizedBroadcastReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "ActivityReceiver"

        private fun getActivityString(type: Int): String = when (type) {
            DetectedActivity.IN_VEHICLE -> "inVehicle"
            DetectedActivity.ON_BICYCLE -> "onBicycle"
            DetectedActivity.ON_FOOT -> "onFoot"
            DetectedActivity.RUNNING -> "running"
            DetectedActivity.STILL -> "still"
            DetectedActivity.TILTING -> "tilting"
            DetectedActivity.WALKING -> "walking"
            else -> "unknown"
        }
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (context == null) {
            Log.w(TAG, "Received null context")
            return
        }
        if (intent == null) {
            Log.w(TAG, "Received null intent")
            return
        }

        val result = ActivityRecognitionResult.extractResult(intent)
        if (result == null) {
            Log.w(TAG, "ActivityRecognitionResult is null from intent")
            return
        }

        val activities = result.probableActivities
        if (activities.isNullOrEmpty()) {
            Log.w(TAG, "No detected activities available")
            return
        }

        // Pick the most confident activity
        val mostLikely = activities.maxByOrNull { it.confidence } ?: activities.first()

        val type = getActivityString(mostLikely.type)
        val confidence = mostLikely.confidence
        val data = "$type,$confidence"

        // Forward to plugin via SharedPreferences
        val preferences = context.getSharedPreferences(LocusPlugin.PREFS_NAME, Context.MODE_PRIVATE)

        preferences.edit()
            .putString(LocusPlugin.KEY_ACTIVITY_EVENT, data)
            .apply()

        // Dispatch to headless service if enabled
        if (preferences.getBoolean("bg_enable_headless", false)) {
            val dispatcher = preferences.getLong("bg_headless_dispatcher", 0L)
            val callback = preferences.getLong("bg_headless_callback", 0L)
            if (dispatcher != 0L && callback != 0L) {
                try {
                    val activity = JSONObject().apply {
                        put("type", type)
                        put("confidence", confidence)
                    }
                    val payload = JSONObject().apply {
                        put("activity", activity)
                    }
                    val eventPayload = JSONObject().apply {
                        put("type", "activitychange")
                        put("data", payload)
                    }

                    val headlessIntent = Intent(context, HeadlessService::class.java).apply {
                        putExtra("dispatcher", dispatcher)
                        putExtra("callback", callback)
                        putExtra("event", eventPayload.toString())
                    }
                    HeadlessService.enqueueWork(context, headlessIntent)
                } catch (e: JSONException) {
                    Log.w(TAG, "Failed to build headless activity payload", e)
                }
            }
        }
    }
}
