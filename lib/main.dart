import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/controllers/cart_controller.dart';
import 'app/controllers/locale_controller.dart';
import 'app/controllers/orders_controller.dart';
import 'app/controllers/products_controller.dart';
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

  bool _isReady = false;

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

    _wishlistController.addListener(() {
      _productsController.syncFavorites(_wishlistController.favoriteIds);
    });

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _localeController.loadLocale();
    await _wishlistController.loadFavorites();
    await _cartController.loadCart();
    await _ordersController.initialize();
    await _productsController.initialize(favoriteIds: _wishlistController.favoriteIds);
    setState(() => _isReady = true);
  }

  @override
  void dispose() {
    _productsController.dispose();
    _cartController.dispose();
    _wishlistController.dispose();
    _ordersController.dispose();
    _localeController.dispose();
    super.dispose();
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
            child: AnimatedBuilder(
              animation: _localeController,
              builder: (context, _) {
                return MaterialApp(
                  title: 'Fashion Shop',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.buildTheme(),
                  locale: _localeController.locale,
                  supportedLocales: LocaleController.supportedLocales,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  initialRoute: 'home',
                  onGenerateRoute: AppRouter.onGenerateRoute,
                );
              },
            ),
          );

    return content;
  }
}
