import 'package:hive/hive.dart';

import '../models/battery_log.dart';

class BatteryLocalDatasource {
  final Box<BatteryLog> box =
      Hive.box<BatteryLog>("battery_logs");

  Future<void> save(BatteryLog log) async {
    await box.add(log);
  }

  List<BatteryLog> getLogs() {
    return box.values.toList().reversed.toList();
  }
}