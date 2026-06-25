import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voltwatch/core/services/settings_service.dart';

// Generate a MockSharedPreferences class using Mockito
@GenerateMocks([SharedPreferences])
import 'settings_service_test.mocks.dart';

void main() {
  late SettingsService settingsService;
  late MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    settingsService = SettingsService(sharedPreferences: mockSharedPreferences);
  });

  group('SettingsService', () {
    test('saveThreshold saves the threshold value', () async {
      when(
        mockSharedPreferences.setInt(any, any),
      ).thenAnswer((_) async => true);

      await settingsService.saveThreshold(75);

      verify(
        mockSharedPreferences.setInt(SettingsService.thresholdKey, 75),
      ).called(1);
    });

    test('getThreshold returns the saved threshold value', () async {
      when(
        mockSharedPreferences.getInt(SettingsService.thresholdKey),
      ).thenReturn(75);

      final threshold = await settingsService.getThreshold();

      expect(threshold, 75);
    });

    test('setTriggered saves the triggered state', () async {
      when(
        mockSharedPreferences.setBool(any, any),
      ).thenAnswer((_) async => true);

      await settingsService.setLastTriggered(85);

      verify(
        mockSharedPreferences.setBool(
          SettingsService.lastTriggeredLevelKey,
          true,
        ),
      ).called(1);
    });

    test('wasTriggered returns the saved triggered state', () async {
      when(
        mockSharedPreferences.getBool(SettingsService.lastTriggeredLevelKey),
      ).thenReturn(true);

      final triggered = await settingsService.getLastTriggeredLevel();

      expect(triggered, 85);
    });
  });
}
