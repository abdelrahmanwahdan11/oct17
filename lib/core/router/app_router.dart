import 'package:flutter/material.dart';

import '../../modules/auth/view/auth_screen.dart';
import '../../modules/booking_or_cart/view/booking_screen.dart';
import '../../modules/details/view/details_screen.dart';
import '../../modules/help_center/view/help_center_screen.dart';
import '../../modules/home/view/home_shell.dart';
import '../../modules/onboarding/view/onboarding_screen.dart';
import '../../modules/orders/view/orders_screen.dart';
import '../../modules/profile/view/profile_screen.dart';
import '../../modules/search/view/search_screen.dart';
import '../../modules/settings/view/settings_screen.dart';
import '../../modules/splash/view/splash_screen.dart';
import '../../modules/admin_stub/view/admin_stub_screen.dart';
import '../../modules/notifications/view/notifications_screen.dart';

class AppRoutePath {
  const AppRoutePath(this.location);
  final String location;

  bool get isHomeShell => location == '/home';
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  const AppRouteInformationParser();

  @override
  Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final location = routeInformation.uri.path;
    if (location.isEmpty || location == '/') {
      return const AppRoutePath('/splash');
    }
    return AppRoutePath(location);
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    return RouteInformation(uri: Uri.parse(configuration.location));
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  AppRouterDelegate(this._appState);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final ValueNotifier<AppRoutePath> _appState;

  @override
  AppRoutePath? get currentConfiguration => _appState.value;

  void setNewRoute(String location) {
    _appState.value = AppRoutePath(location);
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _appState.value = configuration;
  }

  @override
  Widget build(BuildContext context) {
    final location = _appState.value.location;
    final pages = <Page<dynamic>>[];

    Widget child;
    switch (location) {
      case '/splash':
        child = SplashScreen(onFinished: () => setNewRoute('/onboarding'));
        break;
      case '/onboarding':
        child = OnboardingScreen(onGetStarted: () => setNewRoute('/auth'));
        break;
      case '/auth':
        child = AuthScreen(onAuthenticated: () => setNewRoute('/home'));
        break;
      case '/search':
        child = const SearchScreen();
        break;
      case '/details':
        child = DetailsScreen(onBack: () => navigatorKey.currentState?.pop());
        break;
      case '/booking':
        child = const BookingScreen();
        break;
      case '/orders':
        child = const OrdersScreen();
        break;
      case '/profile':
        child = const ProfileScreen();
        break;
      case '/settings':
        child = const SettingsScreen();
        break;
      case '/notifications':
        child = const NotificationsScreen();
        break;
      case '/help':
        child = const HelpCenterScreen();
        break;
      case '/admin':
        child = const AdminStubScreen();
        break;
      case '/home':
      default:
        child = HomeShell(onNavigate: setNewRoute);
        break;
    }

    pages.add(MaterialPage<dynamic>(child: child, key: ValueKey<String>('page_$location')));

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if (location != '/home') {
          setNewRoute('/home');
        }
        return true;
      },
    );
  }
}

RouterConfig<AppRoutePath> createRouter(ValueNotifier<AppRoutePath> state) {
  return RouterConfig<AppRoutePath>(
    routerDelegate: AppRouterDelegate(state),
    routeInformationParser: const AppRouteInformationParser(),
  );
}
