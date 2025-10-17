import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  AppSettings();

  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale_code';

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('ar');
  bool _initialized = false;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get initialized => _initialized;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);
    final localeCode = prefs.getString(_localeKey);
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
    }
    if (localeCode != null) {
      _locale = Locale(localeCode);
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> updateTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  Future<void> updateLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
}
