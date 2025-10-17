import 'package:flutter/material.dart';

import '../../../domain/models/listing.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({super.key, required this.listing, required this.locale});

  final Listing listing;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = listing.titleForLocale(locale.languageCode);
    final description = listing.descriptionForLocale(locale.languageCode);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: listing.images.isEmpty
                    ? _buildFallback(theme)
                    : _buildImage(listing.images.first, theme),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.star, color: theme.colorScheme.secondary),
                        const SizedBox(width: 4),
                        Text(listing.rating.toStringAsFixed(1)),
                        const Spacer(),
                        Text('${listing.price.toStringAsFixed(0)} USD / day'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.75),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(listing.tags.join(' · ')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String source, ThemeData theme) {
    if (source.startsWith('gradient:')) {
      return _GradientPlaceholder(
        token: source.substring('gradient:'.length),
        theme: theme,
      );
    }
    if (source.startsWith('http')) {
      return Image.network(source, fit: BoxFit.cover);
    }
    return Image.asset(source, fit: BoxFit.cover);
  }

  Widget _buildFallback(ThemeData theme) {
    return _GradientPlaceholder(token: 'fallback', theme: theme);
  }
}

class _GradientPlaceholder extends StatelessWidget {
  const _GradientPlaceholder({required this.token, required this.theme});

  final String token;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final gradient = _resolveGradient(token, theme);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: Center(
        child: Icon(
          Icons.directions_car,
          color: theme.colorScheme.onPrimary.withOpacity(0.8),
          size: 48,
        ),
      ),
    );
  }

  LinearGradient _resolveGradient(String key, ThemeData theme) {
    switch (key) {
      case 'sunrise':
        return const LinearGradient(
          colors: [Color(0xFFA3C2BF), Color(0xFFD5A469)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'seabreeze':
        return const LinearGradient(
          colors: [Color(0xFF5C8690), Color(0xFF22C55E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.35),
            theme.colorScheme.secondary.withOpacity(0.45),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}
