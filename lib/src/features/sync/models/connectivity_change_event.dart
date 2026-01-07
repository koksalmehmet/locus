import 'package:locus/src/shared/models/json_map.dart';

class ConnectivityChangeEvent {
  const ConnectivityChangeEvent({
    required this.connected,
    this.networkType,
  });

  factory ConnectivityChangeEvent.fromMap(JsonMap map) {
    return ConnectivityChangeEvent(
      connected: map['connected'] as bool? ?? false,
      networkType: map['networkType'] as String?,
    );
  }
  final bool connected;
  final String? networkType;

  JsonMap toMap() => {
        'connected': connected,
        if (networkType != null) 'networkType': networkType,
      };
}
