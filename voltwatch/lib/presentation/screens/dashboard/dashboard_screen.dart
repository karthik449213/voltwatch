import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/battery_provider.dart';
import '../../widgets/battery_guage.dart';


class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(batteryProvider);
    final state = ref.watch(batteryStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("VoltWatch"),
      ),
      body: Center(
        child: state.when(
          data: (BatteryState batteryState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BatteryGauge(
                  percentage: level,
                ),
                const SizedBox(height: 30),
                Text(
                  batteryState.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(batteryProvider.notifier)
                        .load();
                  },
                  child: const Text("Refresh"),
                )
              ],
            );
          },
          loading: () =>
              const CircularProgressIndicator(),
          error: (_, _) =>
              const Text("Unable to read battery"),
        ),
      ),
    );
  }
}