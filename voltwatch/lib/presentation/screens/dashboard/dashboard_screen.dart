import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/battery_provider.dart';
import '../../widgets/battery_gauge.dart';
import '../analytics/analytics_screen.dart';
import '../settings/settings_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(batteryProvider);
    final state = ref.watch(batteryStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("VoltWatch"),

        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: state.when(
          data: (BatteryState batteryState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pass the real-time batteryState into the visual gauge
                BatteryGauge(percentage: level, batteryState: batteryState),
                const SizedBox(height: 30),
                Text(
                  batteryState.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (_, _) => const Text("Unable to read battery"),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref.read(repositoryProvider).saveCurrentBattery();

          ref.invalidate(batteryHistoryProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
