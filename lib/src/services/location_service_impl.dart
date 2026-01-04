/// Location service implementation for v2.0 API.
library;

import 'dart:async';

import 'package:locus/src/models.dart';
import 'package:locus/src/core/locus_interface.dart';
import 'package:locus/src/services/location_service.dart';

/// Implementation of [LocationService] using method channel.
class LocationServiceImpl implements LocationService {
  /// Creates a location service with the given Locus interface provider.
  LocationServiceImpl(this._instanceProvider);

  final LocusInterface Function() _instanceProvider;

  LocusInterface get _instance => _instanceProvider();

  @override
  Stream<Location> get stream => _instance.locationStream;

  @override
  Stream<Location> get motionChanges => _instance.motionChangeStream;

  @override
  Stream<Location> get heartbeats => _instance.heartbeatStream;

  @override
  Future<Location> getCurrentPosition({
    int? samples,
    int? timeout,
    int? maximumAge,
    bool? persist,
    int? desiredAccuracy,
    JsonMap? extras,
  }) {
    return _instance.getCurrentPosition(
      samples: samples,
      timeout: timeout,
      maximumAge: maximumAge,
      persist: persist,
      desiredAccuracy: desiredAccuracy,
      extras: extras,
    );
  }

  @override
  Future<List<Location>> getLocations({int? limit}) {
    return _instance.getLocations(limit: limit);
  }

  @override
  Future<List<Location>> query(LocationQuery query) {
    return _instance.queryLocations(query);
  }

  @override
  Future<LocationSummary> getSummary({
    DateTime? date,
    LocationQuery? query,
  }) {
    return _instance.getLocationSummary(date: date, query: query);
  }

  @override
  Future<bool> changePace(bool isMoving) {
    return _instance.changePace(isMoving);
  }

  @override
  Future<double> setOdometer(double value) {
    return _instance.setOdometer(value);
  }

  @override
  Future<bool> destroyLocations() {
    return _instance.destroyLocations();
  }

  @override
  StreamSubscription<Location> onLocation(
    void Function(Location) callback, {
    Function? onError,
  }) {
    return _instance.onLocation(callback, onError: onError);
  }

  @override
  StreamSubscription<Location> onMotionChange(
    void Function(Location) callback, {
    Function? onError,
  }) {
    return _instance.onMotionChange(callback, onError: onError);
  }

  @override
  StreamSubscription<Location> onHeartbeat(
    void Function(Location) callback, {
    Function? onError,
  }) {
    return _instance.onHeartbeat(callback, onError: onError);
  }
}
