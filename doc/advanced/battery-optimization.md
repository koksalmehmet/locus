# Battery Optimization

Locus includes sophisticated battery optimization features that automatically adjust tracking behavior based on device conditions and user activity.

## Adaptive Tracking

Adaptive tracking automatically adjusts location accuracy and update frequency based on:

- Current battery level
- Device charging state
- User activity (stationary, walking, driving)
- Movement speed

### Enabling Adaptive Tracking

```dart
await Locus.battery.setAdaptiveTracking(AdaptiveTrackingConfig.balanced);
```

### Adaptive Configuration

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

## Battery Runway

Battery runway estimates how long tracking can continue at current power consumption:

```dart
final runway = await Locus.battery.estimateRunway();
print('Estimated tracking time remaining: ${runway.formattedDuration}');
print('Current drain rate: ${runway.drainRatePerHour}%/hr');
```

### Runway Calculator

For more detailed estimates:

```dart
final estimate = BatteryRunwayCalculator.calculate(
  currentLevel: 75,
  isCharging: false,
  drainPercent: 4.0,
  trackingMinutes: 60,
);

print('At current settings: ${estimate.duration}');
print('Recommendation: ${estimate.recommendation}');
```

## Power State Monitoring

Monitor device power state changes:

```dart
Locus.battery.powerStateEvents.listen((event) {
  final state = event.current;
  print('Battery: ${state.batteryLevel}%');
  print('Charging: ${state.isCharging}');
  print('Power save mode: ${state.isPowerSaveMode}');
});
```

## Tracking Profiles

Pre-defined profiles optimize for different use cases:

```dart
await Locus.setTrackingProfiles(
  {
    TrackingProfile.standby: ConfigPresets.lowPower,
    TrackingProfile.enRoute: ConfigPresets.tracking,
  },
  initialProfile: TrackingProfile.standby,
);
```

### Custom Profiles

Create custom profiles with automatic switching rules:

```dart
await Locus.setTrackingProfiles(
  {
    TrackingProfile.standby: ConfigPresets.lowPower,
    TrackingProfile.enRoute: ConfigPresets.tracking,
    TrackingProfile.arrived: ConfigPresets.balanced,
  },
  rules: [
    TrackingProfileRule(
      profile: TrackingProfile.enRoute,
      type: TrackingProfileRuleType.speedAbove,
      speedKph: 20,
    ),
    TrackingProfileRule(
      profile: TrackingProfile.arrived,
      type: TrackingProfileRuleType.geofence,
      geofenceAction: GeofenceAction.enter,
      geofenceIdentifier: 'destination',
    ),
  ],
  enableAutomation: true,
);
```

## Sync Policy

Control when data is synced to save battery:

```dart
final syncPolicy = SyncPolicy(
  onWifi: SyncBehavior.immediate,
  onCellular: SyncBehavior.batch,
  onMetered: SyncBehavior.manual,
  batchSize: 50,
  batchInterval: Duration(minutes: 5),
  lowBatteryThreshold: 20,
  lowBatteryBehavior: SyncBehavior.manual,
);

await Locus.dataSync.setPolicy(syncPolicy);
```

---

**Next:** [Diagnostics & Debugging](diagnostics.md)
