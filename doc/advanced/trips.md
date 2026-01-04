# Trip Tracking

Locus provides trip tracking through the `TripService`. Use `TripConfig` to
control start and stop behavior, and subscribe to trip events for updates.

## Starting Trip Tracking

```dart
await Locus.ready(const Config());
await Locus.start();

final config = TripConfig(
  tripId: 'delivery-123',
  startOnMoving: true,
  startDistanceMeters: 50,
  stopOnStationary: true,
  stopTimeoutMinutes: 5,
);

await Locus.trips.start(config);
```

## Listening to Trip Events

```dart
Locus.trips.events.listen((event) {
  switch (event.type) {
    case TripEventType.tripStart:
      print('Trip started: ${event.tripId}');
      break;
    case TripEventType.tripUpdate:
      print('Trip updated: ${event.tripId}');
      break;
    case TripEventType.tripEnd:
      final summary = event.summary;
      print('Trip ended: ${summary?.distanceMeters}m');
      break;
    case TripEventType.dwell:
    case TripEventType.routeDeviation:
    case TripEventType.diagnostic:
    case TripEventType.waypointReached:
      // Handle optional events as needed.
      break;
  }
});
```

## Trip Summary

When a trip ends, you can also call `stop()` to receive a summary:

```dart
final summary = Locus.trips.stop();
if (summary != null) {
  print('Distance: ${summary.distanceMeters}m');
  print('Duration: ${summary.durationSeconds}s');
  print('Average speed: ${summary.averageSpeedKph}kph');
}
```

## Manual Trip Control

```dart
await Locus.trips.start(const TripConfig(tripId: 'manual-trip'));

final summary = Locus.trips.stop();

final state = Locus.trips.getState();
```

---

**Next:** [Battery Optimization](battery-optimization.md)
