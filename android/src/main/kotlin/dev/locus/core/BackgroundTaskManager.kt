package dev.locus.core

import android.content.Context
import android.os.PowerManager
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.atomic.AtomicInteger

class BackgroundTaskManager(context: Context) {

    private val powerManager = context.getSystemService(Context.POWER_SERVICE) as? PowerManager
    private val taskCounter = AtomicInteger(1)
    private val tasks = ConcurrentHashMap<Int, PowerManager.WakeLock>()

    fun start(): Int {
        powerManager ?: return 0
        
        if (tasks.size > MAX_TASKS) {
            release() // defensive cleanup to avoid unbounded wake locks
        }
        
        val taskId = taskCounter.getAndIncrement()
        val wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "$TAG:bgTask:$taskId"
        ).apply {
            acquire(WAKE_LOCK_TIMEOUT_MS)
        }
        tasks[taskId] = wakeLock
        return taskId
    }

    fun stop(taskId: Int) {
        tasks.remove(taskId)?.let { wakeLock ->
            if (wakeLock.isHeld) {
                wakeLock.release()
            }
        }
    }

    fun release() {
        tasks.values.forEach { wakeLock ->
            if (wakeLock.isHeld) {
                wakeLock.release()
            }
        }
        tasks.clear()
    }

    companion object {
        private const val TAG = "locus"
        private const val MAX_TASKS = 50
        private const val WAKE_LOCK_TIMEOUT_MS = 10 * 60 * 1000L
    }
}
