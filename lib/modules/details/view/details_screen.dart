import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              leading: IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
              ),
              title: Text(loc.isArabic ? 'تفاصيل الحجز' : 'Booking details'),
              expandedHeight: 240,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  'https://images.unsplash.com/photo-1525609004556-c46c7d6cf023',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loc.isArabic ? 'سيارة سيدان كهربائية' : 'Electric Sedan Deluxe',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      children: const [
                        Chip(label: Text('Wi-Fi 100 Mbps')),
                        Chip(label: Text('Self Check-in')),
                        Chip(label: Text('Pet Friendly')),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(loc.isArabic ? 'المواصفات' : 'Specifications',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(loc.isArabic
                        ? '4 مقاعد · أوتوماتيك · كهرباء بالكامل'
                        : '4 seats · Automatic · Full electric'),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () {},
                      child: Text(loc.isArabic ? 'تابع' : 'Continue'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
