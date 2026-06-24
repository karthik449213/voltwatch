import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Assuming your service and repository classes exist:
import '../../core/services/battery_service.dart';
import '../../data/repositories/battery_repository.dart';

// Necessary for code generation syntax
part 'battery_provider.g.dart';

@riverpod
BatteryService batteryService(Ref ref) {
  return BatteryService();
}

@riverpod
BatteryRepository batteryRepository(Ref ref) {
  // Use watch instead of read to safely track dependencies
  final service = ref.watch(batteryServiceProvider);
  return BatteryRepository(service);
}

// Replacement for StateNotifier/StateNotifierProvider
@riverpod
class Battery extends _$Battery {
  @override
  FutureOr<int> build() async {
    final repo = ref.watch(batteryRepositoryProvider);
    return repo.getLevel();
  }

  // Add any side effects / state alteration methods here
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(batteryRepositoryProvider).getLevel());
  }
}

// Replacement for StreamProvider
@riverpod
Stream<BatteryState> batteryState(Ref ref) {
  return ref.watch(batteryRepositoryProvider).streamState();
}
