import 'package:flutter/widgets.dart';

import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/locale_controller.dart';
import '../controllers/orders_controller.dart';
import '../controllers/products_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/wishlist_controller.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required super.child,
    required this.products,
    required this.cart,
    required this.wishlist,
    required this.locale,
    required this.orders,
    required this.auth,
    required this.theme,
  });

  final ProductsController products;
  final CartController cart;
  final WishlistController wishlist;
  final LocaleController locale;
  final OrdersController orders;
  final AuthController auth;
  final ThemeController theme;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant AppScope oldWidget) => false;
}
