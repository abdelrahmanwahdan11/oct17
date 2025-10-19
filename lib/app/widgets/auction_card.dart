import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/orriso_theme.dart';
import '../../domain/models/auction.dart';

class AuctionCard extends StatelessWidget {
  const AuctionCard({
    super.key,
    required this.auction,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
    this.showSelection = false,
  });

  final Auction auction;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;
  final bool showSelection;

  @override
  Widget build(BuildContext context) {
    final selected = showSelection && isFavorite;
    return GlassSurface(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: 'auction_${auction.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(auction.media.first),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (selected)
                      Container(
                        color: Colors.black.withOpacity(0.2),
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 16,
                              child: Icon(Icons.check, color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: InkWell(
                        onTap: onFavorite,
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.68),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? Theme.of(context).colorScheme.primary
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auction.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  auction.category,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.65)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white.withOpacity(0.7),
                      child: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auction.currentBid.toStringAsFixed(0) + ' USD',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          auction.endAt.difference(DateTime.now()).inHours < 6
                              ? MaterialLocalizations.of(context).formatTimeOfDay(
                                  TimeOfDay.fromDateTime(auction.endAt),
                                )
                              : '${auction.endAt.difference(DateTime.now()).inHours}h',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
