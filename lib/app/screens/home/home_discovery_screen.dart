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

class HomeDiscoveryScreen extends StatefulWidget {
  const HomeDiscoveryScreen({super.key});

  @override
  State<HomeDiscoveryScreen> createState() => _HomeDiscoveryScreenState();
}

class _HomeDiscoveryScreenState extends State<HomeDiscoveryScreen> {
  late final ScrollController _scrollController;
  late final Debouncer _searchDebouncer;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 350));
    final deps = AppScope.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      deps.auctionsController.loadInitial();
    });
    _scrollController.addListener(() {
      final controller = deps.auctionsController;
      if (_scrollController.position.extentAfter < 300 && controller.hasMore && !controller.isLoading) {
        controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deps = AppScope.of(context);
    final auctionsController = deps.auctionsController;
    final favoritesController = deps.favoritesController;
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: OrrisoBackground(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([auctionsController, favoritesController]),
            builder: (context, _) {
              final auctions = auctionsController.auctions;
              final combined = <Object>[];
              for (var i = 0; i < auctions.length; i++) {
                combined.add(auctions[i]);
                if ((i + 1) % 5 == 0) {
                  combined.add('tile');
                }
              }
              if (auctions.isEmpty && !auctionsController.isLoading) {
                combined.add('empty');
              }
              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: auctionsController.refresh,
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      strings.t('app.name'),
                                      style: Theme.of(context).textTheme.headlineLarge,
                                    ),
                                    const Spacer(),
                                    GlassIconButton(
                                      icon: Icons.settings,
                                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
                                    ),
                                    const SizedBox(width: 12),
                                    GlassIconButton(
                                      icon: Icons.brightness_5,
                                      onTap: () => deps.themeController.toggle(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                GlassSurface(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (value) => _searchDebouncer(() {
                                      auctionsController.updateSearch(value);
                                    }),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: const Icon(Icons.search),
                                      hintText: strings.t('home.searchHint'),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 48,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      const SizedBox(width: 4),
                                      GlassPill(
                                        active: auctionsController.sortKey == 'soon',
                                        onTap: () => auctionsController.updateSort('soon'),
                                        child: Text(strings.t('home.chipSoon')),
                                      ),
                                      const SizedBox(width: 12),
                                      GlassPill(
                                        active: auctionsController.sortKey == 'recent',
                                        onTap: () => auctionsController.updateSort('recent'),
                                        child: Text(strings.t('home.chipRecent')),
                                      ),
                                      const SizedBox(width: 12),
                                      GlassPill(
                                        active: auctionsController.sortKey == 'bids',
                                        onTap: () => auctionsController.updateSort('bids'),
                                        child: Text(strings.t('home.chipBids')),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = combined[index];
                                if (item == 'tile') {
                                  return ListYourItemTile(
                                    label: strings.t('home.listYourItem'),
                                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.auctionsCreate),
                                  );
                                }
                                if (item == 'empty') {
                                  return GlassSurface(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(strings.t('home.empty'), textAlign: TextAlign.center),
                                        const SizedBox(height: 12),
                                        OutlinedButton(
                                          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.auctionsCreate),
                                          child: Text(strings.t('home.emptyCta')),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                final auction = item as Auction;
                                return AuctionCard(
                                  auction: auction,
                                  isFavorite: favoritesController.isFavorite('auction_${auction.id}'),
                                  showSelection: true,
                                  onFavorite: () => favoritesController.toggleFavorite('auction_${auction.id}'),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      AppRoutes.auctionsDetails,
                                      arguments: {'id': auction.id},
                                    );
                                  },
                                );
                              },
                              childCount: combined.length,
                            ),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.72,
                            ),
                          ),
                        ),
                        if (auctionsController.isLoading)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                        const SliverToBoxAdapter(child: SizedBox(height: 120)),
                      ],
                    ),
                  ),
                  GlassBottomDock(
                    icons: const [Icons.people_alt, Icons.grid_view, Icons.auto_awesome, Icons.notifications],
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
