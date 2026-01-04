/// Geofence service implementation for v2.0 API.
library;

import 'dart:async';

import 'package:locus/src/models.dart';
import 'package:locus/src/core/locus_interface.dart';
import 'package:locus/src/services/geofence_service.dart';

/// Implementation of [GeofenceService] using method channel.
class GeofenceServiceImpl implements GeofenceService {
  /// Creates a geofence service with the given Locus interface provider.
  GeofenceServiceImpl(this._instanceProvider);

  final LocusInterface Function() _instanceProvider;

  LocusInterface get _instance => _instanceProvider();

  @override
  Stream<GeofenceEvent> get events => _instance.geofenceStream;

  @override
  Stream<PolygonGeofenceEvent> get polygonEvents =>
      _instance.polygonGeofenceEvents;

  @override
  Stream<GeofenceWorkflowEvent> get workflowEvents =>
      _instance.workflowEvents;

  // ============================================================
  // Circular Geofences
  // ============================================================

  @override
  Future<bool> add(Geofence geofence) => _instance.addGeofence(geofence);

  @override
  Future<bool> addAll(List<Geofence> geofences) =>
      _instance.addGeofences(geofences);

  @override
  Future<bool> remove(String identifier) =>
      _instance.removeGeofence(identifier);

  @override
  Future<bool> removeAll() => _instance.removeGeofences();

  @override
  Future<List<Geofence>> getAll() => _instance.getGeofences();

  @override
  Future<Geofence?> get(String identifier) => _instance.getGeofence(identifier);

  @override
  Future<bool> exists(String identifier) =>
      _instance.geofenceExists(identifier);

  @override
  Future<bool> startMonitoring() => _instance.startGeofences();

  // ============================================================
  // Polygon Geofences
  // ============================================================

  @override
  Future<bool> addPolygon(PolygonGeofence polygon) =>
      _instance.addPolygonGeofence(polygon);

  @override
  Future<int> addPolygons(List<PolygonGeofence> polygons) =>
      _instance.addPolygonGeofences(polygons);

  @override
  Future<bool> removePolygon(String identifier) =>
      _instance.removePolygonGeofence(identifier);

  @override
  Future<void> removeAllPolygons() => _instance.removeAllPolygonGeofences();

  @override
  Future<List<PolygonGeofence>> getAllPolygons() =>
      _instance.getPolygonGeofences();

  @override
  Future<PolygonGeofence?> getPolygon(String identifier) =>
      _instance.getPolygonGeofence(identifier);

  @override
  Future<bool> polygonExists(String identifier) =>
      _instance.polygonGeofenceExists(identifier);

  // ============================================================
  // Workflows
  // ============================================================

  @override
  void registerWorkflows(List<GeofenceWorkflow> workflows) =>
      _instance.registerGeofenceWorkflows(workflows);

  @override
  GeofenceWorkflowState? getWorkflowState(String workflowId) =>
      _instance.getWorkflowState(workflowId);

  @override
  void clearWorkflows() => _instance.clearGeofenceWorkflows();

  @override
  void stopWorkflows() => _instance.stopGeofenceWorkflows();

  // ============================================================
  // Subscriptions
  // ============================================================

  @override
  StreamSubscription<GeofenceEvent> onGeofence(
    void Function(GeofenceEvent) callback, {
    Function? onError,
  }) {
    return _instance.onGeofence(callback, onError: onError);
  }

  @override
  StreamSubscription<dynamic> onGeofencesChange(
    void Function(dynamic) callback, {
    Function? onError,
  }) {
    return _instance.onGeofencesChange(callback, onError: onError);
  }

  @override
  StreamSubscription<GeofenceWorkflowEvent> onWorkflowEvent(
    void Function(GeofenceWorkflowEvent) callback, {
    Function? onError,
  }) {
    return _instance.onWorkflowEvent(callback, onError: onError);
  }

  @override
  Future<bool> isInActiveGeofence() => _instance.isInActiveGeofence();
}
