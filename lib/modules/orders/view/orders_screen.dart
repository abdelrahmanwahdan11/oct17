import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        appBar: AppBar(title: Text(loc.isArabic ? 'الرحلات' : 'Trips')),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(loc.isArabic ? 'رحلة #${index + 1}' : 'Trip #${index + 1}'),
                subtitle: Text(loc.isArabic ? 'مدى: 20-22 يناير' : 'Range: Jan 20-22'),
                trailing: FilledButton(
                  onPressed: () {},
                  child: Text(loc.isArabic ? 'عرض' : 'View'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
