# Geofencing

Locus provides a high-performance native geofencing system that works even when the app is terminated or in the background.

## Adding a Geofence

You can add geofences at any time, even before starting the main tracking service.

```dart
await Locus.addGeofence(const Geofence(
  identifier: 'office_zone',
  radius: 100, // meters
  latitude: 37.7749,
  longitude: -122.4194,
  notifyOnEntry: true,
  notifyOnExit: true,
  notifyOnDwell: true,
  loiteringDelay: 30000, // 30 seconds for dwell
));
```

## Listening to Events

Geofence events are delivered via the `onGeofence` stream.

```dart
Locus.onGeofence((event) {
  print('Geofence ${event.identifier}: ${event.action}');
});
```

### Event Object

The `GeofenceEvent` provides:

- `identifier`: The unique ID you assigned.
- `action`: `enter`, `exit`, or `dwell`.
- `location`: The location that triggered the event.

## Removing Geofences

```dart
// Remove by ID
await Locus.removeGeofence('office_zone');

// Remove all
await Locus.removeGeofences();
```

---

**Next:** [Headless Execution](headless.md)
