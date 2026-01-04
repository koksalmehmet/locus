package dev.locus.core

import android.os.Build
import android.util.Log
import dev.locus.activity.MotionManager
import dev.locus.geofence.GeofenceManager
import dev.locus.location.LocationClient

class TrackingLifecycleController(
    private val config: ConfigManager,
    private val locationClient: LocationClient,
    private val motionManager: MotionManager,
    private val geofenceManager: GeofenceManager,
    private val foregroundServiceController: ForegroundServiceController,
    private val trackingEventEmitter: TrackingEventEmitter,
    private val logManager: LogManager,
    private val trackingStats: TrackingStats
) {
    fun start(): Boolean {
        if (!locationClient.hasPermission()) {
            Log.w(TAG, "Location permission missing; tracking not started.")
            return false
        }

        trackingStats.onTrackingStart()

        if (config.foregroundService && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            foregroundServiceController.start(config)
        }

        motionManager.start()
        locationClient.start()
        geofenceManager.startGeofencesInternal()
        trackingEventEmitter.startProviderMonitoring()
        trackingEventEmitter.emitProviderChange()
        trackingEventEmitter.emitEnabledChange(true)
        logManager.log("info", "start")
        return true
    }

    fun stop() {
        trackingStats.onTrackingStop()
        motionManager.stop()
        locationClient.stop()
        foregroundServiceController.stop()
        trackingEventEmitter.stopProviderMonitoring()
        trackingEventEmitter.emitEnabledChange(false)
        logManager.log("info", "stop")
    }

    fun onMotionChange(isMoving: Boolean) {
        trackingStats.onMotionChange(isMoving)
    }

    fun shutdown() {
        motionManager.stop()
        locationClient.stop()
        foregroundServiceController.stop()
        trackingEventEmitter.stopProviderMonitoring()
    }

    companion object {
        private const val TAG = "locus"
    }
}
