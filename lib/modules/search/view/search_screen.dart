import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';
import '../../../domain/models/listing.dart';
import '../../../data/seed/seed_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final SeedListingRepository _repository = SeedListingRepository('assets/seed/listings.json');
  List<Listing> _results = const [];

  @override
  void initState() {
    super.initState();
    _performSearch('');
  }

  Future<void> _performSearch(String query) async {
    final all = await _repository.refresh();
    setState(() {
      _results = all
          .where((listing) =>
              query.isEmpty || listing.titleEn.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.isArabic ? 'استكشاف' : 'Explore'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: loc.t('common.search'),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  if (value.length >= 2 || value.isEmpty) {
                    _performSearch(value);
                  }
                },
              ),
            ),
            SizedBox(
              height: 180,
              child: PageView(
                children: [
                  _FilterCard(title: loc.isArabic ? 'السعر' : 'Price Range'),
                  _FilterCard(title: loc.isArabic ? 'التصنيف' : 'Rating'),
                  _FilterCard(title: loc.isArabic ? 'المسافة' : 'Distance'),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final item = _results[index];
                  return ListTile(
                    leading: const Icon(Icons.directions_car),
                    title: Text(item.titleForLocale(loc.locale.languageCode)),
                    subtitle: Text('${item.rating} ★'),
                    trailing: Text(item.price.toStringAsFixed(0)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        child: Center(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
      ),
    );
  }
}
