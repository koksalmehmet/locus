package dev.locus.core

fun interface AutoSyncChecker {
    fun isAutoSyncAllowed(): Boolean
}
