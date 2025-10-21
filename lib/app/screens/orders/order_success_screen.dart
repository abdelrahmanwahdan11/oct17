import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../../theme/app_colors.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final subtitleTemplate = localization.translate('order_success_subtitle');
    final subtitle = orderId == null
        ? subtitleTemplate.replaceFirst('{id}', '#')
        : subtitleTemplate.replaceFirst('{id}', orderId!);

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.orangeSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, size: 52, color: AppColors.orange),
            ),
            const SizedBox(height: 24),
            Text(
              localization.translate('order_success_title'),
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    'orders',
                    ModalRoute.withName('home'),
                  );
                },
                child: Text(localization.translate('view_orders')),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange),
                child: Text(localization.translate('continue_shopping')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
