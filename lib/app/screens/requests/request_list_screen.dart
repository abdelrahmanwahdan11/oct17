import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/app_scope.dart';
import '../../../core/utils/debouncer.dart';
import '../../widgets/app_background.dart';
import '../../widgets/glass_widgets.dart';
import '../../widgets/request_card.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
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
      deps.requestsController.loadInitial();
    });
    _scrollController.addListener(() {
      final controller = deps.requestsController;
      if (_scrollController.position.extentAfter < 240 && controller.hasMore && !controller.isLoading) {
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
    final controller = deps.requestsController;
    final favorites = deps.favoritesController;
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: OrrisoBackground(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([controller, favorites]),
            builder: (context, _) {
              final requests = controller.requests;
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
                        Text(strings.t('requests.list'), style: Theme.of(context).textTheme.headlineSmall),
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
                          hintText: strings.t('requests.searchHint'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: controller.refresh,
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          final request = requests[index];
                          final id = 'request_${request.id}';
                          return RequestCard(
                            request: request,
                            onTap: () {},
                            onFollow: () => favorites.toggleFavorite(id),
                            isFollowing: favorites.isFavorite(id),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
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
