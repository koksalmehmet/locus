/// Geofence service interface for v2.0 API.
///
/// Provides a clean, organized API for geofencing operations.
/// Access via `Locus.geofencing`.
library;

import 'dart:async';

import 'package:locus/src/models.dart';

/// Service interface for geofencing operations.
///
/// Example:
/// ```dart
/// // Add a circular geofence
/// await Locus.geofencing.add(Geofence(
///   identifier: 'office',
///   latitude: 37.7749,
///   longitude: -122.4194,
///   radius: 100.0,
///   notifyOnEntry: true,
///   notifyOnExit: true,
/// ));
///
/// // Add a polygon geofence
/// await Locus.geofencing.addPolygon(PolygonGeofence(
///   identifier: 'campus',
///   vertices: [
///     GeoPoint(latitude: 37.42, longitude: -122.08),
///     GeoPoint(latitude: 37.43, longitude: -122.08),
///     GeoPoint(latitude: 37.43, longitude: -122.07),
///     GeoPoint(latitude: 37.42, longitude: -122.07),
///   ],
/// ));
///
/// // Listen to geofence events
/// Locus.geofencing.events.listen((event) {
///   print('Geofence ${event.identifier}: ${event.action}');
/// });
/// ```
abstract class GeofenceService {
  /// Stream of geofence crossing events.
  Stream<GeofenceEvent> get events;

  /// Stream of polygon geofence events.
  Stream<PolygonGeofenceEvent> get polygonEvents;

  /// Stream of geofence workflow events.
  Stream<GeofenceWorkflowEvent> get workflowEvents;

  // ============================================================
  // Circular Geofences
  // ============================================================

  /// Adds a single geofence.
  Future<bool> add(Geofence geofence);

  /// Adds multiple geofences.
  Future<bool> addAll(List<Geofence> geofences);

  /// Removes a geofence by identifier.
  Future<bool> remove(String identifier);

  /// Removes all geofences.
  Future<bool> removeAll();

  /// Gets all registered geofences.
  Future<List<Geofence>> getAll();

  /// Gets a geofence by identifier.
  Future<Geofence?> get(String identifier);

  /// Checks if a geofence exists.
  Future<bool> exists(String identifier);

  /// Starts geofence-only monitoring mode.
  ///
  /// In this mode, location tracking is minimal and only geofence
  /// boundaries are monitored.
  Future<bool> startMonitoring();

  // ============================================================
  // Polygon Geofences
  // ============================================================

  /// Adds a polygon geofence.
  Future<bool> addPolygon(PolygonGeofence polygon);

  /// Adds multiple polygon geofences.
  ///
  /// Returns the number of polygons successfully added.
  Future<int> addPolygons(List<PolygonGeofence> polygons);

  /// Removes a polygon geofence by identifier.
  Future<bool> removePolygon(String identifier);

  /// Removes all polygon geofences.
  Future<void> removeAllPolygons();

  /// Gets all registered polygon geofences.
  Future<List<PolygonGeofence>> getAllPolygons();

  /// Gets a polygon geofence by identifier.
  Future<PolygonGeofence?> getPolygon(String identifier);

  /// Checks if a polygon geofence exists.
  Future<bool> polygonExists(String identifier);

  // ============================================================
  // Workflows
  // ============================================================

  /// Registers geofence workflows.
  ///
  /// Workflows define multi-step sequences triggered by geofence events.
  void registerWorkflows(List<GeofenceWorkflow> workflows);

  /// Gets the current state of a workflow.
  GeofenceWorkflowState? getWorkflowState(String workflowId);

  /// Clears all registered workflows.
  void clearWorkflows();

  /// Stops all active workflows.
  void stopWorkflows();

  // ============================================================
  // Subscriptions
  // ============================================================

  /// Subscribes to geofence events.
  StreamSubscription<GeofenceEvent> onGeofence(
    void Function(GeofenceEvent) callback, {
    Function? onError,
  });

  /// Subscribes to geofence list changes.
  StreamSubscription<dynamic> onGeofencesChange(
    void Function(dynamic) callback, {
    Function? onError,
  });

  /// Subscribes to workflow events.
  StreamSubscription<GeofenceWorkflowEvent> onWorkflowEvent(
    void Function(GeofenceWorkflowEvent) callback, {
    Function? onError,
  });

  /// Checks if currently inside any active geofence.
  Future<bool> isInActiveGeofence();
}
