import 'package:flutter/material.dart';

import 'core/i18n/strings.dart';
import 'core/router/app_router.dart';
import 'core/utils/app_settings.dart';
import 'core/utils/app_settings_scope.dart';
import 'theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = AppSettings();
  runApp(AppBootstrap(settings: settings));
}

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key, required this.settings});

  final AppSettings settings;

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late final ValueNotifier<AppRoutePath> _routeState;
  late final RouterConfig<AppRoutePath> _routerConfig;

  @override
  void initState() {
    super.initState();
    _routeState = ValueNotifier<AppRoutePath>(const AppRoutePath('/splash'));
    _routerConfig = createRouter(_routeState);
    widget.settings.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.settings,
      builder: (context, _) {
        if (!widget.settings.initialized) {
          return const MaterialApp(home: SizedBox());
        }
        final locale = widget.settings.locale;
        final lightTheme = AppTheme.light(locale);
        final darkTheme = AppTheme.dark(locale);
        return AppSettingsScope(
          notifier: widget.settings,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: widget.settings.themeMode,
            routerConfig: _routerConfig,
          ),
        );
      },
    );
  }
}
