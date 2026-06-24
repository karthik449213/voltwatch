import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance =
      NotificationService._();

  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: android,
    );

    await plugin.initialize(settings);

    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
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
      100,
      'Battery Alert',
      'Your device battery has reached $percentage%',
      const NotificationDetails(
        android: android,
      ),
    );
  }
}