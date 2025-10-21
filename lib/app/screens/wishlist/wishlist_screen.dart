import 'package:flutter/material.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../localization/app_localizations.dart';
import '../../models/product.dart';
import '../../navigation/app_scope.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/common/app_search_bar.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final wishlistController = scope.wishlist;
    final cartController = scope.cart;
    final localization = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: wishlistController,
      builder: (context, _) {
        final items = wishlistController.products;
        final filtered = _query.isEmpty
            ? items
            : items
                .where((product) => product.title.toLowerCase().contains(_query.toLowerCase()))
                .toList();
        final isEmpty = filtered.isEmpty;
        return Scaffold(
          appBar: AppBar(
            title: Text(localization.translate('wishlist')),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed('cart'),
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                AppSearchBar(
                  hintText: localization.translate('search_hint'),
                  onChanged: (value) => setState(() => _query = value),
                  filterIcon: Icons.sort,
                ),
                const SizedBox(height: 12),
                if (isEmpty)
                  Expanded(child: _EmptyWishlist(localization: localization))
                else
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final product = filtered[index];
                        return ProductCard(
                          product: product,
                          onTap: () => Navigator.of(context).pushNamed(
                            'product.details',
                            arguments: {'id': product.id},
                          ),
                          onToggleFavorite: () => wishlistController.toggleFavorite(product.id),
                          onAddToCart: () => _addToCart(context, cartController, product),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addToCart(BuildContext context, CartController cartController, Product product) {
    final size = product.sizes.isNotEmpty ? product.sizes.first : 'M';
    cartController.addToCart(product, size: size);
    final localization = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localization.translate('added_to_cart'))),
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist({required this.localization});

  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            localization.translate('wishlist_empty_title'),
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            localization.translate('wishlist_empty_subtitle'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
