import 'package:battery_plus/battery_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

import '../../data/models/battery_log.dart';
import 'notification_service.dart';
import 'settings_service.dart';

const String batteryTask = "battery_tracking_task";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
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

    final settings = SettingsService();

    final threshold = await settings.getThreshold();
    final sent = await settings.wasTriggered();

    if (level >= threshold && !sent) {
      await NotificationService.instance.initialize();

      await NotificationService.instance.showBatteryAlert(
        threshold,
      );

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