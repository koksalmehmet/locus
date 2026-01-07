import 'package:locus/src/shared/models/json_map.dart';

class GeofenceWorkflowState {
  const GeofenceWorkflowState({
    required this.workflowId,
    required this.currentIndex,
    required this.completedStepIds,
    required this.completed,
  });
  final String workflowId;
  final int currentIndex;
  final List<String> completedStepIds;
  final bool completed;

  JsonMap toMap() => {
        'workflowId': workflowId,
        'currentIndex': currentIndex,
        'completedStepIds': completedStepIds,
        'completed': completed,
      };
}
