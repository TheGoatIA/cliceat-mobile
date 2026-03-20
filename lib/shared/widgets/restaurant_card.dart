import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cliceat_app/features/client/home/data/models/restaurant_model.dart';
import 'app_network_image.dart';

/// Reusable card that displays a [RestaurantModel].
/// Used in home page, search results, and anywhere restaurants are listed.
class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;

  /// When [compact] is true the cover image is shorter and info is condensed.
  final bool compact;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coverHeight = compact ? 110.0 : 160.0;

    return GestureDetector(
      onTap: () => context.push('/restaurant/${restaurant.id}'),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Cover Image ────────────────────────────────────────────────
            Stack(
              children: [
                AppNetworkImage(
                  url: restaurant.coverImage,
                  height: coverHeight,
                  width: double.infinity,
                  fallbackAsset: 'assets/images/restaurant_placeholder.jpg',
                ),
                if (!restaurant.isOpen)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black45,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'restaurant.closed'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // ── Info ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (restaurant.rating != null) _RatingBadge(rating: restaurant.rating!),
                    ],
                  ),
                  if ((restaurant.cuisineType ?? '').isNotEmpty || restaurant.cuisines.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      restaurant.cuisineType ??
                          restaurant.cuisines.take(2).join(' · '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  _MetaRow(restaurant: restaurant),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;
  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 13, color: theme.colorScheme.onSecondary),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final RestaurantModel restaurant;
  const _MetaRow({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.onSurfaceVariant;

    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        _chip(
          icon: Icons.delivery_dining,
          label: restaurant.deliveryFee > 0
              ? '${restaurant.deliveryFee.toStringAsFixed(0)} FCFA'
              : 'restaurant.variable_fee'.tr(),
          iconColor: iconColor,
          theme: theme,
        ),
        if (restaurant.deliveryTimeMinutes != null)
          _chip(
            icon: Icons.timer_outlined,
            label: '${restaurant.deliveryTimeMinutes} min',
            iconColor: iconColor,
            theme: theme,
          ),
        if ((restaurant.minOrder ?? 0) > 0)
          _chip(
            icon: Icons.shopping_bag_outlined,
            label: 'min. ${restaurant.minOrder!.toStringAsFixed(0)} FCFA',
            iconColor: iconColor,
            theme: theme,
          ),
      ],
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    required Color iconColor,
    required ThemeData theme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 3),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
