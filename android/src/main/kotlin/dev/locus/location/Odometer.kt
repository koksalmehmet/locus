package dev.locus.location

import android.content.Context
import android.content.SharedPreferences
import android.location.Location
import dev.locus.LocusPlugin

class Odometer(context: Context) {

    private val prefs: SharedPreferences =
        context.getSharedPreferences(LocusPlugin.PREFS_NAME, Context.MODE_PRIVATE)

    private var odometer: Double = readOdometer()
    private var lastLocation: Location? = null

    val distance: Double
        get() = odometer

    @Synchronized
    fun update(newLocation: Location) {
        val last = lastLocation
        if (last == null) {
            lastLocation = newLocation
            return
        }

        val distance = newLocation.distanceTo(last)
        // Basic filter: ignore huge jumps > 100km or tiny < 1m if needed,
        // but for now let's just accumulate.
        odometer += distance
        lastLocation = newLocation
        writeOdometer(odometer)
    }

    fun setDistance(distance: Double) {
        odometer = distance
        writeOdometer(distance)
        // Reset last location reference to avoid adding distance from a discontinuity
        lastLocation = null
    }

    private fun readOdometer(): Double {
        return prefs.getFloat(KEY_ODOMETER, 0.0f).toDouble()
    }

    private fun writeOdometer(value: Double) {
        prefs.edit().putFloat(KEY_ODOMETER, value.toFloat()).apply()
    }

    companion object {
        private const val KEY_ODOMETER = "bg_odometer"
    }
}
