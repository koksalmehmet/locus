import 'package:locus/src/shared/models/json_map.dart';
import 'package:locus/src/shared/models/enums.dart';

class GeofenceWorkflowStep {
  const GeofenceWorkflowStep({
    required this.id,
    required this.geofenceIdentifier,
    required this.action,
    this.cooldownSeconds = 0,
  });
  final String id;
  final String geofenceIdentifier;
  final GeofenceAction action;
  final int cooldownSeconds;

  JsonMap toMap() => {
        'id': id,
        'geofenceIdentifier': geofenceIdentifier,
        'action': action.name,
        'cooldownSeconds': cooldownSeconds,
      };
}
