package dev.locus.core

/**
 * Determines whether location events should be persisted based on configuration.
 */
object PersistencePolicy {

    fun shouldPersist(config: ConfigManager, eventName: String?): Boolean = when {
        config.batchSync -> true
        config.persistMode == "none" -> false
        config.persistMode == "all" -> true
        config.persistMode == "geofence" -> eventName == "geofence"
        config.persistMode == "location" -> eventName != "geofence"
        else -> false
    }
}
