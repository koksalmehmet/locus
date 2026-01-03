# Configuration

Locus is highly configurable. You can either use pre-defined presets or create a fully custom configuration.

## Presets

Presets are the recommended way to start. They provide optimized settings for specific use cases.

- `Config.fitness()`: High accuracy (1-5m), high frequency. Ideal for running or cycling apps.
- `Config.balanced()`: Standard accuracy (10-25m), balanced battery usage.
- `Config.passive()`: Low power, relies on significant location changes. Minimal battery impact.

## Custom Configuration

You can customize individual parameters:

```dart
final config = Config(
  desiredAccuracy: Accuracy.high,
  distanceFilter: 10,
  stopTimeout: 5,
  debug: true,
  logLevel: LogLevel.verbose,
  // ... many more
);

await Locus.ready(config);
```

### Key Parameters

| Parameter           | Type       | Default             | Description                                                      |
| :------------------ | :--------- | :------------------ | :--------------------------------------------------------------- |
| `desiredAccuracy`   | `Accuracy` | `Accuracy.balanced` | Target accuracy (high, balanced, low, passive).                  |
| `distanceFilter`    | `double`   | `10.0`              | Minimum distance (meters) before a location update is triggered. |
| `stopTimeout`       | `int`      | `5`                 | Minutes to wait after motion stops before powering down sensors. |
| `heartbeatInterval` | `int`      | `60`                | Interval (seconds) for an idle-state heartbeat event.            |

## HTTP Synchronization

Locus can automatically sync data to your backend.

```dart
await Locus.ready(Config.balanced(
  url: 'https://api.example.com/ingest',
  headers: {
    'Authorization': 'Bearer YOUR_TOKEN',
  },
  batchSync: true,
  maxBatchSize: 50,
));
```

---

**Next:** [Adaptive Tracking](../core/adaptive-tracking.md)
