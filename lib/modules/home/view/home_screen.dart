import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';
import '../viewmodel/home_view_model.dart';
import '../widgets/hero_section.dart';
import '../widgets/listing_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _controller = ScrollController()
      ..addListener(() {
        if (_controller.position.pixels >=
            _controller.position.maxScrollExtent * 0.7) {
          _viewModel.loadMore();
        }
      });
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        final items = _viewModel.filtered(loc).toList();
        return RefreshIndicator(
          onRefresh: _viewModel.refresh,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isGrid = constraints.maxWidth > 900;
              return CustomScrollView(
                controller: _controller,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeroSection(onSearch: _viewModel.updateQuery),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              for (final tag in const ['featured', 'new', 'budget'])
                                FilterChip(
                                  label: Text(tag),
                                  selected: _viewModel.filters.contains(tag),
                                  onSelected: (_) => _viewModel.toggleFilter(tag),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (items.isEmpty && !_viewModel.isLoading)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(loc.isArabic
                            ? 'لا توجد عناصر متاحة الآن.'
                            : 'No items available yet.'),
                      ),
                    )
                  else if (isGrid)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 1.3,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= items.length) {
                              return const SizedBox();
                            }
                            return ListingCard(listing: items[index], locale: loc.locale);
                          },
                          childCount: items.length,
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= items.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListingCard(listing: items[index], locale: loc.locale),
                          );
                        },
                        childCount: items.length,
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: _viewModel.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : FilledButton.icon(
                              onPressed: _viewModel.hasMore ? _viewModel.loadMore : null,
                              icon: const Icon(Icons.refresh),
                              label: Text(loc.isArabic ? 'تحميل المزيد' : 'Load more'),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
