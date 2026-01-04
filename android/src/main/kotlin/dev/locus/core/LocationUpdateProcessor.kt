package dev.locus.core

import android.location.Location

class LocationUpdateProcessor(
    private val stateManager: StateManager,
    private val trackingStats: TrackingStats,
    private val payloadBuilder: LocationPayloadBuilder,
    private val eventProcessor: LocationEventProcessor,
    private val logManager: LogManager
) {
    fun handleLocation(location: Location) {
        stateManager.updateOdometer(location)
        trackingStats.onLocationUpdate(location.accuracy)
        val payload = payloadBuilder.build(location, "location")
        eventProcessor.dispatch("location", payload)
    }

    fun handleError(message: String) {
        logManager.log("error", "Location error: $message")
    }
}
