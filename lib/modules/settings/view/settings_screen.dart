import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';
import '../../../core/utils/app_settings_scope.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        appBar: AppBar(title: Text(loc.isArabic ? 'الإعدادات' : 'Settings')),
        body: ListView(
          children: [
            SwitchListTile.adaptive(
              title: Text(loc.isArabic ? 'الوضع الداكن' : 'Dark mode'),
              value: settings.themeMode == ThemeMode.dark,
              onChanged: (value) => settings
                  .updateTheme(value ? ThemeMode.dark : ThemeMode.light),
            ),
            ListTile(
              title: Text(loc.isArabic ? 'اللغة' : 'Language'),
              subtitle: Text(loc.locale.languageCode),
              trailing: DropdownButton<Locale>(
                value: settings.locale,
                onChanged: (value) {
                  if (value != null) settings.updateLocale(value);
                },
                items: const [
                  DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
                  DropdownMenuItem(value: Locale('en'), child: Text('English')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
