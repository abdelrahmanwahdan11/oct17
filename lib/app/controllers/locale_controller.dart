import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';

class LocaleController extends ChangeNotifier {
  LocaleController({this.storage = LocalStorageService.instance});

  final LocalStorageService storage;
  static const String _storageKey = 'locale';

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final code = await storage.getString(_storageKey);
    if (code != null && code.isNotEmpty) {
      final matched = supportedLocales.firstWhere(
        (element) => element.languageCode == code,
        orElse: () => const Locale('en'),
      );
      _locale = matched;
      notifyListeners();
    }
  }

  Future<void> updateLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await storage.setString(_storageKey, locale.languageCode);
    notifyListeners();
  }
}
