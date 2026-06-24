import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


import '../../core/services/battery_service.dart';
import '../../data/repositories/battery_repository.dart';
import 'dart:async';

import 'package:battery_plus/battery_plus.dart';


final serviceProvider = Provider(
      (ref) => BatteryService(),
);

final repositoryProvider = Provider(
      (ref) => BatteryRepository(
    ref.read(serviceProvider),
    BatteryLocalDatasource(),
  ),
);

class BatteryNotifier extends StateNotifier<int> {
  BatteryNotifier(this.repo) : super(0) {
    load();
  }

  final BatteryRepository repo;

  Future<void> load() async {
    state = await repo.batteryLevel;
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