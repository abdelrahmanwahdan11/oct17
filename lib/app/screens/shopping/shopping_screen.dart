import 'package:flutter/material.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/products_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../localization/app_localizations.dart';
import '../../models/product.dart';
import '../../navigation/app_scope.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/common/app_search_bar.dart';
import '../../widgets/common/category_chips.dart';

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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
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
                        onToggleFavorite: () => wishlistController.toggleFavorite(product.id),
                        onAddToCart: () => _addToCart(context, cartController, product),
                      );
                    },
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
                      gradient: const LinearGradient(colors: [AppColors.orange, AppColors.orangeDark]),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '40% Get Your Special Sale Up To',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.orange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ),
                ],
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart')),
    );
  }
}
