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

final hiveBoxProvider = Provider<Box<BatteryLog>>((ref) {
  throw UnimplementedError('Override this provider in main.dart or tests');
});

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override this provider in main.dart or tests');
});

class BatteryNotifier extends StateNotifier<int> {
  final BatteryRepository repo;
  final Ref ref;
  StreamSubscription<int>? _subscription;

  BatteryNotifier(this.repo, this.ref) : super(0) {
    _initRealTimeTracking();
  }
  void _initRealTimeTracking() {
    // Fetch initial level isntantly
    repo.batteryLevel.then((value) => state = value);
    // subscribe to live system telmentry updates stream
    _subscription = Battery().onBatteryStateChanged
        .asyncMap((_) async {
          return await repo.batteryLevel;
        })
        .listen((level) {
          state = level;
        });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final batteryProvider = StateNotifierProvider<BatteryNotifier, int>(
  (ref) => BatteryNotifier(ref.read(repositoryProvider), ref),
);

final batteryStateProvider = StreamProvider<BatteryState>((ref) {
  // Exposes a continuous stream of system power plugin events to update gauge metrics instantly
  return Battery().onBatteryStateChanged;
});

final batteryHistoryProvider = FutureProvider<List<BatteryLog>>((ref) async {
  return await ref.watch(repositoryProvider).getHistory();
});

final thresholdProvider = FutureProvider<int>((ref) async {
  // Using watch ensures Riverpod tracks state updates dynamically across screens
  final settings = ref.watch(settingsProvider);
  return await settings.getThreshold();
});

// 2. Update serviceProvider
final serviceProvider = Provider((ref) => BatteryService());

// 3. Update repositoryProvider (Pass the box dependency here!)
final repositoryProvider = Provider(
  (ref) => BatteryRepository(
    ref.read(serviceProvider),
    BatteryLocalDatasource(
      box: ref.read(hiveBoxProvider),
    ), // Fixed error line 21 [1]
  ),
);

final settingsProvider = Provider(
  (ref) => SettingsService(sharedPreferences: ref.read(sharedPrefsProvider)),
);
