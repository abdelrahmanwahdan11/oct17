import 'package:flutter/material.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/orders_controller.dart';
import '../../localization/app_localizations.dart';
import '../../navigation/app_scope.dart';
import '../../theme/app_colors.dart';
import '../../models/order.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final cartController = scope.cart;
    final ordersController = scope.orders;
    final localization = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([cartController, ordersController]),
      builder: (context, _) {
        final lines = cartController.lines;
        return Scaffold(
          appBar: AppBar(title: Text(localization.translate('checkout_title'))),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              _SectionHeader(
                title: localization.translate('shipping_address'),
                editLabel: localization.translate('edit'),
                onEdit: () => _showAddressSheet(context, ordersController, localization),
              ),
              _AddressCard(address: ordersController.shippingAddress),
              const SizedBox(height: 16),
              _SectionHeader(
                title: localization.translate('payment_method'),
                editLabel: localization.translate('edit'),
                onEdit: () => _showPaymentSheet(context, ordersController, localization),
              ),
              _PaymentCard(paymentMethod: ordersController.paymentMethod),
              const SizedBox(height: 16),
              Text(
                localization.translate('order_summary'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              if (lines.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Center(
                    child: Text(
                      localization.translate('order_empty_cart_message'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else ...[
                for (final line in lines) ...[
                  _SummaryTile(line: line),
                  const SizedBox(height: 12),
                ],
                _TotalsCard(
                  subtotal: cartController.subtotal,
                  discount: cartController.discount,
                  total: cartController.total,
                  localization: localization,
                ),
              ],
            ],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: lines.isEmpty || ordersController.isPlacingOrder
                      ? null
                      : () => _placeOrder(context, cartController, ordersController, localization),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange),
                  child: ordersController.isPlacingOrder
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        )
                      : Text(localization.translate('place_order')),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _placeOrder(
    BuildContext context,
    CartController cartController,
    OrdersController ordersController,
    AppLocalizations localization,
  ) async {
    final order = await ordersController.placeOrder(
      cartLines: cartController.lines,
      discount: cartController.discount,
    );
    if (order == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.translate('order_empty_cart_message'))),
      );
      return;
    }
    await cartController.clear();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      'order.success',
      ModalRoute.withName('home'),
      arguments: {'orderId': order.id},
    );
  }

  void _showAddressSheet(
    BuildContext context,
    OrdersController controller,
    AppLocalizations localization,
  ) {
    final address = controller.shippingAddress;
    final nameController = TextEditingController(text: address.fullName);
    final phoneController = TextEditingController(text: address.phone);
    final streetController = TextEditingController(text: address.street);
    final cityController = TextEditingController(text: address.city);
    final countryController = TextEditingController(text: address.country);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                localization.translate('edit_address'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _LabeledField(controller: nameController, label: localization.translate('name_label')),
              const SizedBox(height: 12),
              _LabeledField(controller: phoneController, label: localization.translate('phone_label'), keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              _LabeledField(controller: streetController, label: localization.translate('street_label')),
              const SizedBox(height: 12),
              _LabeledField(controller: cityController, label: localization.translate('city_label')),
              const SizedBox(height: 12),
              _LabeledField(controller: countryController, label: localization.translate('country_label')),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        streetController.text.isEmpty ||
                        cityController.text.isEmpty ||
                        countryController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localization.translate('form_incomplete_message'))),
                      );
                      return;
                    }
                    controller.updateShippingAddress(
                      ShippingAddress(
                        fullName: nameController.text,
                        phone: phoneController.text,
                        street: streetController.text,
                        city: cityController.text,
                        country: countryController.text,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange),
                  child: Text(localization.translate('save_changes')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentSheet(
    BuildContext context,
    OrdersController controller,
    AppLocalizations localization,
  ) {
    final method = controller.paymentMethod;
    final brandController = TextEditingController(text: method.brand);
    final lastFourController = TextEditingController(text: method.lastFour);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                localization.translate('edit_payment'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _LabeledField(controller: brandController, label: localization.translate('payment_brand_label')),
              const SizedBox(height: 12),
              _LabeledField(
                controller: lastFourController,
                label: localization.translate('payment_last4_label'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (brandController.text.isEmpty || lastFourController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localization.translate('form_incomplete_message'))),
                      );
                      return;
                    }
                    controller.updatePaymentMethod(
                      PaymentMethodInfo(
                        brand: brandController.text,
                        lastFour: lastFourController.text,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange),
                  child: Text(localization.translate('save_changes')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.editLabel, required this.onEdit});

  final String title;
  final String editLabel;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        TextButton(onPressed: onEdit, child: Text(editLabel)),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address});

  final ShippingAddress address;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(address.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(address.phone, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Text(address.street),
          const SizedBox(height: 4),
          Text('${address.city}, ${address.country}', style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.paymentMethod});

  final PaymentMethodInfo paymentMethod;

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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.orangeSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.credit_card, color: AppColors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(paymentMethod.brand, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('•••• ${paymentMethod.lastFour}', style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.line});

  final CartLine line;

  @override
  Widget build(BuildContext context) {
    final product = line.product;
    return Container(
      padding: const EdgeInsets.all(14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(product.image, width: 64, height: 64, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Size: ${line.item.size}', style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text('Qty: ${line.item.quantity}', style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(
            '${String.fromCharCode(36)}${product.price.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.orange),
          ),
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.localization,
  });

  final double subtotal;
  final double discount;
  final double total;
  final AppLocalizations localization;

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
          _TotalRow(label: localization.translate('subtotal'), value: subtotal),
          const SizedBox(height: 8),
          _TotalRow(label: localization.translate('discount'), value: discount),
          const Divider(height: 24),
          _TotalRow(label: localization.translate('total'), value: total, highlight: true),
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

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.controller,
    required this.label,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundAlt,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
