import 'package:workmanager/workmanager.dart';

import 'background_worker.dart';

class BackgroundService {
  static Future<void> registerTasks() async {
    await Workmanager().registerPeriodicTask(
      "voltwatch-background",
      batteryTask,
      frequency: const Duration(minutes: 15),
      existingWorkPolicy:
          ExistingPeriodicWorkPolicy.keep,
    );
  }
}