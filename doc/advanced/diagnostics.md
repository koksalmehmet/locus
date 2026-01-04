# Diagnostics & Debugging

## Overview

The Diagnostics feature provides comprehensive debugging, logging, and error recovery tools for troubleshooting Locus behavior in development and production.

## Key Features

- **Error Logging**: Track all SDK errors with stack traces
- **Performance Metrics**: Monitor tracking quality and battery impact
- **Recovery Strategies**: Automatic error recovery and state restoration
- **Debug Overlay**: Visual debugging widget for development
- **Event Inspection**: View raw platform events for debugging

## Using the Debug Overlay

The Debug Overlay provides real-time visibility into SDK state:

```dart
import 'package:locus/locus.dart';

// In your MaterialApp or scaffold
@override
Widget build(BuildContext context) {
  return Stack(
    children: [
      // Your app content
      MyApp(),
      
      // Add debug overlay
      if (kDebugMode)
        const LocusDebugOverlay(),
    ],
  );
}
```

## Accessing Diagnostics

```dart
// Get current diagnostics snapshot
final diagnostics = await Locus.getDiagnostics();
print('Captured at: ${diagnostics.capturedAt}');
print('Queue size: ${diagnostics.queue.length}');

// Log entries
final logs = await Locus.getLog();
print('Log entries: ${logs.length}');
```

## Error Recovery

Locus automatically attempts to recover from errors:

```dart
Locus.setErrorHandler(ErrorRecoveryConfig(
  onError: (error, context) {
    return error.suggestedRecovery ?? RecoveryAction.retry;
  },
  maxRetries: 3,
  retryDelay: Duration(seconds: 5),
));

// Listen for error events
Locus.errorRecoveryManager?.errors.listen((error) {
  print('Error: ${error.type.name} - ${error.message}');
});
```

## Logging Configuration

Control verbosity of logs:

```dart
await Locus.setConfig(const Config(
  logLevel: LogLevel.debug, // verbose, debug, info, warning, error
));
```

**Next:** [Advanced Configuration](../core/configuration.md)
