# Adaptive Tracking

## Overview

Adaptive Tracking automatically adjusts location sampling rate based on device battery state and movement patterns. It provides intelligent battery optimization while maintaining location accuracy.

## How It Works

Adaptive Tracking monitors:
- Battery level and charging state
- Device activity (stationary vs. moving)
- Location quality and signal strength
- Power profile settings

Based on these inputs, it dynamically adjusts:
- Location sampling frequency
- GPS accuracy mode
- Update intervals
- Sync policies

## Using Adaptive Tracking

Enable adaptive tracking with the battery service:

```dart
import 'package:locus/locus.dart';

await Locus.battery.setAdaptiveTracking(AdaptiveTrackingConfig.balanced);
```

## Presets and Customization

Locus provides presets for common use cases:

```dart
await Locus.battery.setAdaptiveTracking(AdaptiveTrackingConfig.balanced);
await Locus.battery.setAdaptiveTracking(AdaptiveTrackingConfig.aggressive);
```

For custom tuning:

```dart
final adaptiveConfig = AdaptiveTrackingConfig(
  speedTiers: SpeedTiers.driving,
  batteryThresholds: BatteryThresholds.conservative,
  stationaryGpsOff: true,
  stationaryDelay: Duration(minutes: 2),
  smartHeartbeat: true,
);

await Locus.battery.setAdaptiveTracking(adaptiveConfig);
```

## Monitoring Adaptive Settings

```dart
final config = Locus.battery.adaptiveTrackingConfig;
print('Adaptive tracking enabled: ${config?.enabled}');

final settings = await Locus.battery.calculateAdaptiveSettings();
print('Suggested distance filter: ${settings.distanceFilter}');
print('Suggested accuracy: ${settings.desiredAccuracy}');
print('Reason: ${settings.reason}');
```

## Runway Calculations

Battery runway shows how long the device can maintain tracking:

```dart
final runway = await Locus.battery.estimateRunway();
print('Estimated duration: ${runway.formattedDuration}');
print('Recommendation: ${runway.recommendation}');
```

## Manual Control

You can also override tracking parameters directly:

```dart
await Locus.setConfig(const Config(
  desiredAccuracy: DesiredAccuracy.high,
  distanceFilter: 0,
  heartbeatInterval: 60,
));
```

**Next:** [Advanced Configuration](configuration.md)
