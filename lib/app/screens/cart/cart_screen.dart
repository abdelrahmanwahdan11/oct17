import 'package:flutter/material.dart';

import '../../controllers/cart_controller.dart';
import '../../navigation/app_scope.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/qty_stepper.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = AppScope.of(context).cart;
    return AnimatedBuilder(
      animation: cartController,
      builder: (context, _) {
        final lines = cartController.lines;
        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            title: const Text('My Cart'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                Expanded(
                  child: lines.isEmpty
                      ? const _EmptyCart()
                      : ListView.separated(
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
                                  color: AppColors.danger,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (_) => cartController.removeItem(line.item),
                              child: _CartTile(
                                line: line,
                                onQuantityChanged: (value) => cartController.updateQuantity(line.item, value),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16),
                _CouponRow(),
                const SizedBox(height: 16),
                _Totals(cartController: cartController),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Checkout not implemented (mock)')),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Checkout'),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
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
                Text(product.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Size: ${item.size}', style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Text(
                  '${String.fromCharCode(36)}${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.orange),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration.collapsed(hintText: 'Enter Discount Code'),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.cartController});

  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _TotalRow(label: 'Subtotal', value: cartController.subtotal),
          const SizedBox(height: 8),
          _TotalRow(label: 'Discount', value: cartController.discount),
          const Divider(height: 24),
          _TotalRow(label: 'Total', value: cartController.total, highlight: true),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: highlight ? FontWeight.w700 : FontWeight.w500)),
        Text(
          '${String.fromCharCode(36)}${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
            color: highlight ? AppColors.orange : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textSecondary),
          SizedBox(height: 16),
          Text('Your cart is empty'),
        ],
      ),
    );
  }
}
