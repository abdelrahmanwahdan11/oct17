import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/orriso_theme.dart';
import '../../../core/utils/app_scope.dart';
import '../../../domain/models/auction.dart';
import '../../widgets/app_background.dart';
import '../../widgets/countdown_timer.dart';
import '../../widgets/glass_widgets.dart';

class AuctionDetailsScreen extends StatefulWidget {
  const AuctionDetailsScreen({super.key, required this.auctionId});

  final String auctionId;

  @override
  State<AuctionDetailsScreen> createState() => _AuctionDetailsScreenState();
}

class _AuctionDetailsScreenState extends State<AuctionDetailsScreen> {
  Auction? _auction;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final deps = AppScope.of(context);
    deps.auctionsController.getById(widget.auctionId).then((value) {
      setState(() {
        _auction = value;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: OrrisoBackground(
        child: SafeArea(
          child: _loading || _auction == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back_ios_new),
                          ),
                          Text(strings.t('auctions.details')),
                          const Spacer(),
                          GlassIconButton(
                            icon: Icons.share,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Hero(
                            tag: 'auction_${_auction!.id}',
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: PageView(
                                children: _auction!.media
                                    .map(
                                      (image) => Image.asset(
                                        image,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _auction!.title,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    Chip(label: Text(_auction!.category)),
                                    Chip(label: Text(_auction!.condition)),
                                    Chip(label: Text(_auction!.location)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                CountdownTimer(
                                  endAt: _auction!.endAt,
                                  onCompleted: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(strings.t('auctions.auctionEnded'))),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                GlassSurface(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(strings.t('auctions.currentBid')),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_auction!.currentBid.toStringAsFixed(0)} USD',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${strings.t('auctions.minIncrement')}: ${_auction!.minIncrement.toStringAsFixed(0)}',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(_auction!.desc, style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.auctionsPlaceBid,
                                  arguments: {'id': _auction!.id},
                                );
                              },
                              child: Text(strings.t('auctions.placeBid')),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.auctionsPlaceBid,
                                  arguments: {'id': _auction!.id, 'mode': 'auto'},
                                );
                              },
                              child: Text(strings.t('auctions.autoBid')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
