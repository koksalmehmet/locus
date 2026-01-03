# Locus Product Roadmap

Source documents: FEATURE_PRIORITY_MATRIX.md and HIGH_IMPACT_FEATURES.md (January 2026 refresh). Priorities use Score = (Developer Value × Market Differentiation) / Effort. Durations are engineering estimates in working days.

## Phase Plan

### Phase 1 (Weeks 1-2): Quick Wins
- Battery Runway Estimation (8.0) — 3 days (Issue [#3](https://github.com/koksalmehmet/locus/issues/3))
- Webhook and Multi-URL Support (8.0) — 4 days (Issue [#4](https://github.com/koksalmehmet/locus/issues/4))
- Location History Query API (6.0) — 3 days (Issue [#5](https://github.com/koksalmehmet/locus/issues/5))

Deliverables
- Public APIs shipped with docs and example usage.
- Platform parity for Android and iOS, with any caveats documented.
- Unit tests for calculation and filtering logic; integration coverage for basic responses.

### Phase 2 (Weeks 3-5): Differentiators
- Debug Dashboard Widget (8.3) — 5 days (Issue [#6](https://github.com/koksalmehmet/locus/issues/6))
- ETA and Route Progress Calculator (8.3) — 5 days (Issue [#7](https://github.com/koksalmehmet/locus/issues/7))
- Location Sharing Sessions (6.7) — 5 days (Issue [#8](https://github.com/koksalmehmet/locus/issues/8))

Deliverables
- Embeddable debug overlay with live location, battery, sync, geofence, and activity panels.
- Trip API with on-progress callbacks, deviation detection, and blended speed model.
- Session-based sharing (create, subscribe) with metadata and expiry controls.
- Example app flows updated to demonstrate the above.

### Phase 3 (Weeks 6-10): Power Features
- Smart Geofence Suggestions (4.0) — 3 days (Issue [#9](https://github.com/koksalmehmet/locus/issues/9))
- Privacy Zones (5.3) — 5 days (Issue [#10](https://github.com/koksalmehmet/locus/issues/10))
- Offline Map Tile Caching (5.0) — 15 days (Issue [#11](https://github.com/koksalmehmet/locus/issues/11))

Deliverables
- Suggestion API returning radius and rationale based on local accuracy.
- Privacy zones with obfuscate/exclude actions and persistence.
- Tile caching API and flutter_map layer with progress callbacks and cache inspection.

### Backlog and Later
- Polygon Geofences — 10 days (Issue [#12](https://github.com/koksalmehmet/locus/issues/12))
- Indoor Positioning Hints — 15 days (Issue [#13](https://github.com/koksalmehmet/locus/issues/13))
- Analytics Dashboard (SaaS) — 60+ days (Issue [#14](https://github.com/koksalmehmet/locus/issues/14))

## Dependencies
- Battery Runway Estimation feeds Debug Dashboard Widget metrics.
- Location History Query and Webhook Support feed Debug Dashboard Widget and Location Sharing Sessions.
- ETA calculator feeds Smart Geofence Suggestions and Sharing Sessions.

## Success Metrics
- pub.dev likes: target 500+ in six months.
- GitHub stars: target 1000+ in six months.
- Weekly downloads: target 5000+ in six months.
- Test coverage: raise to >85%.
- Example apps: grow to three focused samples.

## Implementation Notes
- Maintain headless execution and structured logging as differentiators.
- Keep API additions additive; avoid breaking changes.
- Document platform-specific behavior and recommended tracking profiles per feature.
