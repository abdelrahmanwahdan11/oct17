import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({this.storage = LocalStorageService.instance});

  final LocalStorageService storage;

  static const _storageKey = 'theme_mode_v1';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  Future<void> initialize() async {
    final value = await storage.getString(_storageKey);
    if (value == null) return;
    switch (value) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await storage.setString(_storageKey, _modeToString(mode));
    notifyListeners();
  }

  Future<void> toggleDarkMode() {
    final next = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    return updateThemeMode(next);
  }

  String _modeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
