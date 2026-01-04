library;

/// Desired location accuracy level.
enum DesiredAccuracy {
  navigation,
  high,
  medium,
  low,
  veryLow,
  lowest,
}

/// Log level for debugging.
enum LogLevel {
  off,
  error,
  warning,
  info,
  debug,
  verbose,
}

/// Persistence mode for location data.
enum PersistMode {
  none,
  location,
  geofence,
  all,
}

/// Tracking profile for adaptive behavior.
enum LocusProfile {
  stationary,
  walking,
  driving,
  navigation,
  off,
}

/// Action to take when spoofing is detected.
enum SpoofDetectionAction {
  flag,
  ignore,
  stop,
}
