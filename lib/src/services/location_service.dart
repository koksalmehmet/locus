/// Location service interface for v2.0 API.
///
/// Provides a clean, organized API for location-related operations.
/// Access via `Locus.location`.
library;

import 'dart:async';

import 'package:locus/src/models.dart';

/// Service interface for location operations.
///
/// Example:
/// ```dart
/// // Start location tracking
/// await Locus.location.start();
///
/// // Get current position
/// final position = await Locus.location.getCurrentPosition();
///
/// // Listen to location updates
/// Locus.location.stream.listen((location) {
///   print('New location: ${location.coords}');
/// });
///
/// // Query historical locations
/// final history = await Locus.location.query(LocationQuery(
///   from: DateTime.now().subtract(Duration(hours: 1)),
/// ));
/// ```
abstract class LocationService {
  /// Stream of location updates.
  Stream<Location> get stream;

  /// Stream of motion changes (moving/stationary transitions).
  Stream<Location> get motionChanges;

  /// Stream of heartbeat locations (periodic updates when stationary).
  Stream<Location> get heartbeats;

  /// Gets the current position.
  ///
  /// [samples] - Number of location samples to average.
  /// [timeout] - Maximum time to wait in milliseconds.
  /// [maximumAge] - Maximum acceptable age of cached position.
  /// [persist] - Whether to save the location to the database.
  /// [desiredAccuracy] - Desired accuracy level.
  /// [extras] - Additional data to attach to the location.
  Future<Location> getCurrentPosition({
    int? samples,
    int? timeout,
    int? maximumAge,
    bool? persist,
    int? desiredAccuracy,
    JsonMap? extras,
  });

  /// Gets stored locations.
  ///
  /// [limit] - Maximum number of locations to return.
  Future<List<Location>> getLocations({int? limit});

  /// Queries stored locations with filtering and pagination.
  ///
  /// Example:
  /// ```dart
  /// final query = LocationQuery(
  ///   from: DateTime.now().subtract(Duration(hours: 1)),
  ///   to: DateTime.now(),
  ///   minAccuracy: 20,
  ///   limit: 100,
  /// );
  /// final locations = await Locus.location.query(query);
  /// ```
  Future<List<Location>> query(LocationQuery query);

  /// Gets a summary of location history.
  ///
  /// Returns statistics including total distance, time moving vs stationary,
  /// and frequently visited locations.
  ///
  /// [date] - Specific date to summarize. Uses today if not provided.
  /// [query] - Custom query for filtering locations.
  Future<LocationSummary> getSummary({
    DateTime? date,
    LocationQuery? query,
  });

  /// Changes the motion state (moving/stationary).
  ///
  /// Use this to manually indicate movement state when automatic
  /// detection may be inaccurate.
  Future<bool> changePace(bool isMoving);

  /// Sets the odometer value.
  ///
  /// The odometer tracks total distance traveled since last reset.
  Future<double> setOdometer(double value);

  /// Destroys all stored locations.
  Future<bool> destroyLocations();

  /// Subscribes to location updates.
  StreamSubscription<Location> onLocation(
    void Function(Location) callback, {
    Function? onError,
  });

  /// Subscribes to motion change events.
  StreamSubscription<Location> onMotionChange(
    void Function(Location) callback, {
    Function? onError,
  });

  /// Subscribes to heartbeat events.
  StreamSubscription<Location> onHeartbeat(
    void Function(Location) callback, {
    Function? onError,
  });
}
