import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const thresholdKey =
      "battery_threshold";

  static const lastTriggeredKey =
      "last_triggered";

  Future<void> saveThreshold(
    int value,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setInt(
      thresholdKey,
      value,
    );
  }

  Future<int> getThreshold() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getInt(
          thresholdKey,
        ) ??
        80;
  }

  Future<void> setTriggered(
    bool value,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      lastTriggeredKey,
      value,
    );
  }

  Future<bool> wasTriggered() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(
          lastTriggeredKey,
        ) ??
        false;
  }
}