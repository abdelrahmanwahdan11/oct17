import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/orriso_theme.dart';
import '../../../core/utils/app_scope.dart';
import '../../../core/utils/debouncer.dart';
import '../../../domain/models/auction.dart';
import '../../widgets/app_background.dart';
import '../../widgets/auction_card.dart';
import '../../widgets/glass_widgets.dart';

class AuctionListScreen extends StatefulWidget {
  const AuctionListScreen({super.key});

  @override
  State<AuctionListScreen> createState() => _AuctionListScreenState();
}

class _AuctionListScreenState extends State<AuctionListScreen> {
  late final ScrollController _scrollController;
  late final Debouncer _debouncer;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 350));
    final deps = AppScope.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      deps.auctionsController.loadInitial();
    });
    _scrollController.addListener(() {
      final controller = deps.auctionsController;
      if (_scrollController.position.extentAfter < 260 && controller.hasMore && !controller.isLoading) {
        controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deps = AppScope.of(context);
    final controller = deps.auctionsController;
    final favorites = deps.favoritesController;
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: OrrisoBackground(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([controller, favorites]),
            builder: (context, _) {
              final auctions = controller.auctions;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_ios_new),
                        ),
                        Text(strings.t('auctions.list'), style: Theme.of(context).textTheme.headlineSmall),
                        const Spacer(),
                        GlassPill(
                          active: controller.sortKey == 'soon',
                          onTap: () => controller.updateSort('soon'),
                          child: Text(strings.t('auctions.sortSoon')),
                        ),
                        const SizedBox(width: 8),
                        GlassPill(
                          active: controller.sortKey == 'recent',
                          onTap: () => controller.updateSort('recent'),
                          child: Text(strings.t('auctions.sortRecent')),
                        ),
                        const SizedBox(width: 8),
                        GlassPill(
                          active: controller.sortKey == 'bids',
                          onTap: () => controller.updateSort('bids'),
                          child: Text(strings.t('auctions.sortBids')),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GlassSurface(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => _debouncer(() => controller.updateSearch(value)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: const Icon(Icons.search),
                          hintText: strings.t('home.searchHint'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: controller.refresh,
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: auctions.length,
                        itemBuilder: (context, index) {
                          final auction = auctions[index];
                          return AuctionCard(
                            auction: auction,
                            isFavorite: favorites.isFavorite('auction_${auction.id}'),
                            onFavorite: () => favorites.toggleFavorite('auction_${auction.id}'),
                            onTap: () => Navigator.of(context).pushNamed(
                              AppRoutes.auctionsDetails,
                              arguments: {'id': auction.id},
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (controller.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
