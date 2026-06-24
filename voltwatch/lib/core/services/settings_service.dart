import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {

  final SharedPreferences sharedPreferences;
  SettingsService({required this.sharedPreferences});

  static const thresholdKey =
      "battery_threshold";

  static const lastTriggeredKey =
      "last_triggered";

  Future<void> saveThreshold(
    int value,
  ) async {
   

    await sharedPreferences.setInt(
      thresholdKey,
      value,
    );
  }

  Future<int> getThreshold() async {
    
        

    return sharedPreferences.getInt(
          thresholdKey,
        ) ??
        80;
  }

  Future<void> setTriggered(
    bool value,
  ) async {
    
      

    await sharedPreferences.setBool(
      lastTriggeredKey,
      value,
    );
  }

  Future<bool> wasTriggered() async {
  

    return sharedPreferences.getBool(
          lastTriggeredKey,
        ) ??
        false;
  }
}