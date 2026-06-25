import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:voltwatch/core/services/battery_service.dart';

@GenerateMocks([Battery])
import 'battery_service_test.mocks.dart';

void main() {
  late BatteryService batteryService;
  late MockBattery mockBattery;

  setUp(() {
    mockBattery = MockBattery();
    batteryService = BatteryService(battery: mockBattery);
  });

  group('BatteryService Tests', () {
    // Test 1: Battery Level Future
    test('BatteryLevel returns correct battery percentage', () async {
      when(mockBattery.batteryLevel).thenAnswer((_) async => 85);

      final result = await batteryService.batteryLevel;

      expect(result, equals(85));
      verify(mockBattery.batteryLevel).called(1);
    });

    // Test 2: Battery State Future
    test('BatteryState returns correct battery state', () async {
      when(
        mockBattery.batteryState,
      ).thenAnswer((_) async => BatteryState.charging);

      final result = await batteryService.batteryState;

      expect(result, equals(BatteryState.charging));
      verify(mockBattery.batteryState).called(1);
    });

    // Test 3: Battery Save Mode Future
    test('isInBatterySaveMode returns correct boolean status', () async {
      when(mockBattery.isInBatterySaveMode).thenAnswer((_) async => true);

      final result = await batteryService.isInBatterySaveMode;

      expect(result, isTrue);
      verify(mockBattery.isInBatterySaveMode).called(1);
    });

    // Test 4: Battery State Stream
    test('onBatteryStateChaged emits updated battery state', () async {
      final states = [BatteryState.discharging, BatteryState.charging];

      when(
        mockBattery.onBatteryStateChanged,
      ).thenAnswer((_) => Stream.fromIterable(states));

      expect(batteryService.onBatteryStateChanged, emitsInOrder(states));
    });
  });
}
