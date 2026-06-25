import 'package:battery_plus/battery_plus.dart';
import 'package:voltwatch/core/services/battery_service.dart';
import 'package:voltwatch/data/datasources/battery_local_datasource.dart';
import 'package:voltwatch/data/models/battery_log.dart';

class BatteryRepository {
  final BatteryService _batteryService;
  final BatteryLocalDatasource datasource;

  BatteryRepository(this._batteryService, this.datasource);
  Future<int> get batteryLevel async {
    return _batteryService.batteryLevel;
  }

  Future<BatteryState> get batteryState async {
    return _batteryService.batteryState;
  }

  Future<void> saveCurrentBattery() async {
    final level = await _batteryService.batteryLevel;
    final state = await _batteryService.batteryState;

    await datasource.save(
      BatteryLog(
        batteryLevel: level,
        batteryState: state.name,
        timestamp: DateTime.now(),
      ),
    );
  }

  List<BatteryLog> getHistory() {
    return datasource.getLogs();
  }

  Future<bool> get isInBatterySaveMode {
    return _batteryService.isInBatterySaveMode;
  }

  Stream<BatteryState> get onBatteryStateChanged {
    return _batteryService.onBatteryStateChanged;
  }
}
