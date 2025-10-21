import 'package:flutter/material.dart';

import '../../controllers/cart_controller.dart';
import '../../localization/app_localizations.dart';
import '../../navigation/app_scope.dart';
import '../../utils/responsive.dart';
import '../../widgets/common/qty_stepper.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = AppScope.of(context).cart;
    final localization = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: cartController,
      builder: (context, _) {
        final lines = cartController.lines;
        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            title: Text(localization.translate('cart_title')),
          ),
          body: responsiveConstrainedBody(
            context,
            Padding(
              padding: responsivePagePadding(context),
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: lines.isEmpty
                          ? _EmptyCart(
                              key: const ValueKey('cart_empty'),
                              localization: localization,
                            )
                          : ListView.separated(
                              key: ValueKey<int>(lines.length),
                              itemCount: lines.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final line = lines[index];
                                return Dismissible(
                                  key: ValueKey('${line.item.productId}_${line.item.size}'),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.error,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: const Icon(Icons.delete, color: Colors.white),
                                  ),
                                  onDismissed: (_) => cartController.removeItem(line.item),
                                  child: _CartTile(
                                    line: line,
                                    onQuantityChanged: (value) =>
                                        cartController.updateQuantity(line.item, value),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _CouponRow(localization: localization),
                  const SizedBox(height: 16),
                  _Totals(cartController: cartController, localization: localization),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: lines.isEmpty
                      ? null
                      : () => Navigator.of(context).pushNamed('checkout'),
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(localization.translate('checkout')),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CartTile extends StatelessWidget {
  const _CartTile({required this.line, required this.onQuantityChanged});

  final CartLine line;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final product = line.product;
    final item = line.item;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.35) : Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(product.image, width: 72, height: 72, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  'Size: ${item.size}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${String.fromCharCode(36)}${product.price.toStringAsFixed(0)}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          QtyStepper(value: item.quantity, onChanged: onQuantityChanged),
        ],
      ),
    );
  }
}

class _CouponRow extends StatelessWidget {
  const _CouponRow({required this.localization});

  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration:
                  InputDecoration.collapsed(hintText: localization.translate('discount_code_hint')),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            child: Text(localization.translate('apply')),
          ),
        ],
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.cartController, required this.localization});

  final CartController cartController;
  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.35) : Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _TotalRow(label: localization.translate('subtotal'), value: cartController.subtotal),
          const SizedBox(height: 8),
          _TotalRow(label: localization.translate('discount'), value: cartController.discount),
          const Divider(height: 24),
          _TotalRow(label: localization.translate('total'), value: cartController.total, highlight: true),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value, this.highlight = false});

  final String label;
  final double value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: highlight ? FontWeight.w700 : FontWeight.w500)),
        Text(
          '${String.fromCharCode(36)}${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
            color: highlight ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({super.key, required this.localization});

  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(localization.translate('cart_empty')),
        ],
      ),
    );
  }
}
