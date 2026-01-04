package dev.locus.core

class TrackingEventEmitter(
    private val eventDispatcher: EventDispatcher,
    private val providerMonitor: LocationProviderMonitor
) {
    fun startProviderMonitoring() {
        providerMonitor.setListener { emitProviderChange() }
        providerMonitor.start()
    }

    fun stopProviderMonitoring() {
        providerMonitor.stop()
        providerMonitor.setListener(null)
    }

    fun emitProviderChange() {
        val payload = providerMonitor.buildProviderPayload()
        val event = mapOf(
            "type" to "providerchange",
            "data" to payload
        )
        eventDispatcher.sendEvent(event)
    }

    fun emitEnabledChange(enabled: Boolean) {
        val event = mapOf(
            "type" to "enabledchange",
            "data" to enabled
        )
        eventDispatcher.sendEvent(event)
    }
}
