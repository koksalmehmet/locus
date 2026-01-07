# Activity Recognition Guide

Last updated: January 7, 2026

Use activity signals to tailor accuracy and power usage.

## Supported activities
Common types: still, walking, running, cycling, inVehicle, unknown (platform dependent).

## Usage patterns
- Subscribe to activity/motion streams and adjust configs dynamically.
- Increase accuracy and lower distanceFilter when speed rises; relax when still.
- Combine with geofences to trigger richer logic only when relevant.

## Configuration tips
- Tune `activityRecognitionInterval` to balance responsiveness vs. battery.
- Debounce rapid flapping (e.g., walking ↔ still) before switching modes.
- Treat `unknown` conservatively: avoid aggressive tracking changes.

## Testing
- Simulate transitions (walk → run → drive) on physical devices; emulators are unreliable.
- Validate on both platforms; detection quality differs between Android and iOS.
