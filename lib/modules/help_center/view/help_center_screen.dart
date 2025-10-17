import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    final faqs = [
      (loc.isArabic ? 'كيف أغير اللغة؟' : 'How to change language?',
          loc.isArabic ? 'اذهب إلى الإعدادات واختر اللغة.' : 'Go to settings and pick language.'),
      (loc.isArabic ? 'كيفية الدفع؟' : 'How to pay?',
          loc.isArabic ? 'اختر وسيلة الدفع في صفحة السداد.' : 'Select payment method in checkout.'),
    ];
    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        appBar: AppBar(title: Text(loc.isArabic ? 'مركز المساعدة' : 'Help center')),
        body: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return ExpansionTile(
              title: Text(faq.item1),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(faq.item2),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
