# Platform-Specific Behaviors

Last updated: January 7, 2026

Key runtime differences that affect tracking, geofencing, background execution, and battery.

## Android
- **Doze/App Standby:** Jobs and alarms defer; run as a foreground service with a persistent notification to maintain updates.
- **Permissions:** Request foreground first, then background. On Android 14+, users can downgrade to “approximate”—handle gracefully.
- **Geofence limits:** ~100 per app. Keep identifiers stable; remove stale fences.
- **Foreground service startup:** Call `startForeground` quickly; missing notification can kill the service.
- **OEM optimizations:** Some vendors (Xiaomi, Huawei, Samsung) kill background services aggressively—educate users on whitelisting.
- **Networking:** Metered/roaming policies can block sync; honor `disableAutoSyncOnCellular` when set.

## iOS
- **Background modes:** Enable “Location updates” (and optionally “Background fetch”) in Info.plist.
- **SLC vs standard:** Significant-change is low power but less frequent; standard updates pause unless background mode is active.
- **Approximate location:** Users may grant reduced accuracy; prompt for precise only when necessary.
- **Geofence limits:** ~20 regions per app; prioritize critical fences.
- **Execution time:** Background tasks must finish fast; incomplete work may be terminated—keep headless work minimal.
- **App termination:** iOS may relaunch for region events or significant changes, but not guaranteed—persist state defensively.

## Cross-platform recommendations
- Keep fences lean; prune old ones and batch updates.
- Provide clear permission rationale, and detect when users downgrade accuracy/background permission.
- Tune `distanceFilter`, `desiredAccuracy`, heartbeat, and activity intervals per platform expectations.
- Handle coarse fixes gracefully; do not drop all approximate locations—flag them instead.
- Log power, connectivity, and permission state to aid support and diagnostics.
