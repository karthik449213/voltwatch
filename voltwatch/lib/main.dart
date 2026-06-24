import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/screens/dashboard/dashboard_screen.dart';

Future<void> main()  async{
 WidgetsFlutterBinding.ensureInitialized();

 await Hive.initFlutter();
 Hive.registerAdapter(BatteryLogAdapter(),);
 await Hive.openBox<BatteryLog>('battery_logs');

 await NotificationService.instance.initialize();
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