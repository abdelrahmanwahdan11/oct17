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
import '../../widgets/common/promo_banner.dart';
import '../../widgets/common/section_header.dart';
import '../../utils/responsive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            productsController.isLoading && productsController.popularProducts.isEmpty;
        final products = productsController.popularProducts;
        return Scaffold(
            appBar: const _HomeAppBar(),
            body: RefreshIndicator(
              onRefresh: productsController.refresh,
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
                    const SizedBox(height: 12),
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
                    const PromoBanner(),
                    const SizedBox(height: 16),
                    SectionHeader(
                      title: localization.translate('popular_product'),
                      actionLabel: localization.translate('see_all'),
                      onAction: () {},
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: isLoading
                          ? const Center(
                              key: ValueKey('home_loading'),
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : SizedBox(
                              key: ValueKey<int>(products.length),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final width = constraints.maxWidth;
                                  final cardWidth = width >= 1200
                                      ? 240.0
                                      : width >= 900
                                          ? 220.0
                                          : width >= 600
                                              ? 200.0
                                              : 180.0;
                                  return SizedBox(
                                    height: cardWidth * 1.35,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: products.length,
                                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                                      itemBuilder: (context, index) {
                                        final product = products[index];
                                        return ProductCard(
                                          product: product,
                                          width: cardWidth,
                                          onTap: () => Navigator.of(context).pushNamed(
                                            'product.details',
                                            arguments: {'id': product.id},
                                          ),
                                          onToggleFavorite: () => wishlistController.toggleFavorite(product.id),
                                          onAddToCart: () => _addToCart(context, cartController, product),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
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

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface.withOpacity(0.6),
    );
    return AppBar(
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hello Alex,', style: subtitleStyle),
          const SizedBox(height: 4),
          Text('Good Morning!', style: theme.textTheme.displaySmall),
        ],
      ),
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CircleAvatar(
          backgroundImage: const AssetImage('assets/images/avatar_alex.png'),
          radius: 20,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
        ),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.lock_outline)),
        IconButton(
          onPressed: () => Navigator.of(context).pushNamed('cart'),
          icon: const Icon(Icons.shopping_cart_outlined),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
