import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../data/local/local_storage.dart';

class LocaleController extends ChangeNotifier {
  LocaleController(this._storage) {
    final savedCode = _storage.localeCode;
    if (savedCode != null) {
      _locale = Locale(savedCode);
    }
  }

  final LocalStorage _storage;
  Locale _locale = const Locale(AppLocalizations.defaultLocaleCode);

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (locale == _locale) return;
    _locale = locale;
    await _storage.setLocaleCode(locale.languageCode);
    notifyListeners();
  }
}
