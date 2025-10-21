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
    final authController = scope.auth;
    final localization = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: productsController,
      builder: (context, _) {
        final isPopularLoading =
            productsController.isLoading && productsController.popularProducts.isEmpty;
        final popularProducts = productsController.popularProducts;
        final catalogProducts = productsController.gridProducts;
        final isCatalogLoading =
            productsController.isLoading && catalogProducts.isEmpty;
        return Scaffold(
          appBar: _HomeAppBar(userName: authController.currentUser?.name),
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
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
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
                      child: isPopularLoading
                          ? const Center(
                              key: ValueKey('home_loading'),
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : SizedBox(
                              key: ValueKey<int>(popularProducts.length),
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
                                      itemCount: popularProducts.length,
                                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                                      itemBuilder: (context, index) {
                                        final product = popularProducts[index];
                                        return ProductCard(
                                          product: product,
                                          width: cardWidth,
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
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    SectionHeader(
                      title: localization.translate('home_catalogs_title'),
                      actionLabel: localization.translate('see_all'),
                      onAction: () {},
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: isCatalogLoading
                          ? const Padding(
                              key: ValueKey('catalog_loading'),
                              padding: EdgeInsets.symmetric(vertical: 48),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : LayoutBuilder(
                              key: ValueKey<int>(catalogProducts.length),
                              builder: (context, constraints) {
                                final width = constraints.maxWidth;
                                final crossAxisCount = width >= 1200
                                    ? 4
                                    : width >= 900
                                        ? 3
                                        : 2;
                                final itemWidth =
                                    (width - (crossAxisCount - 1) * 14) / crossAxisCount;
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 14,
                                    childAspectRatio: itemWidth / (itemWidth * 1.35),
                                  ),
                                  itemCount: catalogProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = catalogProducts[index];
                                    final computedDuration = 320 + index * 35;
                                    final animationDuration = Duration(
                                      milliseconds: computedDuration > 520 ? 520 : computedDuration,
                                    );
                                    return TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0.9, end: 1),
                                      duration: animationDuration,
                                      curve: Curves.easeOutBack,
                                      builder: (context, value, child) {
                                        return Transform.scale(
                                          scale: value,
                                          child: Opacity(
                                            opacity: value.clamp(0.0, 1.0),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: ProductCard(
                                        product: product,
                                        onTap: () => Navigator.of(context).pushNamed(
                                          'product.details',
                                          arguments: {'id': product.id},
                                        ),
                                        onToggleFavorite: () =>
                                            wishlistController.toggleFavorite(product.id),
                                        onAddToCart: () =>
                                            _addToCart(context, cartController, product),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                    if (productsController.isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
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

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar({this.userName});

  final String? userName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface.withOpacity(0.6),
    );
    return AppBar(
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization
                .translate('greeting_title')
                .replaceFirst('{name}', userName ?? localization.translate('default_user_name')),
            style: subtitleStyle,
          ),
          const SizedBox(height: 4),
          Text(
            localization.translate('greeting_subtitle'),
            style: theme.textTheme.displaySmall,
          ),
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
