import 'package:battery_plus/battery_plus.dart';

import 'package:workmanager/workmanager.dart';

import '../../data/models/battery_log.dart';
import 'notification_service.dart';
import 'settings_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/battery_local_datasource.dart';
import '../../data/repositories/battery_repository.dart';
import '../services/battery_service.dart';


const String batteryTask = "battery_tracking_task";


@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
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
    final sent = await settings.wasTriggered();


    if (level >= threshold && !sent) {
      await NotificationService.instance.initialize();

      await NotificationService.instance.showBatteryAlert(threshold);


      await settings.setTriggered(true);
    }

    if (level < threshold) {
      await settings.setTriggered(false);
    }
    
    try {

    // battery logging logic
    return Future.value(true);

    } catch (_) {
      return Future.value(false);
      
    }
  });
}