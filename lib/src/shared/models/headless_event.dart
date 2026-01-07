import 'package:locus/src/shared/models/json_map.dart';

class HeadlessEvent {
  const HeadlessEvent({
    required this.name,
    this.data,
  });

  factory HeadlessEvent.fromMap(JsonMap map) {
    return HeadlessEvent(
      name: map['type'] as String? ?? 'unknown',
      data: map['data'],
    );
  }
  final String name;
  final dynamic data;
}
