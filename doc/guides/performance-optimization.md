# Performance Optimization Guide

Last updated: January 7, 2026

Practical tuning to balance accuracy, responsiveness, and battery.

## Core knobs
- **desiredAccuracy:** Lower accuracy uses less GPS; start with `balanced`.
- **distanceFilter:** Increase to reduce update frequency; decrease for denser tracks.
- **heartbeatInterval:** Lengthen for stationary periods to save power.
- **activityRecognitionInterval:** Longer intervals reduce motion polling cost.
- **batch sync:** Tune `maxBatchSize` and `autoSyncThreshold` to cut radio wakeups.

## Profiles and adaptation
- Start from presets (balanced, lowPower) and adjust per use case.
- Use adaptive tracking to scale settings based on motion and battery state.
- While moving fast (vehicle), favor accuracy; when stationary, relax aggressively.

## Sync efficiency
- Prefer batching over frequent single-record uploads.
- Avoid sync on poor networks; respect `disableAutoSyncOnCellular` when set.
- Use compression server-side if payloads are large; keep client payloads lean.

## Geofencing vs continuous
- Use geofences for coarse presence; enable continuous tracking only when inside ROIs.
- Keep geofence lists small to stay within platform limits and reduce CPU.

## Diagnostics
- Monitor `battery.powerStateEvents` and queue size to detect drain or blocked uploads.
- Log accuracy buckets to see if settings are too strict/lenient.

## Validation checklist
- Measure battery over 60–120 minutes foreground/background with realistic routes.
- Test urban vs rural accuracy; adjust distanceFilter and desiredAccuracy accordingly.
- Verify sync volume, latency, and failure handling meet backend SLAs.
