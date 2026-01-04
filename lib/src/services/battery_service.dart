/// Battery service interface for v2.0 API.
///
/// Provides a clean, organized API for battery optimization.
/// Access via `Locus.battery`.
library;

import 'dart:async';

import 'package:locus/src/models.dart';

/// Service interface for battery management and optimization.
///
/// Monitors battery state and provides adaptive tracking capabilities
/// to balance location accuracy with power consumption.
///
/// Example:
/// ```dart
/// // Get battery stats
/// final stats = await Locus.battery.getStats();
/// print('Battery: ${stats.level}%, Charging: ${stats.isCharging}');
///
/// // Estimate battery runway
/// final runway = await Locus.battery.estimateRunway();
/// print('Tracking time remaining: ${runway.formattedDuration}');
///
/// // Set adaptive tracking
/// await Locus.battery.setAdaptiveTracking(
///   AdaptiveTrackingConfig.aggressive,
/// );
///
/// // Listen to power state changes
/// Locus.battery.powerStateEvents.listen((event) {
///   if (event.powerState.isPowerSaveMode) {
///     print('Power save mode activated');
///   }
/// });
/// ```
abstract class BatteryService {
  /// Stream of power state changes.
  Stream<PowerStateChangeEvent> get powerStateEvents;

  /// Stream of power save mode changes.
  Stream<bool> get powerSaveChanges;

  /// Gets current battery statistics.
  Future<BatteryStats> getStats();

  /// Gets current power state.
  Future<PowerState> getPowerState();

  /// Estimates remaining battery runway for location tracking.
  ///
  /// Returns predictions for how long tracking can continue at
  /// current and low power consumption rates.
  Future<BatteryRunway> estimateRunway();

  /// Sets adaptive tracking configuration.
  ///
  /// Adaptive tracking dynamically adjusts location settings based on
  /// speed, battery level, and activity to optimize power consumption.
  Future<void> setAdaptiveTracking(AdaptiveTrackingConfig config);

  /// Gets the current adaptive tracking configuration.
  AdaptiveTrackingConfig? get adaptiveTrackingConfig;

  /// Calculates optimal settings based on current conditions.
  Future<AdaptiveSettings> calculateAdaptiveSettings();

  // ============================================================
  // Benchmark
  // ============================================================

  /// Starts a battery benchmark test.
  Future<void> startBenchmark();

  /// Stops the battery benchmark and returns results.
  Future<BenchmarkResult?> stopBenchmark();

  /// Records a location update for benchmarking.
  void recordBenchmarkLocationUpdate({double? accuracy});

  /// Records a sync event for benchmarking.
  void recordBenchmarkSync();

  // ============================================================
  // Subscriptions
  // ============================================================

  /// Subscribes to power state change events.
  StreamSubscription<PowerStateChangeEvent> onPowerStateChange(
    void Function(PowerStateChangeEvent event) callback, {
    Function? onError,
  });

  /// Subscribes to power save mode changes.
  StreamSubscription<bool> onPowerSaveChange(
    void Function(bool) callback, {
    Function? onError,
  });
}
