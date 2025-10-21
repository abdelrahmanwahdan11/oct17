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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final scope = AppScope.maybeOf(context);
    if (scope == null) return;
    final controller = scope.products;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 120 &&
        controller.hasMore &&
        !controller.isLoadingMore) {
      controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final productsController = scope.products;
    final wishlistController = scope.wishlist;
    final cartController = scope.cart;
    final localization = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([productsController, wishlistController]),
      builder: (context, _) {
        final products = productsController.gridProducts;
        final isInitialLoading =
            productsController.isLoading && productsController.gridProducts.isEmpty;
        return Scaffold(
          appBar: AppBar(title: Text(localization.translate('search'))),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: productsController.refresh,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: AppSearchBar(
                        hintText: localization.translate('search_hint'),
                        initialValue: productsController.searchTerm,
                        onChanged: productsController.setSearchTerm,
                        onFilter: () => Navigator.of(context).pushNamed('filter'),
                      ),
                    ),
                  ),
                  if (isInitialLoading)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (products.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
                            const SizedBox(height: 12),
                            Text(localization.translate('no_results')),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
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
                          childCount: products.length,
                        ),
                      ),
                    ),
                  if (productsController.isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
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
    final localization = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localization.translate('added_to_cart'))),
    );
  }
}
