import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/settings_service.dart';
import '../../data/datasources/battery_local_datasource.dart';
import '../../data/models/battery_log.dart';

import '../../core/services/battery_service.dart';
import '../../data/repositories/battery_repository.dart';
import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
// 1. Add your global dependency providers at the top (Unimplemented by default)
final hiveBoxProvider = Provider<Box<BatteryLog>>((ref) {
  throw UnimplementedError('Override this provider in main.dart or tests');
});

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override this provider in main.dart or tests');
});
class BatteryNotifier extends StateNotifier<int> {
  BatteryNotifier(this.repo) : super(0) {
    load();
  }

  final BatteryRepository repo;

  Future<void> load() async {
    state = await repo.batteryLevel;
   // await checkThreshold();
  }
}

final batteryProvider =
StateNotifierProvider<BatteryNotifier, int>(
      (ref) => BatteryNotifier(
    ref.read(repositoryProvider),
  ),
);

final batteryStateProvider =
FutureProvider<BatteryState>((ref) {
  return ref.read(repositoryProvider).batteryState;
});


final batteryHistoryProvider = FutureProvider<List<BatteryLog>>((ref) async {
  return await ref
      .watch(repositoryProvider)
      .getHistory();
});


final thresholdProvider =
    FutureProvider<int>((ref) {
  return ref
      .read(settingsProvider)
      .getThreshold();
});
// 2. Update serviceProvider
final serviceProvider = Provider(
  (ref) => BatteryService(),
);

// 3. Update repositoryProvider (Pass the box dependency here!)
final repositoryProvider = Provider(
  (ref) => BatteryRepository(
    ref.read(serviceProvider),
    BatteryLocalDatasource(box: ref.read(hiveBoxProvider)), // Fixed error line 21 [1]
  ),
);

final settingsProvider = Provider(
  (ref) => SettingsService(sharedPreferences: ref.read(sharedPrefsProvider)), 
);