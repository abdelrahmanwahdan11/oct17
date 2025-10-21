import 'package:flutter/material.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/products_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../localization/app_localizations.dart';
import '../../models/product.dart';
import '../../navigation/app_scope.dart';
import '../../widgets/common/qty_stepper.dart';
import '../../widgets/common/size_chips.dart';
import '../../utils/responsive.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  String? _selectedSize;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final productsController = scope.products;
    final wishlistController = scope.wishlist;
    final cartController = scope.cart;
    final localization = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: wishlistController,
      builder: (context, _) {
        final product = productsController.findById(widget.productId);
        if (product == null) {
          return Scaffold(
            appBar: AppBar(leading: const BackButton()),
            body: Center(child: Text(localization.translate('product_not_found'))),
          );
        }

        _selectedSize ??= product.sizes.isNotEmpty ? product.sizes.first : null;

        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            title: Text(localization.translate('details')),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
              IconButton(
                onPressed: () => wishlistController.toggleFavorite(product.id),
                icon: Icon(
                  wishlistController.isFavorite(product.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: responsivePagePadding(context),
            child: responsiveConstrainedBody(
              context,
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 780;
                  final details = _DetailsSection(
                    product: product,
                    localization: localization,
                    selectedSize: _selectedSize,
                    onSizeSelected: (value) => setState(() => _selectedSize = value),
                    quantity: _quantity,
                    onQuantityChanged: (value) => setState(() => _quantity = value),
                  );
                  final gallery = _ImageGallery(
                    product: product,
                    controller: _pageController,
                    currentPage: _currentPage,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    onThumbnailTap: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                      );
                      setState(() => _currentPage = index);
                    },
                  );

                  if (!isWide) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [gallery, const SizedBox(height: 24), details],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: gallery),
                      const SizedBox(width: 24),
                      Expanded(child: details),
                    ],
                  );
                },
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _handleAddToCart(context, cartController, product, goToCart: false),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: Text(localization.translate('add_to_cart')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          _handleAddToCart(context, cartController, product, goToCart: true),
                      child: Text(localization.translate('buy_now')),
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

  void _handleAddToCart(BuildContext context, CartController cartController, Product product,
      {required bool goToCart}) {
    final size = _selectedSize;
    if (size == null) {
      final localization = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.translate('please_select_size'))),
      );
      return;
    }
    cartController.addToCart(product, size: size, quantity: _quantity);
    final localization = AppLocalizations.of(context);
    final message = goToCart
        ? localization.translate('added_opening_cart')
        : localization.translate('added_to_cart');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    if (goToCart) {
      Navigator.of(context).pushNamed('cart');
    }
  }
}

class _ImageGallery extends StatelessWidget {
  const _ImageGallery({
    required this.product,
    required this.controller,
    required this.currentPage,
    required this.onPageChanged,
    required this.onThumbnailTap,
  });

  final Product product;
  final PageController controller;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onThumbnailTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: Hero(
            tag: 'product_image_${product.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: PageView.builder(
                controller: controller,
                itemCount: product.gallery.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  return Image.asset(
                    product.gallery[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: product.gallery.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final isActive = index == currentPage;
              return GestureDetector(
                onTap: () => onThumbnailTap(index),
                child: Container(
                  width: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).dividerColor.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(product.gallery[index], fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({
    required this.product,
    required this.localization,
    required this.selectedSize,
    required this.onSizeSelected,
    required this.quantity,
    required this.onQuantityChanged,
  });

  final Product product;
  final AppLocalizations localization;
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: theme.textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '${String.fromCharCode(36)}${product.price.toStringAsFixed(0)}',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${String.fromCharCode(36)}${product.oldPrice.toStringAsFixed(0)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          localization.translate('select_size'),
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        SizeChips(
          sizes: product.sizes,
          selected: selectedSize,
          onSelected: onSizeSelected,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localization.translate('quantity'),
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            QtyStepper(value: quantity, onChanged: onQuantityChanged),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          localization.translate('description'),
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: theme.textTheme.bodyMedium,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
