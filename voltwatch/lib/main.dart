import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presentation/screens/dashboard/dashboard_screen.dart';
import 'package:voltwatch/data/models/battery_log.dart';
import 'package:voltwatch/core/services/notification_service.dart';
import 'package:voltwatch/core/services/background_worker.dart';

import 'package:voltwatch/presentation/providers/battery_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Hive & Register the adapter
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(BatteryLogAdapter().typeId)) {
    Hive.registerAdapter(BatteryLogAdapter());
  }

  // Open the box asynchronously and save the instance
  final openedBatteryBox = await Hive.openBox<BatteryLog>('battery_logs');

  //  SharedPreferences asynchronously
  final sharedPrefsInstance = await SharedPreferences.getInstance();
  // Initialize local notifications
  await NotificationService.instance.initialize();

  initializeBackgroundTracking();

  runApp(
    ProviderScope(
      overrides: [
        // Inject the active instances into your Riverpod provider tree
        hiveBoxProvider.overrideWithValue(openedBatteryBox),
        sharedPrefsProvider.overrideWithValue(sharedPrefsInstance),
      ],
      child: const VoltWatch(),
    ),
  );
}

class VoltWatch extends ConsumerStatefulWidget {
  const VoltWatch({super.key});

  @override
  ConsumerState<VoltWatch> createState() => _VoltWatchState();
}

class _VoltWatchState extends ConsumerState<VoltWatch>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Orchestrate automatic UI refresh whenever the app transitions back to the foreground
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(batteryHistoryProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "VoltWatch",
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const DashboardScreen(),
    );
  }
}
