import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/battery_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Pre-populate the input controller with the existing saved threshold value
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentThreshold = await ref.read(settingsProvider).getThreshold();
      if (mounted) {
        controller.text = currentThreshold.toString();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose(); // Always clean up controllers to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Battery Alert")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Threshold (1-100)"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final value = int.tryParse(controller.text);

                if (value == null || value < 1 || value > 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Enter a value between 1 and 100"),
                    ),
                  );
                  return;
                }

                // Write value directly to local hardware disk storage
                await ref.read(settingsProvider).saveThreshold(value);

                // Invalidate the Riverpod cache provider to synchronize foreground components instantly
                ref.invalidate(thresholdProvider);

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Threshold saved at $value%")),
                );
                Navigator.pop(context);
              },

              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
