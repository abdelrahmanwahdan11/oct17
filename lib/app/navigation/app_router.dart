import 'package:flutter/material.dart';

import '../navigation/root_shell.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/common/placeholder_screen.dart';
import '../screens/product/product_details_screen.dart';
import '../screens/search/filter_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/orders/order_success_screen.dart';
import '../screens/orders/orders_screen.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return _buildDefaultRoute(RootShell(initialIndex: 0), settings);
      case 'shopping':
        return _buildDefaultRoute(const RootShell(initialIndex: 1), settings);
      case 'wishlist':
        return _buildDefaultRoute(const RootShell(initialIndex: 2), settings);
      case 'account':
        return _buildDefaultRoute(const RootShell(initialIndex: 3), settings);
      case 'product.details':
        final arguments = settings.arguments as Map<String, dynamic>?;
        final productId = arguments?['id'] as String?;
        if (productId == null) {
          return _buildDefaultRoute(
            const PlaceholderScreen(title: 'Product not found'),
            settings,
          );
        }
        return _buildDefaultRoute(ProductDetailsScreen(productId: productId), settings);
      case 'cart':
        return _buildDefaultRoute(const CartScreen(), settings);
      case 'checkout':
        return _buildDefaultRoute(const CheckoutScreen(), settings);
      case 'order.success':
        final arguments = settings.arguments as Map<String, dynamic>?;
        final orderId = arguments?['orderId'] as String?;
        return _buildDefaultRoute(OrderSuccessScreen(orderId: orderId), settings);
      case 'orders':
        return _buildDefaultRoute(const OrdersScreen(), settings);
      case 'search':
        return _buildDefaultRoute(const SearchScreen(), settings);
      case 'filter':
        return _buildModalRoute(const FilterScreen(), settings);
    }
    return null;
  }

  static PageRoute<dynamic> _buildDefaultRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        final fadeAnimation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
    );
  }

  static PageRoute<dynamic> _buildModalRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      fullscreenDialog: true,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
          child: child,
        );
      },
    );
  }
}
