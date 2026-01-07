# Headless Execution Guide

Last updated: January 7, 2026

Run Locus logic when the app is terminated or backgrounded using headless callbacks.

## Lifecycle overview
- Platform wakes a background isolate on eligible events (location, geofence, heartbeat, sync).
- Your registered top-level callback executes; no UI is available.
- Process may be killed at any time; keep work short and resilient.

## Requirements
- Register a **top-level or static** function (no closures/instance methods).
- Add `@pragma('vm:entry-point')` to prevent tree shaking.
- Do not access Widgets or BuildContext; use pure Dart code and lightweight I/O.

## Setup

```dart
// main.dart
@pragma('vm:entry-point')
Future<void> locusHeadlessCallback(HeadlessEvent event) async {
  try {
    switch (event.type) {
      case HeadlessEventType.location:
        final loc = event.location;
        // e.g., enqueue for later sync
        break;
      case HeadlessEventType.geofence:
        // e.g., persist geofence transition
        break;
      case HeadlessEventType.sync:
        // inspect sync result, adjust policy if needed
        break;
      case HeadlessEventType.heartbeat:
        // optional lightweight health signal
        break;
    }
  } catch (e, st) {
    // Log defensively; avoid throws
    // e.g., await HeadlessLogger.log('$e\n$st');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locus.registerHeadlessCallback(locusHeadlessCallback);
  runApp(const MyApp());
}
```

## Best practices
- Keep callbacks under a few hundred milliseconds; offload heavy work to queued tasks.
- Guard every branch with try/catch; never let exceptions escape.
- Avoid network calls when offline; enqueue instead.
- Respect user consent: skip work if permissions or policy are revoked.
- Test on real devices; emulators may suspend differently.

## Validation checklist
- Kill the app, trigger a geofence or heartbeat, and verify the callback logs.
- Confirm no crashes in headless logs and that queued data appears on next foreground launch.
- On Android, ensure the foreground service notification is configured so headless can run reliably.
