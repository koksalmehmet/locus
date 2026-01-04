package dev.locus.core

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.location.LocationManager
import android.util.Log
import androidx.core.content.ContextCompat

class LocationProviderMonitor(
    private val context: Context
) {
    fun interface Listener {
        fun onProviderChange()
    }

    private var listener: Listener? = null
    private var providerReceiver: BroadcastReceiver? = null

    fun setListener(listener: Listener?) {
        this.listener = listener
    }

    fun start() {
        registerProviderReceiver()
    }

    fun stop() {
        unregisterProviderReceiver()
    }

    fun buildProviderPayload(): Map<String, Any> {
        val locationEnabled = isLocationEnabled()
        return mapOf(
            "enabled" to locationEnabled,
            "status" to if (locationEnabled) "enabled" else "disabled",
            "availability" to if (locationEnabled) "available" else "unavailable",
            "authorizationStatus" to resolveAuthorizationStatus(),
            "accuracyAuthorization" to resolveAccuracyAuthorization()
        )
    }

    private fun isLocationEnabled(): Boolean {
        val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as? LocationManager
            ?: return false
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) ||
            locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
    }

    private fun resolveAuthorizationStatus(): String {
        if (!hasLocationPermission()) {
            return "denied"
        }
        val hasFine = ContextCompat.checkSelfPermission(
            context,
            android.Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        return if (hasFine) "always" else "whenInUse"
    }

    private fun resolveAccuracyAuthorization(): String {
        val hasFine = ContextCompat.checkSelfPermission(
            context,
            android.Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        return if (hasFine) "full" else "reduced"
    }

    private fun hasLocationPermission(): Boolean {
        val hasFine = ContextCompat.checkSelfPermission(
            context,
            android.Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        val hasCoarse = ContextCompat.checkSelfPermission(
            context,
            android.Manifest.permission.ACCESS_COARSE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        return hasFine || hasCoarse
    }

    private fun registerProviderReceiver() {
        if (providerReceiver != null) return

        providerReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                listener?.onProviderChange()
            }
        }

        val filter = IntentFilter(LocationManager.PROVIDERS_CHANGED_ACTION).apply {
            addAction(LocationManager.MODE_CHANGED_ACTION)
        }
        context.registerReceiver(providerReceiver, filter)
    }

    private fun unregisterProviderReceiver() {
        providerReceiver?.let { receiver ->
            try {
                context.unregisterReceiver(receiver)
            } catch (e: IllegalArgumentException) {
                // Receiver was already unregistered
                Log.w(TAG, "Provider receiver already unregistered")
            }
            providerReceiver = null
        }
    }

    companion object {
        private const val TAG = "locus"
    }
}
