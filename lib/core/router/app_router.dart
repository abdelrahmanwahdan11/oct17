import 'package:flutter/material.dart';

import '../../app/screens/auth/login_screen.dart';
import '../../app/screens/auth/register_screen.dart';
import '../../app/screens/auth/reset_password_screen.dart';
import '../../app/screens/auctions/auction_details_screen.dart';
import '../../app/screens/auctions/auction_list_screen.dart';
import '../../app/screens/auctions/place_bid_sheet.dart';
import '../../app/screens/common/splash_screen.dart';
import '../../app/screens/home/home_discovery_screen.dart';
import '../../app/screens/onboarding/onboarding_screen.dart';
import '../../app/screens/requests/request_list_screen.dart';
import '../../app/screens/settings/settings_screen.dart';
import '../../app/screens/common/placeholder_screen.dart';

class AppRoutes {
  static const splash = 'splash';
  static const onboarding = 'onboarding';
  static const authLogin = 'auth.login';
  static const authRegister = 'auth.register';
  static const authForgot = 'auth.forgot';
  static const homeDiscovery = 'home.discovery';
  static const auctionsList = 'auctions.list';
  static const auctionsDetails = 'auctions.details';
  static const auctionsPlaceBid = 'auctions.place_bid';
  static const auctionsCreate = 'auctions.create';
  static const auctionsMy = 'auctions.my';
  static const requestsList = 'requests.list';
  static const requestsDetails = 'requests.details';
  static const requestsCreate = 'requests.create';
  static const requestsMy = 'requests.my';
  static const matchesInbox = 'matches.inbox';
  static const favorites = 'favorites';
  static const search = 'search';
  static const filtersSheet = 'filters.sheet';
  static const notificationsCenter = 'notifications.center';
  static const profile = 'profile';
  static const settings = 'settings';
  static const moderationReport = 'moderation.report';
  static const help = 'help';
  static const about = 'about';
  static const legalTerms = 'legal.terms';
  static const legalPrivacy = 'legal.privacy';
}

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final observer = RouteObserver<PageRoute<dynamic>>();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _fade(const SplashScreen());
      case AppRoutes.onboarding:
        return _fade(const OnboardingScreen());
      case AppRoutes.authLogin:
        return _fade(LoginScreen());
      case AppRoutes.authRegister:
        return _fade(RegisterScreen());
      case AppRoutes.authForgot:
        return _fade(const ResetPasswordScreen());
      case AppRoutes.homeDiscovery:
        return _fade(const HomeDiscoveryScreen());
      case AppRoutes.auctionsList:
        return _fade(const AuctionListScreen());
      case AppRoutes.auctionsDetails:
        final id = settings.arguments is Map
            ? (settings.arguments as Map)['id'] as String? ?? ''
            : '';
        return _fade(AuctionDetailsScreen(auctionId: id));
      case AppRoutes.auctionsPlaceBid:
        final map = settings.arguments as Map? ?? const {};
        return _bottomSheet(
          PlaceBidSheet(
            auctionId: map['id'] as String,
            mode: map['mode'] as String?,
          ),
        );
      case AppRoutes.requestsList:
        return _fade(const RequestListScreen());
      case AppRoutes.settings:
        return _fade(const SettingsScreen());
      default:
        return _fade(PlaceholderScreen(routeName: settings.name ?? 'unknown'));
    }
  }

  static PageRoute<dynamic> _fade(Widget child) {
    return PageRouteBuilder<dynamic>(
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, animation, secondaryAnimation) => child,
      transitionsBuilder: (_, animation, __, widget) {
        final offsetTween = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          child: SlideTransition(position: animation.drive(offsetTween), child: widget),
        );
      },
    );
  }

  static PageRoute<dynamic> _bottomSheet(Widget child) {
    return PageRouteBuilder<dynamic>(
      opaque: false,
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: SizeTransition(
            sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            axisAlignment: -1,
            child: Material(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              clipBehavior: Clip.antiAlias,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
