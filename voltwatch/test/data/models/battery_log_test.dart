import 'package:flutter_test/flutter_test.dart';
import '../../../lib/data/models/battery_log.dart';
void main() {
    group('BatteryLog models Tests', () {

              // Define shared test variables
              final testTimestamp  = DateTime(2026,6,24,12,0,0);
              final testLevel = 50;
              final testState = 'charging';
            test('should correctly instantiate a preserve property values',() {
                //Create the model instance
                final log = BatteryLog(
                    batteryLevel:testLevel,
                    batteryState:testState,
                    timestamp:testTimestamp,

                );

                  // verify values are perfectly preserved
                  expect(log.batteryLevel,testLevel);
                  expect(log.batteryState,testState);
                  expect(log.timestamp,testTimestamp);
            });

            test('should confirm object types match expected class defintions', () {
                  // Arrange 
                  final log =BatteryLog(
                    batteryLevel:testLevel,
                    batteryState:testState,
                    timestamp:testTimestamp,

                  );
                   // Assert
                  expect(log,isA<BatteryLog>());  
            });
   });

}