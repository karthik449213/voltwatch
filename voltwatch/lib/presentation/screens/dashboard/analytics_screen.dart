import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/battery_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(
      batteryHistoryProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Battery Analytics"),
      ),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (_, index) {
          final item = logs[index];

          return ListTile(
            leading: CircleAvatar(
              child: Text(
                "${item.batteryLevel}",
              ),
            ),
            title: Text(
              "${item.batteryLevel}%",
            ),
            subtitle: Text(
              DateFormat(
                "dd MMM yyyy  hh:mm a",
              ).format(item.timestamp),
            ),
            trailing: Text(
              item.batteryState,
            ),
          );
        },
      ),
    );
  }
}