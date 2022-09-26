import 'package:shared_preferences/shared_preferences.dart';

// Fonctionne avec int, bool, String
class DataReader {
  static Future<int> getInt(String key, [def = 0]) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key) ?? def;
  }

  static Future<bool> getBool(String key, [def = false]) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key) ?? def;
  }

  static Future<String> getString(String key, [def = ""]) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? def;
  }

  static void save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    }
  }
}
