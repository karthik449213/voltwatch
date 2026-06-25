import 'package:battery_plus/battery_plus.dart';
import 'package:workmanager/workmanager.dart';

import '../../data/models/battery_log.dart';
import 'notification_service.dart';
import 'settings_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
const String batteryTask = "battery_tracking_task";


@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
        await Hive.initFlutter();
            await NotificationService.instance.initialize();

    // FIXED: Safely check for the specific adapter using its typeId property
    final adapter = BatteryLogAdapter();
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      // ignore: undefined_identifier
      Hive.registerAdapter(BatteryLogAdapter());
    }

    final box = await Hive.openBox<BatteryLog>("battery_logs");


    final battery = Battery();

    final level = await battery.batteryLevel;
    final state = await battery.batteryState;

    await box.add(
      BatteryLog(
        batteryLevel: level,
        batteryState: state.name,
        timestamp: DateTime.now(),
      ),
    );


    if (box.length > 100) {
      await box.deleteAt(0);
    }

    final sharedPreferences = await SharedPreferences.getInstance();
    final settings = SettingsService(sharedPreferences: sharedPreferences);

    final threshold = await settings.getThreshold();
     final lastTriggered = await settings.getLastTriggeredLevel();


    if (level >= threshold && lastTriggered != level) {
     

      await NotificationService.instance.showBatteryAlert(threshold);


      await settings.setLastTriggered(level);
    }

    if (level < threshold) {
      await settings.clearTrigger();
    }
    
    try {

    // battery logging logic
    return Future.value(true);

    } catch (_) {
      return Future.value(false);
      
    }
  });
}
/// Configures background task registration safely across Android and iOS platforms
void initializeBackgroundTracking() {
  // Configures Android work loops via standard initialization
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  
  // Registers periodic background work intent for the device scheduler loop
  Workmanager().registerPeriodicTask(
    "1",
    batteryTask,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.notRequired,
      requiresBatteryNotLow: false,
    ),
  );
}

