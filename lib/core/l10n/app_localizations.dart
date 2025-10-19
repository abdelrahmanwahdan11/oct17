import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  static const defaultLocaleCode = 'ar';
  static const supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  static const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    AppLocalizationsDelegate(),
    DefaultWidgetsLocalizations.delegate,
    DefaultMaterialLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
  ];

  final Locale locale;
  late Map<String, dynamic> _strings;

  Future<void> load() async {
    final asset = 'assets/l10n/${locale.languageCode}.json';
    final data = await rootBundle.loadString(asset);
    _strings = jsonDecode(data) as Map<String, dynamic>;
  }

  String t(String key) {
    return _resolve(key.split('.'), _strings) ?? key;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String? _resolve(List<String> path, Map<String, dynamic> map) {
    dynamic node = map;
    for (final segment in path) {
      if (node is Map<String, dynamic> && node.containsKey(segment)) {
        node = node[segment];
      } else {
        return null;
      }
    }
    if (node is String) return node;
    return null;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((item) => item.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
