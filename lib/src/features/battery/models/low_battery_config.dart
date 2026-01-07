/// Configuration for low battery behavior.
library;

/// Configuration for low battery optimization.
///
/// Defines thresholds and behavior when battery level is low.
///
/// Example:
/// ```dart
/// final config = Config(
///   lowBattery: LowBatteryConfig(
///     threshold: 0.20, // 20%
///     throttleInterval: Duration(minutes: 10),
///     disableAutoSync: true,
///   ),
/// );
/// ```
class LowBatteryConfig {
  /// Creates a low battery configuration.
  const LowBatteryConfig({
    this.threshold = 0.15,
    this.throttleInterval = const Duration(minutes: 5),
    this.disableAutoSync = false,
  });

  /// Creates from a map.
  factory LowBatteryConfig.fromMap(Map<String, dynamic> map) {
    return LowBatteryConfig(
      threshold: (map['threshold'] as num?)?.toDouble() ?? 0.15,
      throttleInterval: Duration(
        milliseconds: (map['throttleInterval'] as num?)?.toInt() ?? 300000,
      ),
      disableAutoSync: map['disableAutoSync'] as bool? ?? false,
    );
  }

  /// Battery level threshold (0.0 to 1.0) at which low battery mode activates.
  ///
  /// Default is 0.15 (15%).
  final double threshold;

  /// Interval between location updates when in low battery mode.
  ///
  /// Longer intervals save more battery.
  final Duration throttleInterval;

  /// Whether to disable automatic sync when battery is low.
  ///
  /// When true, sync only happens manually or when charging.
  final bool disableAutoSync;

  /// Default configuration with 15% threshold.
  static const LowBatteryConfig defaultConfig = LowBatteryConfig();

  /// Aggressive battery saving at 20% threshold.
  static const LowBatteryConfig aggressive = LowBatteryConfig(
    threshold: 0.20,
    throttleInterval: Duration(minutes: 10),
    disableAutoSync: true,
  );

  /// Conservative - only activate at very low battery.
  static const LowBatteryConfig conservative = LowBatteryConfig(
    threshold: 0.10,
    throttleInterval: Duration(minutes: 3),
    disableAutoSync: false,
  );

  /// Converts to a JSON-serializable map.
  Map<String, dynamic> toMap() {
    return {
      'threshold': threshold,
      'throttleInterval': throttleInterval.inMilliseconds,
      'disableAutoSync': disableAutoSync,
    };
  }

  /// Creates a copy with the given fields replaced.
  LowBatteryConfig copyWith({
    double? threshold,
    Duration? throttleInterval,
    bool? disableAutoSync,
  }) {
    return LowBatteryConfig(
      threshold: threshold ?? this.threshold,
      throttleInterval: throttleInterval ?? this.throttleInterval,
      disableAutoSync: disableAutoSync ?? this.disableAutoSync,
    );
  }

  @override
  String toString() =>
      'LowBatteryConfig(threshold: $threshold, throttleInterval: $throttleInterval, disableAutoSync: $disableAutoSync)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LowBatteryConfig &&
        other.threshold == threshold &&
        other.throttleInterval == throttleInterval &&
        other.disableAutoSync == disableAutoSync;
  }

  @override
  int get hashCode =>
      threshold.hashCode ^ throttleInterval.hashCode ^ disableAutoSync.hashCode;
}
