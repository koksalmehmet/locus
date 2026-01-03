<p align="center">
  <img src="assets/logo/locus_logo_128.png" alt="Locus Logo" width="100" height="100">
</p>

<h1 align="center">Locus</h1>

<p align="center">
  <a href="https://pub.dev/packages/locus"><img src="https://img.shields.io/pub/v/locus?style=flat-square&logo=dart" alt="Pub Version"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-PolyForm%20Small%20Business-blue.svg?style=flat-square" alt="License"></a>
  <a href="https://github.com/koksalmehmet/locus/actions"><img src="https://img.shields.io/github/actions/workflow/status/koksalmehmet/locus/pipeline.yml?style=flat-square&logo=github" alt="Build Status"></a>
</p>

<p align="center">
  A battle-tested background geolocation SDK for Flutter.<br>
  High-performance tracking, motion recognition, geofencing, and automated sync for Android and iOS.
</p>

---

## Key Features

- **Continuous Tracking**: Reliable background updates with adaptive filters.
- **Motion Recognition**: Activity detection (walking, running, driving, stationary).
- **Native Geofencing**: High-performance entry/exit/dwell detection.
- **Automated Sync**: HTTP synchronization with retry logic and batching.
- **Battery Optimization**: Adaptive profiles based on speed and battery level.
- **Offline Reliability**: SQLite persistence to prevent data loss.
- **Headless Execution**: Execute background logic even when the app is terminated.

## Documentation

For full documentation, visit [locus.dev](https://pub.dev/documentation/locus/latest/) or check the local [docs](docs/intro.md) folder:

- **[Quick Start](docs/guides/quickstart.md)** - Get running in 5 minutes.
- **[Core Concepts](docs/core/configuration.md)** - Configuration, Syncing, and Adaptation.
- **[Advanced Features](docs/advanced/geofencing.md)** - Geofencing, Headless, and Diagnostics.
- **[Platform Setup](docs/setup/platform-configuration.md)** - iOS & Android permissions.

## Quick Start

### 1. Installation

```yaml
dependencies:
  locus: ^1.1.0
```

### 2. Basic Setup

```dart
import 'package:locus/locus.dart';

void main() async {
  // 1. Initialize
  await Locus.ready(Config.balanced(
    url: 'https://api.yourservice.com/locations',
  ));

  // 2. Start tracking
  await Locus.start();

  // 3. Listen to updates
  Locus.onLocation((location) {
    print('Location: ${location.coords.latitude}, ${location.coords.longitude}');
  });
}
```

## Project Tooling

Locus includes a CLI to help with configuration and diagnostics:

```bash
# Automate native permission setup
dart run locus:setup

# Run environment diagnostics
dart run locus:doctor
```

## License

Locus is licensed under the **PolyForm Small Business License 1.0.0**.

- **Free** for individuals and small businesses (< $250k annual revenue).
- **Professional/Enterprise** licenses available for larger organizations.

See [LICENSE](LICENSE) and [LICENSING.md](LICENSING.md) for full terms.
