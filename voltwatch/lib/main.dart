import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:voltwatch/data/models/battery_log.dart';
import 'package:voltwatch/core/services/notification_service.dart';
import 'package:voltwatch/core/services/background_worker.dart';
import 'package:voltwatch/core/services/background_service.dart';
Future<void> main()  async{
 WidgetsFlutterBinding.ensureInitialized();

 await Hive.initFlutter();
 Hive.registerAdapter(BatteryLogAdapter(),);
 await Hive.openBox<BatteryLog>('battery_logs');

 await NotificationService.instance.initialize();

   await Workmanager().initialize(
         callbackDispatcher,
         isInDebugMode: false,
      );

        
      await BackgroundService.registerTasks();
  runApp(
    const ProviderScope(
      child: VoltWatch(),
    ),
  );
}

class VoltWatch extends StatelessWidget {
  const VoltWatch({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "VoltWatch",
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}