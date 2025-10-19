import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage(this._prefs);

  static const _favoritesKey = 'favorites';
  static const _themeKey = 'theme';
  static const _localeKey = 'locale';
  static const _onboardingKey = 'onboarding_done';
  static const _authUserKey = 'auth_user';
  static const _savedFiltersPrefix = 'saved_filter_';

  final SharedPreferences _prefs;

  bool get onboardingDone => _prefs.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingDone() => _prefs.setBool(_onboardingKey, true);

  String? get themeMode => _prefs.getString(_themeKey);

  Future<void> setThemeMode(String mode) => _prefs.setString(_themeKey, mode);

  String? get localeCode => _prefs.getString(_localeKey);

  Future<void> setLocaleCode(String code) => _prefs.setString(_localeKey, code);

  Map<String, dynamic>? get authUser {
    final raw = _prefs.getString(_authUserKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> saveAuthUser(Map<String, dynamic> user) async {
    await _prefs.setString(_authUserKey, jsonEncode(user));
  }

  Future<void> clearAuthUser() => _prefs.remove(_authUserKey);

  List<String> get favorites => _prefs.getStringList(_favoritesKey) ?? <String>[];

  Future<void> saveFavorites(List<String> ids) => _prefs.setStringList(_favoritesKey, ids);

  Future<void> clearAll() => _prefs.clear();

  Map<String, dynamic>? getSavedFilter(String context) {
    final raw = _prefs.getString('$_savedFiltersPrefix$context');
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> saveFilter(String context, Map<String, dynamic> filter) {
    return _prefs.setString('$_savedFiltersPrefix$context', jsonEncode(filter));
  }
}
