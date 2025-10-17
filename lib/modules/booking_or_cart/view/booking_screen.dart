import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.isArabic ? 'احجز إقامتك' : 'Book your stay'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.isArabic ? 'الغرفة' : 'Room'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(value: 'standard', child: Text('Standard')),
                  DropdownMenuItem(value: 'deluxe', child: Text('Deluxe')),
                ],
                onChanged: (_) {},
              ),
              const SizedBox(height: 24),
              Text(loc.isArabic ? 'التاريخ' : 'Date'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {},
                child: Text(loc.isArabic ? 'اختر التاريخ' : 'Select dates'),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.lock),
                label: Text(loc.isArabic ? 'احجز الآن' : 'Reserve'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
