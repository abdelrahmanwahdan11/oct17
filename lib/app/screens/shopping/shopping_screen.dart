import 'package:flutter/material.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/products_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../localization/app_localizations.dart';
import '../../models/product.dart';
import '../../navigation/app_scope.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/common/app_search_bar.dart';
import '../../widgets/common/category_chips.dart';
import '../../utils/responsive.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  static const List<String> _audiences = ['All', 'Men', 'Women', 'Girls'];

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final productsController = scope.products;
    final wishlistController = scope.wishlist;
    final cartController = scope.cart;
    final localization = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: productsController,
      builder: (context, _) {
        final isLoading =
            productsController.isLoading && productsController.gridProducts.isEmpty;
        final products = productsController.gridProducts;
        return Scaffold(
          appBar: AppBar(
            title: const Text(''),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed('cart'),
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: productsController.refresh,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 120 &&
                    productsController.hasMore &&
                    !productsController.isLoadingMore) {
                  productsController.loadMore();
                }
                return false;
              },
              child: responsiveConstrainedBody(
                context,
                ListView(
                  padding: responsivePagePadding(context),
                  children: [
                    AppSearchBar(
                      hintText: localization.translate('search_hint'),
                      initialValue: productsController.searchTerm,
                      onChanged: productsController.setSearchTerm,
                      onFilter: () => Navigator.of(context).pushNamed('filter'),
                      onVoice: () {},
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localization.translate('categories'),
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(localization.translate('see_all')),
                        ),
                      ],
                    ),
                    CategoryChips(
                      categories: _audiences,
                      selected: productsController.selectedAudience,
                      onSelected: productsController.setAudience,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localization.translate('popular_product'),
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(localization.translate('see_all')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: isLoading
                          ? const Padding(
                              key: ValueKey('shopping_loading'),
                              padding: EdgeInsets.symmetric(vertical: 48),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : SizedBox(
                              key: ValueKey<int>(products.length),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final width = constraints.maxWidth;
                                  final crossAxisCount = width >= 1200
                                      ? 4
                                      : width >= 900
                                          ? 3
                                          : 2;
                                  final cardWidth =
                                      (width - (crossAxisCount - 1) * 12) / crossAxisCount;
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: cardWidth / (cardWidth * 1.35),
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      final product = products[index];
                                      return ProductCard(
                                        product: product,
                                        onTap: () => Navigator.of(context).pushNamed(
                                          'product.details',
                                          arguments: {'id': product.id},
                                        ),
                                        onToggleFavorite: () =>
                                            wishlistController.toggleFavorite(product.id),
                                        onAddToCart: () =>
                                            _addToCart(context, cartController, product),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                    ),
                    if (productsController.isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    const SizedBox(height: 12),
                    Container(
                      height: 92,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primaryContainer,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '40% Get Your Special Sale Up To',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
