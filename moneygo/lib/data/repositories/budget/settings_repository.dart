import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository();

  Future<void> saveData(String key, String value) async {
    final settings = await SharedPreferences.getInstance();

    await settings.setString(key, value);
  }

  Future<Map<String, String>> getAllSettings() async {
    final settings = await SharedPreferences.getInstance();

    return settings.getKeys().fold<Map<String, String>>({}, (map, key) {
      map[key] = settings.getString(key)!;
      return map;
    });
  }

  Future<String?> getData(String key) async {
    final settings = await SharedPreferences.getInstance();

    return settings.getString(key);
  }

  Future<bool> updateData(String key, String value) async {
    final settings = await SharedPreferences.getInstance();

    return await settings.setString(key, value);
  }

  Future<void> deleteData(String key) async {
    final settings = await SharedPreferences.getInstance();

    await settings.remove(key);
  }

  Future<void> clearAllData() async {
    final settings = await SharedPreferences.getInstance();

    await settings.clear();
  }
}
