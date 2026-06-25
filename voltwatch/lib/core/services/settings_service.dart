import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final SharedPreferences sharedPreferences;
  SettingsService({required this.sharedPreferences});

  static const thresholdKey = "battery_threshold";

  static const lastTriggeredLevelKey = "last_triggered_level";

  Future<void> saveThreshold(int value) async {
    await sharedPreferences.setInt(thresholdKey, value);
    await sharedPreferences.remove(lastTriggeredLevelKey);
  }

  // store the exact battery level that fired the notification
  Future<void> setLastTriggered(int level) async {
    await sharedPreferences.setInt(lastTriggeredLevelKey, level);
  }

  Future<int> getThreshold() async {
    return sharedPreferences.getInt(thresholdKey) ?? 80;
  }

  //  Retrieve the last recorded notification alert level
  Future<int?> getLastTriggeredLevel() async {
    return sharedPreferences.getInt(lastTriggeredLevelKey);
  }

  //  Clear the trigger flag completely when the battery falls safely below the threshold
  Future<void> clearTrigger() async {
    await sharedPreferences.remove(lastTriggeredLevelKey);
  }

  Future<bool> wasTriggered() async {
    return sharedPreferences.getBool(lastTriggeredLevelKey) ?? false;
  }
}
