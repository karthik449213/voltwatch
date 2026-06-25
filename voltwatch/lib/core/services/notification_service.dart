import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'settings_service.dart';
import '../../data/repositories/battery_repository.dart';

class NotificationService {

  NotificationService();

  static final NotificationService instance = NotificationService();

  final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();


  Future<bool> initialize() async {
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: android,
    );

    await plugin.initialize(settings:settings);
    // request the permissions and capture the result
    final bool? granted = await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
        // handle the denied/null case
     if (granted == null || !granted) {
          // log the restriction or rpeort to analytics witout crashing 
          print("Notification Permission Denied:local alerts will not be displated ");
         return false;
     }
     return true;
  }

  

  Future<void> showBatteryAlert(
    int percentage,
  ) async {

    const android = AndroidNotificationDetails(
      'battery_alerts',
      'Battery Alerts',
      channelDescription:
          'Threshold battery notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    await plugin.show(
      id: 100,
      title: 'Battery Alert',
      body: 'Your device battery has reached $percentage%',
       notificationDetails : NotificationDetails(android: android),
    );



  }

  Future<void> checkThreshold({
    required BatteryRepository repo,
    required SettingsService settings,
  }) async {

    final level = await repo.batteryLevel;
    final threshold = await settings.getThreshold();
    final alreadySent = await settings.wasTriggered();

    if (level >= threshold && !alreadySent) {
      // re-check or verify initializations status before triggering 
      final isAllowed = await initialize();
      if (isAllowed) {
       await NotificationService.instance.showBatteryAlert(threshold);
      await settings.setTriggered(true);
      }
      
    } else if (level < threshold) {
      await settings.setTriggered(false);
    }
  }
}


