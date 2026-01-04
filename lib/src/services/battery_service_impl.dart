/// Battery service implementation for v2.0 API.
library;

import 'dart:async';

import 'package:locus/src/models.dart';
import 'package:locus/src/core/locus_interface.dart';
import 'package:locus/src/services/battery_service.dart';

/// Implementation of [BatteryService] using method channel.
class BatteryServiceImpl implements BatteryService {
  /// Creates a battery service with the given Locus interface provider.
  BatteryServiceImpl(this._instanceProvider);

  final LocusInterface Function() _instanceProvider;

  LocusInterface get _instance => _instanceProvider();

  @override
  Stream<PowerStateChangeEvent> get powerStateEvents =>
      _instance.powerStateStream;

  @override
  Stream<bool> get powerSaveChanges => _instance.powerSaveStream;

  @override
  Future<BatteryStats> getStats() => _instance.getBatteryStats();

  @override
  Future<PowerState> getPowerState() => _instance.getPowerState();

  @override
  Future<BatteryRunway> estimateRunway() => _instance.estimateBatteryRunway();

  @override
  Future<void> setAdaptiveTracking(AdaptiveTrackingConfig config) =>
      _instance.setAdaptiveTracking(config);

  @override
  AdaptiveTrackingConfig? get adaptiveTrackingConfig =>
      _instance.adaptiveTrackingConfig;

  @override
  Future<AdaptiveSettings> calculateAdaptiveSettings() =>
      _instance.calculateAdaptiveSettings();

  // ============================================================
  // Benchmark
  // ============================================================

  @override
  Future<void> startBenchmark() => _instance.startBatteryBenchmark();

  @override
  Future<BenchmarkResult?> stopBenchmark() => _instance.stopBatteryBenchmark();

  @override
  void recordBenchmarkLocationUpdate({double? accuracy}) =>
      _instance.recordBenchmarkLocationUpdate(accuracy: accuracy);

  @override
  void recordBenchmarkSync() => _instance.recordBenchmarkSync();

  // ============================================================
  // Subscriptions
  // ============================================================

  @override
  StreamSubscription<PowerStateChangeEvent> onPowerStateChange(
    void Function(PowerStateChangeEvent event) callback, {
    Function? onError,
  }) =>
      _instance.onPowerStateChangeWithObj(callback, onError: onError);

  @override
  StreamSubscription<bool> onPowerSaveChange(
    void Function(bool) callback, {
    Function? onError,
  }) =>
      _instance.onPowerSaveChange(callback, onError: onError);
}
