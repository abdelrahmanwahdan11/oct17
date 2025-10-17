import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale, this._messages);

  final Locale locale;
  final Map<String, dynamic> _messages;

  static const supportedLocales = [Locale('ar'), Locale('en')];

  static const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    _AppLocalizationsDelegate(),
    DefaultWidgetsLocalizations.delegate,
    DefaultMaterialLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
  ];

  static Future<AppLocalizations> load(Locale locale) async {
    final jsonString = await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return AppLocalizations(locale, jsonMap);
  }

  String t(String key, {String? fallback}) {
    final segments = key.split('.');
    dynamic current = _messages;
    for (final segment in segments) {
      if (current is Map<String, dynamic> && current.containsKey(segment)) {
        current = current[segment];
      } else {
        return fallback ?? key;
      }
    }
    return current is String ? current as String : fallback ?? key;
  }

  TextDirection get textDirection =>
      locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;

  bool get isArabic => locale.languageCode == 'ar';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales
          .map((e) => e.languageCode)
          .contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
