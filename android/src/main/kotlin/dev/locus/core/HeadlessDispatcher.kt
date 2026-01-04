package dev.locus.core

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import dev.locus.service.HeadlessService
import org.json.JSONObject

class HeadlessDispatcher(
    private val context: Context,
    private val config: ConfigManager,
    private val prefs: SharedPreferences?
) {
    fun dispatch(event: Map<String, Any>) {
        if (!config.enableHeadless || prefs == null) {
            return
        }
        
        val dispatcher = prefs.getLong(KEY_HEADLESS_DISPATCHER, 0L)
        val callback = prefs.getLong(KEY_HEADLESS_CALLBACK, 0L)
        
        if (dispatcher == 0L || callback == 0L) {
            return
        }
        
        runCatching {
            val payload = JSONObject(event)
            Intent(context, HeadlessService::class.java).apply {
                putExtra("dispatcher", dispatcher)
                putExtra("callback", callback)
                putExtra("event", payload.toString())
            }.also { intent ->
                HeadlessService.enqueueWork(context, intent)
            }
        }
    }

    companion object {
        private const val KEY_HEADLESS_DISPATCHER = "bg_headless_dispatcher"
        private const val KEY_HEADLESS_CALLBACK = "bg_headless_callback"
    }
}
