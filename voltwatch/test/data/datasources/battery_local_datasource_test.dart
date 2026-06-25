import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:voltwatch/data/datasources/battery_local_datasource.dart';
import 'package:voltwatch/data/models/battery_log.dart';

// this will generate a mock class for the hive box
@GenerateMocks([Box])
import 'battery_local_datasource_test.mocks.dart';

void main() {
  group('BatteryLocalDatasource Tests', () {
    late MockBox<BatteryLog> mockBox;
    late BatteryLocalDatasource datasource;

    setUp(() {
      mockBox = MockBox<BatteryLog>();
      datasource = BatteryLocalDatasource(box: mockBox);
    });

    test('should save a battery log to the box', () async {
      final log = BatteryLog(
        batteryLevel: 50,
        batteryState: 'charging',
        timestamp: DateTime.now(),
      );
      when(mockBox.add(any)).thenAnswer((_) async => 1);
      await datasource.save(log);

      verify(mockBox.add(log)).called(1);
    });

    test('should retrieve logs in reverse order', () {
      final log1 = BatteryLog(
        batteryLevel: 50,
        batteryState: 'charging',
        timestamp: DateTime.now(),
      );
      final log2 = BatteryLog(
        batteryLevel: 30,
        batteryState: 'discharging',
        timestamp: DateTime.now(),
      );

      when(mockBox.values).thenReturn([log1, log2]);

      final logs = datasource.getLogs();

      expect(logs, [log2, log1]);
    });
  });
}
