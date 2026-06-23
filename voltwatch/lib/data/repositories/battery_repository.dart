import 'package:battery_plus/battery_plus.dart';
import 'package:voltwatch/core/services/battery_service.dart';

class BatteryRepository {
    final BatteryService _batteryService;

    BatteryRepository(this._batteryService);
    Future<int> get batteryLevel async {
        return _batteryService.batteryLevel;

    }
    Future<BatteryState> get batteryState async {
        return _batteryService.batteryState;

    }
   
   Future<bool> get isInBatterySaveMode {
    return _batteryService.isInBatterySaveMode;
   }
   Stream<BatteryState> get onBatteryStateChanged {
    return _batteryService.onBatteryStateChanged;
   }


}