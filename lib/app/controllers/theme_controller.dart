import 'package:flutter/material.dart';

import '../../data/local/local_storage.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this._storage) {
    final saved = _storage.themeMode;
    if (saved != null) {
      _themeMode = saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
  }

  final LocalStorage _storage;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  Future<void> toggle() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _storage.setThemeMode(_themeMode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
}
