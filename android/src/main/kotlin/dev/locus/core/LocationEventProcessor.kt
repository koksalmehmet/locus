package dev.locus.core

class LocationEventProcessor(
    private val config: ConfigManager,
    private val stateManager: StateManager,
    private val syncManager: SyncManager,
    private val eventDispatcher: EventDispatcher,
    private val autoSyncChecker: AutoSyncChecker
) {
    fun dispatch(eventName: String, payload: Map<String, Any>) {
        val event = mapOf(
            "type" to eventName,
            "data" to payload
        )
        eventDispatcher.sendEvent(event)

        if (!config.privacyModeEnabled) {
            if (PersistencePolicy.shouldPersist(config, eventName)) {
                stateManager.storeLocationPayload(payload, config.maxDaysToPersist, config.maxRecordsToPersist)
            }
            if (config.autoSync && !config.httpUrl.isNullOrEmpty() && autoSyncChecker.isAutoSyncAllowed()) {
                if (config.batchSync) {
                    syncManager.attemptBatchSync()
                } else {
                    syncManager.syncNow(payload)
                }
            }
        }
    }

    fun syncNow(payload: Map<String, Any>?) {
        syncManager.syncNow(payload)
    }
}
