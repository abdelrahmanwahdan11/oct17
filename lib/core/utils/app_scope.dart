import 'package:flutter/widgets.dart';

import '../../app/controllers/auth_controller.dart';
import '../../app/controllers/auctions_controller.dart';
import '../../app/controllers/favorites_controller.dart';
import '../../app/controllers/locale_controller.dart';
import '../../app/controllers/notifications_controller.dart';
import '../../app/controllers/requests_controller.dart';
import '../../app/controllers/theme_controller.dart';
import '../../data/local/local_storage.dart';

class AppDependencies {
  AppDependencies({
    required this.themeController,
    required this.localeController,
    required this.auctionsController,
    required this.requestsController,
    required this.favoritesController,
    required this.notificationsController,
    required this.authController,
    required this.storage,
  });

  final ThemeController themeController;
  final LocaleController localeController;
  final AuctionsController auctionsController;
  final RequestsController requestsController;
  final FavoritesController favoritesController;
  final NotificationsController notificationsController;
  final AuthController authController;
  final LocalStorage storage;
}

class AppScope extends InheritedWidget {
  const AppScope({super.key, required super.child, required this.dependencies});

  final AppDependencies dependencies;

  static AppDependencies of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in context');
    return scope!.dependencies;
  }

  @override
  bool updateShouldNotify(covariant AppScope oldWidget) => false;
}
