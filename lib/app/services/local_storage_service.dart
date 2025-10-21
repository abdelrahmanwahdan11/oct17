import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._();

  static final LocalStorageService instance = LocalStorageService._();

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    final prefs = await _preferences;
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await _preferences;
    return prefs.getString(key);
  }

  Future<void> setStringList(String key, List<String> values) async {
    final prefs = await _preferences;
    await prefs.setStringList(key, values);
  }

  Future<List<String>> getStringList(String key) async {
    final prefs = await _preferences;
    return prefs.getStringList(key) ?? <String>[];
  }

  Future<void> remove(String key) async {
    final prefs = await _preferences;
    await prefs.remove(key);
  }
}
