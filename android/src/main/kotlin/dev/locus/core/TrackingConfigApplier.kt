package dev.locus.core

import dev.locus.activity.MotionManager
import dev.locus.geofence.GeofenceManager
import dev.locus.location.LocationClient

class TrackingConfigApplier(
    private val config: ConfigManager,
    private val motionManager: MotionManager,
    private val geofenceManager: GeofenceManager,
    private val locationClient: LocationClient,
    private val restartHeartbeat: () -> Unit
) {
    fun apply(configMap: Map<String, Any>?, isEnabled: Boolean) {
        configMap ?: return

        val previousHeartbeatInterval = config.heartbeatIntervalSeconds
        config.applyConfig(configMap)

        if (configMap.containsKey("maxMonitoredGeofences")) {
            geofenceManager.setMaxMonitoredGeofences(config.maxMonitoredGeofences)
        }

        if (isEnabled) {
            if (config.disableMotionActivityUpdates) {
                motionManager.stop()
            } else {
                motionManager.start()
            }
            locationClient.updateRequest(motionManager.isMoving)

            if (configMap.containsKey("heartbeatInterval") &&
                previousHeartbeatInterval != config.heartbeatIntervalSeconds
            ) {
                restartHeartbeat()
            }
        }
    }
}
