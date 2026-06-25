// import the battery_plus package
import 'package:battery_plus/battery_plus.dart';

// battery service classs
class BatteryService {
  final Battery _battery;

  // Dependency injection :defaults to real Battery(),accepts mock in tests
  BatteryService({Battery? battery}) : _battery = battery ?? Battery();

  Future<int> get batteryLevel async {
    return _battery.batteryLevel;
  }

  Future<BatteryState> get batteryState async {
    return _battery.batteryState;
  }

  Future<bool> get isInBatterySaveMode {
    return _battery.isInBatterySaveMode;
  }

  Stream<BatteryState> get onBatteryStateChanged {
    return _battery.onBatteryStateChanged;
  }
}
