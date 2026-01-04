import 'package:locus/src/shared/models/json_map.dart';

class Battery {

  const Battery({
    required this.level,
    required this.isCharging,
  });

  factory Battery.fromMap(JsonMap map) {
    return Battery(
      level: (map['level'] as num?)?.toDouble() ?? 0.0,
      isCharging: map['is_charging'] as bool? ?? false,
    );
  }
  final double level;
  final bool isCharging;

  JsonMap toMap() => {
        'level': level,
        'is_charging': isCharging,
      };
}
