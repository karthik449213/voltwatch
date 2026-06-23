import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:voltwatch/core/services/battery_service.dart';
import 'package:voltwatch/data/repositories/battery_repository.dart';

// 1. Generate the Mock class for BatteryService
@GenerateMocks([BatteryService])
import 'battery_repository_test.mocks.dart';

void main() {
  late BatteryRepository repository;
  late MockBatteryService mockService;

  setUp(() {
    mockService = MockBatteryService();
    repository = BatteryRepository(mockService);
  });

  group('BatteryRepository Tests', () {
    test('getLevel returns value from service', () async {
      when(mockService.batteryLevel).thenAnswer((_) async => 92);

      final result = await repository.batteryLevel;

      expect(result, equals(92));
      verify(mockService.batteryLevel).called(1);
    });

    test('getState returns value from service', () async {
      when(mockService.batteryState).thenAnswer((_) async => BatteryState.charging);

      final result = await repository.batteryState;

      expect(result, equals(BatteryState.charging));
      verify(mockService.batteryState).called(1);
    });

    test('getIsSaveMode returns value from service', () async {
      when(mockService.isInBatterySaveMode).thenAnswer((_) async => false);

      final result = await repository.isInBatterySaveMode;

      expect(result, isFalse);
      verify(mockService.isInBatterySaveMode).called(1);
    });

    test('onStateChanged emits stream values from service', () async {
      final states = [BatteryState.charging];
      when(mockService.onBatteryStateChanged).thenAnswer((_) => Stream.fromIterable(states));

      expect(repository.onBatteryStateChanged, emitsInOrder(states));
    });
  });
}
