import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:voltwatch/presentation/providers/battery_provider.dart';
import 'package:voltwatch/data/repositories/battery_repository.dart';
import 'package:voltwatch/core/services/settings_service.dart';

// Generate modern mocks for the layers used by the providers
@GenerateMocks([BatteryRepository, SettingsService])
import 'battery_provider_test.mocks.dart';

void main() {
  late MockBatteryRepository mockRepository;
  late MockSettingsService mockSettingsService;

  setUp(() {
    mockRepository = MockBatteryRepository();
    mockSettingsService = MockSettingsService();
  });

  // Helper function to initialize a Riverpod container with mocked overrides
  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        repositoryProvider.overrideWithValue(mockRepository),
        settingsProvider.overrideWithValue(mockSettingsService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('Battery Provider Integration Tests', () {
    test('batteryProvider should load the level from repository on creation', () async {
  // Arrange  Stub the repository's getter
  when(mockRepository.batteryLevel).thenAnswer((_) async => 85);

  //Set up a listener to capture state updates
  final container = ProviderContainer(
    overrides: [
      repositoryProvider.overrideWithValue(mockRepository),
    ],
  );
  addTearDown(container.dispose);

  // Wait for the state to turn into 85
  // This listener pattern halts execution until the async constructor finishes
  await expectLater(
    container.read(batteryProvider.notifier).stream,
    emits(85),
  );

  // Double check the final read state matches
  expect(container.read(batteryProvider), 85);
});

    test('batteryStateProvider should emit the correct state from repository', () async {
      // Arrange
      when(mockRepository.batteryState).thenAnswer((_) async => BatteryState.charging);
      final container = createContainer();

      // Act
      final stateAsyncValue = await container.read(batteryStateProvider.future);

      // Assert
      expect(stateAsyncValue, BatteryState.charging);
    });

    test('thresholdProvider should read the baseline from SettingsService', () async {
      // Arrange
      when(mockSettingsService.getThreshold()).thenAnswer((_) async => 75);
      final container = createContainer();

      // Act
      final thresholdValue = await container.read(thresholdProvider.future);

      // Assert
      expect(thresholdValue, 75);
    });
  });
}
