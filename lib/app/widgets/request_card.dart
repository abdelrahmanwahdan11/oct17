import 'package:flutter/material.dart';

import '../../core/theme/orriso_theme.dart';
import '../../domain/models/buy_request.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.request,
    required this.onTap,
    required this.onFollow,
    required this.isFollowing,
  });

  final BuyRequest request;
  final VoidCallback onTap;
  final VoidCallback onFollow;
  final bool isFollowing;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                onPressed: onFollow,
                icon: Icon(
                  isFollowing ? Icons.bookmark : Icons.bookmark_border,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${request.budget.toStringAsFixed(0)} USD / ${request.qty} pcs',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            request.specs,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Chip(
                label: Text(request.priority),
                backgroundColor: Colors.white.withOpacity(0.6),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text(request.location),
                backgroundColor: Colors.white.withOpacity(0.6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
