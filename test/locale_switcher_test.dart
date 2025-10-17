import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_scaffold/core/utils/app_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('updates locale and notifies listeners', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = AppSettings();
    await settings.load();
    expect(settings.locale.languageCode, 'ar');
    var notified = false;
    settings.addListener(() => notified = true);
    await settings.updateLocale(const Locale('en'));
    expect(settings.locale.languageCode, 'en');
    expect(notified, isTrue);
  });
}
