import 'package:hive/hive.dart';

part 'battery_log.g.dart';

@HiveType(typeId: 0)
class BatteryLog extends HiveObject {
  @HiveField(0)
  final int batteryLevel;

  @HiveField(1)
  final String batteryState;

  @HiveField(2)
  final DateTime timestamp;

  BatteryLog({
    required this.batteryLevel,
    required this.batteryState,
    required this.timestamp,
  });
}
