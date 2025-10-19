import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/controllers/auth_controller.dart';
import 'app/controllers/auctions_controller.dart';
import 'app/controllers/favorites_controller.dart';
import 'app/controllers/locale_controller.dart';
import 'app/controllers/notifications_controller.dart';
import 'app/controllers/requests_controller.dart';
import 'app/controllers/theme_controller.dart';
import 'core/l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/orriso_theme.dart';
import 'core/utils/app_scope.dart';
import 'data/local/auction_repository.dart';
import 'data/local/local_storage.dart';
import 'data/local/notification_repository.dart';
import 'data/local/request_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storage = LocalStorage(prefs);
  final auctionsRepository = AuctionRepository();
  final requestsRepository = RequestRepository();
  final notificationRepository = NotificationRepository();

  final themeController = ThemeController(storage);
  final localeController = LocaleController(storage);
  final auctionsController = AuctionsController(auctionsRepository);
  final requestsController = RequestsController(requestsRepository);
  final favoritesController = FavoritesController(storage);
  final notificationsController = NotificationsController(notificationRepository);
  final authController = AuthController(storage);

  final dependencies = AppDependencies(
    themeController: themeController,
    localeController: localeController,
    auctionsController: auctionsController,
    requestsController: requestsController,
    favoritesController: favoritesController,
    notificationsController: notificationsController,
    authController: authController,
    storage: storage,
  );

  runApp(AppRoot(dependencies: dependencies));
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    final themeController = widget.dependencies.themeController;
    final localeController = widget.dependencies.localeController;
    return AnimatedBuilder(
      animation: Listenable.merge([themeController, localeController]),
      builder: (context, _) {
        final locale = localeController.locale;
        return AppScope(
          dependencies: widget.dependencies,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ORRISO',
            navigatorKey: AppRouter.navigatorKey,
            onGenerateRoute: AppRouter.onGenerateRoute,
            navigatorObservers: [AppRouter.observer],
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: OrrisoTheme.light(locale),
            darkTheme: OrrisoTheme.dark(locale),
            themeMode: themeController.themeMode,
          ),
        );
      },
    );
  }
}
