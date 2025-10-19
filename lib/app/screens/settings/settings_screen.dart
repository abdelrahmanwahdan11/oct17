import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/app_scope.dart';
import '../../widgets/app_background.dart';
import '../../widgets/glass_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _localeValue;
  final Set<String> _notifPrefs = <String>{};

  @override
  void initState() {
    super.initState();
    final deps = AppScope.of(context);
    _localeValue = deps.localeController.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final deps = AppScope.of(context);
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: OrrisoBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AnimatedBuilder(
              animation: deps.themeController,
              builder: (context, _) {
                return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    Text(strings.t('settings.title'), style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
                const SizedBox(height: 24),
                GlassSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        value: deps.themeController.isDark,
                        onChanged: (_) => deps.themeController.toggle(),
                        title: Text(strings.t('settings.darkMode')),
                      ),
                      const Divider(),
                      DropdownButtonFormField<String>(
                        value: _localeValue,
                        decoration: InputDecoration(labelText: strings.t('settings.language')),
                        items: const [
                          DropdownMenuItem(value: 'ar', child: Text('العربية')),
                          DropdownMenuItem(value: 'en', child: Text('English')),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _localeValue = value);
                          deps.localeController.setLocale(Locale(value));
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(strings.t('settings.notifications'), style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          FilterChip(
                            label: const Text('Outbid'),
                            selected: _notifPrefs.contains('outbid'),
                            onSelected: (value) => setState(() {
                              if (value) {
                                _notifPrefs.add('outbid');
                              } else {
                                _notifPrefs.remove('outbid');
                              }
                            }),
                          ),
                          FilterChip(
                            label: const Text('Matches'),
                            selected: _notifPrefs.contains('match'),
                            onSelected: (value) => setState(() {
                              if (value) {
                                _notifPrefs.add('match');
                              } else {
                                _notifPrefs.remove('match');
                              }
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () async {
                          await deps.storage.clearAll();
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(strings.t('settings.clearCache'))),
                          );
                        },
                        child: Text(strings.t('settings.clearCache')),
                      ),
                    ],
                  ),
                ),
              ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
