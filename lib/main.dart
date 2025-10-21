import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/controllers/auth_controller.dart';
import 'app/controllers/cart_controller.dart';
import 'app/controllers/locale_controller.dart';
import 'app/controllers/orders_controller.dart';
import 'app/controllers/products_controller.dart';
import 'app/controllers/theme_controller.dart';
import 'app/controllers/wishlist_controller.dart';
import 'app/localization/app_localizations.dart';
import 'app/navigation/app_router.dart';
import 'app/navigation/app_scope.dart';
import 'app/repositories/cart_repository.dart';
import 'app/repositories/orders_repository.dart';
import 'app/repositories/products_repository.dart';
import 'app/repositories/wishlist_repository.dart';
import 'app/services/local_storage_service.dart';
import 'app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FashionApp());
}

class FashionApp extends StatefulWidget {
  const FashionApp({super.key});

  @override
  State<FashionApp> createState() => _FashionAppState();
}

class _FashionAppState extends State<FashionApp> {
  late final ProductsRepository _productsRepository;
  late final CartRepository _cartRepository;
  late final WishlistRepository _wishlistRepository;
  late final OrdersRepository _ordersRepository;

  late final ProductsController _productsController;
  late final CartController _cartController;
  late final WishlistController _wishlistController;
  late final OrdersController _ordersController;
  late final LocaleController _localeController;
  late final AuthController _authController;
  late final ThemeController _themeController;

  bool _isReady = false;
  String _initialRoute = 'home';
  String? _currentAuthRoute;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    final storage = LocalStorageService.instance;
    _productsRepository = ProductsRepository();
    _cartRepository = CartRepository(storage: storage);
    _wishlistRepository = WishlistRepository(storage: storage);
    _ordersRepository = OrdersRepository(storage: storage);

    _productsController = ProductsController(repository: _productsRepository);
    _cartController = CartController(
      repository: _cartRepository,
      productsRepository: _productsRepository,
    );
    _wishlistController = WishlistController(
      repository: _wishlistRepository,
      productsRepository: _productsRepository,
    );
    _ordersController = OrdersController(repository: _ordersRepository);
    _localeController = LocaleController(storage: storage);
    _authController = AuthController(storage: storage);
    _themeController = ThemeController(storage: storage);

    _wishlistController.addListener(() {
      _productsController.syncFavorites(_wishlistController.favoriteIds);
    });

    _authController.addListener(_handleAuthStateChanged);

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _localeController.loadLocale();
    await _themeController.initialize();
    await _authController.initialize();
    await _wishlistController.loadFavorites();
    await _cartController.loadCart();
    await _ordersController.initialize();
    await _productsController.initialize(favoriteIds: _wishlistController.favoriteIds);
    setState(() {
      _initialRoute = _authController.initialRoute;
      _currentAuthRoute = _initialRoute;
      _isReady = true;
    });
  }

  @override
  void dispose() {
    _productsController.dispose();
    _cartController.dispose();
    _wishlistController.dispose();
    _ordersController.dispose();
    _localeController.dispose();
    _authController.removeListener(_handleAuthStateChanged);
    _authController.dispose();
    _themeController.dispose();
    super.dispose();
  }

  void _handleAuthStateChanged() {
    if (!_isReady) return;
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;
    final targetRoute = _authController.initialRoute;
    if (_currentAuthRoute == targetRoute) {
      return;
    }
    navigator.pushNamedAndRemoveUntil(targetRoute, (route) => false);
    _currentAuthRoute = targetRoute;
  }

  @override
  Widget build(BuildContext context) {
    final content = !_isReady
        ? const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          )
        : AppScope(
            products: _productsController,
            cart: _cartController,
            wishlist: _wishlistController,
            locale: _localeController,
            orders: _ordersController,
            auth: _authController,
            theme: _themeController,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _localeController,
                _themeController,
              ]),
              builder: (context, _) {
                return MaterialApp(
                  navigatorKey: _navigatorKey,
                  title: 'Fashion Shop',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.buildLightTheme(),
                  darkTheme: AppTheme.buildDarkTheme(),
                  themeMode: _themeController.themeMode,
                  locale: _localeController.locale,
                  supportedLocales: LocaleController.supportedLocales,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  initialRoute: _initialRoute,
                  onGenerateRoute: AppRouter.onGenerateRoute,
                );
              },
            ),
          );

    return content;
  }
}
