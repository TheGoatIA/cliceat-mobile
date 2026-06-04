import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/features/client/home/data/models/restaurant_model.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/data/local/daos/favorites_dao.dart';
import 'package:cliceat_app/features/client/home/data/repositories/restaurant_repository.dart';
import '../../core/theme/app_theme.dart';
import 'app_network_image.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final bool compact;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/restaurant/${restaurant.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.lineSoft),
          boxShadow: AppTheme.shadowSm,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Cover ──────────────────────────────────────────────────────
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: compact ? 16 / 8 : 16 / 9,
                  child: AppNetworkImage(
                    url: restaurant.coverImage,
                    width: double.infinity,
                    fallbackAsset: 'assets/images/restaurant_placeholder.jpg',
                  ),
                ),
                // Dark gradient bottom
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.5, 1.0],
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.45)],
                      ),
                    ),
                  ),
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
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            'restaurant.closed'.tr(),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                // Rating badge bottom-left
                if (restaurant.rating != null)
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: _RatingBadge(rating: restaurant.rating!),
                  ),
                // Heart button top-right
                Positioned(
                  top: 10,
                  right: 10,
                  child: StreamBuilder<Set<String>>(
                    stream: getIt<FavoritesDao>().watchFavoriteIds(),
                    builder: (context, snapshot) {
                      final favorites = snapshot.data ?? {};
                      final isFav = favorites.contains(restaurant.id);
                      return GestureDetector(
                        onTap: () async {
                          HapticFeedback.mediumImpact();
                          try {
                            if (!isFav) {
                              await getIt<FavoritesDao>().addFavorite(restaurant.id);
                            } else {
                              await getIt<FavoritesDao>().removeFavorite(restaurant.id);
                            }
                          } catch (_) {}
                          
                          final result = await getIt<RestaurantRepository>().toggleFavorite(restaurant.id);
                          result.fold(
                            (err) async {
                              // Rollback
                              try {
                                if (!isFav) {
                                  await getIt<FavoritesDao>().removeFavorite(restaurant.id);
                                } else {
                                  await getIt<FavoritesDao>().addFavorite(restaurant.id);
                                }
                              } catch (_) {}
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(err.message.tr())),
                                );
                              }
                            },
                            (_) {},
                          );
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isFav ? AppTheme.primaryRed.withValues(alpha: 0.2) : AppTheme.lineSoft,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 16,
                            color: isFav ? AppTheme.primaryRed : AppTheme.ink,
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),

            // ── Info ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.ink,
                      letterSpacing: -0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    [
                      if ((restaurant.cuisineType ?? '').isNotEmpty) restaurant.cuisineType!,
                      if (restaurant.cuisines.isNotEmpty) restaurant.cuisines.take(2).join(' · '),
                    ].where((s) => s.isNotEmpty).join(' · '),
                    style: GoogleFonts.inter(fontSize: 12, color: AppTheme.muted),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 10, color: AppTheme.honey),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 11,
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
    final items = <Widget>[];

    void addItem(IconData icon, String label) {
      if (items.isNotEmpty) {
        items.add(Container(
          width: 3,
          height: 3,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppTheme.mutedLight,
            borderRadius: BorderRadius.circular(2),
          ),
        ));
      }
      items.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppTheme.muted),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.inkSoft, fontWeight: FontWeight.w500),
          ),
        ],
      ));
    }

    if (restaurant.deliveryTimeMinutes != null) {
      addItem(Icons.access_time_rounded, '${restaurant.deliveryTimeMinutes} min');
    }
    addItem(
      Icons.delivery_dining_rounded,
      restaurant.deliveryFee > 0
          ? '${restaurant.deliveryFee.toStringAsFixed(0)} FCFA'
          : 'restaurant.variable_fee'.tr(),
    );

    return Row(children: items);
  }
}
