# Locus Example Application

This is a demonstration application for the Locus Background Geolocation SDK. It showcases production-focused features and real-world tracking workflows.

## Features Demonstrated

- **Permission Handling**: requesting background location and motion activity permissions.
- **Service Lifecycle**: starting and stopping the background tracking service.
- **Event Monitoring**: real-time display of location updates, motion state changes, and provider authorization status.
- **Profiles & Automation**: profile presets, automation rules, and manual pace overrides.
- **Geofencing**: circular, polygon geofences, and delivery workflows.
- **Privacy Zones**: obfuscation zones and privacy events.
- **Sync & Queues**: sync policies, queue management, and dynamic headers.
- **Battery Optimization**: adaptive tracking presets and runway estimation.
- **Diagnostics & History**: diagnostics snapshot, stored locations, and summary stats.

## Getting Started

### 1. Configure Native Settings

Before running the example, ensure your environment is configured for background location. You can use the Locus CLI from the root of this example project (or the parent project):

```bash
dart run locus:setup
```

### 2. Run the Application

Navigate to the `example` directory and run the application:

```bash
flutter run
```

## Implementation Notes

The core logic for this example is located in `lib/main.dart`. It demonstrates the use of `Locus.ready()` with a high-accuracy configuration and listeners for various event streams.
