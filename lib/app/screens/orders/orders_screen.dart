import 'package:flutter/material.dart';

import '../../controllers/orders_controller.dart';
import '../../localization/app_localizations.dart';
import '../../models/order.dart';
import '../../navigation/app_scope.dart';
import '../../theme/app_colors.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context).orders;
    final localization = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final orders = controller.orders;
        return Scaffold(
          appBar: AppBar(title: Text(localization.translate('orders_title'))),
          body: orders.isEmpty
              ? _EmptyOrders(localization: localization)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemBuilder: (context, index) => _OrderCard(
                    order: orders[index],
                    localization: localization,
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: orders.length,
                ),
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.localization});

  final OrderDetail order;
  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    final date = order.createdAt.toLocal();
    final formattedDate = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final statusLabel = _statusLabel(order.status, localization);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.translate('order_id_label').replaceFirst('{id}', order.id),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${localization.translate('placed_on')} $formattedDate',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
              _StatusBadge(label: statusLabel),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              for (int i = 0; i < order.lines.length && i < 3; i++) ...[
                _OrderLinePreview(line: order.lines[i]),
                if (i < order.lines.length - 1 && i < 2) const SizedBox(height: 8),
              ],
              if (order.lines.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    localization.translate('order_more_items').replaceFirst('{count}', '${order.lines.length - 3}'),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localization.translate('total'), style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                '${String.fromCharCode(36)}${order.total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(String status, AppLocalizations localization) {
    switch (status) {
      case 'completed':
        return localization.translate('order_status_completed');
      default:
        return localization.translate('order_status_processing');
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.orangeSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _OrderLinePreview extends StatelessWidget {
  const _OrderLinePreview({required this.line});

  final OrderLine line;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(line.image, width: 52, height: 52, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(line.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(
                'Size: ${line.size}  |  Qty: ${line.quantity}',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders({required this.localization});

  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long_outlined, size: 72, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            localization.translate('orders_empty_title'),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              localization.translate('orders_empty_subtitle'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
