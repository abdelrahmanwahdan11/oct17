import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_scaffold/core/utils/app_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('changes theme mode', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = AppSettings();
    await settings.init();
    expect(settings.themeMode, ThemeMode.system);
    await settings.updateTheme(ThemeMode.dark);
    expect(settings.themeMode, ThemeMode.dark);
  });
}
