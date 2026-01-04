package dev.locus.core

import dev.locus.storage.LogStore

class LogManager(
    private val config: ConfigManager,
    private val logStore: LogStore
) {

    fun log(level: String, message: String) {
        if (!shouldLog(level)) return
        logStore.append(level, message, config.logMaxDays)
    }

    private fun shouldLog(level: String): Boolean =
        logLevelRank(level) <= logLevelRank(config.logLevel)

    private fun logLevelRank(level: String): Int = when (level) {
        "off" -> 6
        "error" -> 0
        "warning" -> 1
        "info" -> 2
        "debug" -> 3
        "verbose" -> 4
        else -> 3
    }
}
