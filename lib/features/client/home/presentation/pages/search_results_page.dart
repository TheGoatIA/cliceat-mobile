import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/home/data/repositories/restaurant_repository.dart';
import 'package:cliceat_app/features/client/home/data/models/restaurant_model.dart';
import '../../../../../core/services/analytics_service.dart';
import '../../../../../core/theme/app_theme.dart';

class SearchResultsPage extends StatefulWidget {
  final String initialQuery;
  final String city;

  const SearchResultsPage({
    super.key,
    required this.initialQuery,
    this.city = 'Douala',
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late final TextEditingController _controller;
  late Future<List<RestaurantModel>> _resultsFuture;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _resultsFuture = _search(widget.initialQuery);
    if (widget.initialQuery.isNotEmpty) {
      getIt<AnalyticsService>().logSearchPerformed(widget.initialQuery);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<RestaurantModel>> _search(String query) async {
    if (query.trim().isEmpty) {
      final result = await getIt<RestaurantRepository>().getRestaurants(
        city: widget.city,
        limit: 1000,
      );
      return result.fold((_) => [], (list) => list);
    }
    final result = await getIt<RestaurantRepository>().search(query.trim());
    return result.fold((_) => [], (list) => list);
  }

  void _onSearchSubmitted(String value) {
    if (value.trim().isEmpty) return;
    getIt<AnalyticsService>().logSearchPerformed(value.trim());
    setState(() {
      _resultsFuture = _search(value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.lineSoft),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppTheme.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.lineSoft),
                        boxShadow: AppTheme.shadowSm,
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.search_rounded,
                                color: AppTheme.muted, size: 20),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              textInputAction: TextInputAction.search,
                              onSubmitted: _onSearchSubmitted,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: AppTheme.ink,
                              ),
                              decoration: InputDecoration(
                                hintText: 'client.search_hint'.tr(),
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: AppTheme.mutedLight,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: AppTheme.muted, size: 18),
                            onPressed: () {
                              _controller.clear();
                              setState(() {
                                _resultsFuture = Future.value([]);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<RestaurantModel>>(
                future: _resultsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryRed,
                        strokeWidth: 2,
                      ),
                    );
                  }

                  final results = snapshot.data ?? [];

                  if (results.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppTheme.bgWarm,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Icon(Icons.search_off_rounded,
                                size: 36, color: AppTheme.muted),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'common.no_results'.tr(),
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.ink,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Essaie un autre mot-clé',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: results.length,
                    itemBuilder: (context, i) =>
                        _RestaurantSearchCard(restaurant: results[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestaurantSearchCard extends StatelessWidget {
  final RestaurantModel restaurant;

  const _RestaurantSearchCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getIt<AnalyticsService>()
            .logRestaurantViewed(restaurant.id, restaurant.name);
        context.push('/restaurant/${restaurant.id}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.lineSoft),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: restaurant.coverImage != null
                  ? Image.network(
                      restaurant.coverImage!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.ink,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (restaurant.cuisineType != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      restaurant.cuisineType!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 13, color: AppTheme.honey),
                      const SizedBox(width: 3),
                      Text(
                        restaurant.rating?.toStringAsFixed(1) ?? 'N/A',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.ink,
                        ),
                      ),
                      Container(
                        width: 3,
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: const BoxDecoration(
                          color: AppTheme.mutedLight,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Icon(Icons.access_time_rounded,
                          size: 13, color: AppTheme.muted),
                      const SizedBox(width: 3),
                      Text(
                        '${restaurant.deliveryTimeMinutes ?? 30} min',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.muted,
                        ),
                      ),
                      if (restaurant.deliveryFee > 0) ...[
                        Container(
                          width: 3,
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: const BoxDecoration(
                            color: AppTheme.mutedLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          '${restaurant.deliveryFee.toStringAsFixed(0)} FCFA',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (!restaurant.isOpen)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.redSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Fermé',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryRed,
                  ),
                ),
              )
            else
              const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.mutedLight, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: AppTheme.bgWarm,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.restaurant_rounded, color: AppTheme.muted),
      );
}
