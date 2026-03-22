import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/home/data/repositories/restaurant_repository.dart';
import 'package:cliceat_app/features/client/home/data/models/restaurant_model.dart';
import '../../../../../core/services/analytics_service.dart';

class SearchResultsPage extends StatefulWidget {
  final String initialQuery;

  const SearchResultsPage({super.key, required this.initialQuery});

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
    if (query.trim().isEmpty) return [];
    final result =
        await getIt<RestaurantRepository>().search(query.trim());
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: _onSearchSubmitted,
          decoration: InputDecoration(
            hintText: 'client.search_hint'.tr(),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                setState(() {
                  _resultsFuture = Future.value([]);
                });
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<RestaurantModel>>(
        future: _resultsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final results = snapshot.data ?? [];

          if (results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  Text(
                    'common.no_results'.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: results.length,
            itemBuilder: (context, i) =>
                _RestaurantSearchCard(restaurant: results[i]),
          );
        },
      ),
    );
  }
}

class _RestaurantSearchCard extends StatelessWidget {
  final RestaurantModel restaurant;

  const _RestaurantSearchCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        getIt<AnalyticsService>()
            .logRestaurantViewed(restaurant.id, restaurant.name);
        context.push('/restaurant/${restaurant.id}');
      },
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      errorBuilder: (_, _, _) =>
                          _placeholder(theme),
                    )
                  : _placeholder(theme),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (restaurant.cuisineType != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      restaurant.cuisineType!,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star,
                          size: 14,
                          color: theme.colorScheme.secondary),
                      const SizedBox(width: 2),
                      Text(
                        restaurant.rating?.toStringAsFixed(1) ?? 'N/A',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.access_time,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 2),
                      Text(
                        '${restaurant.deliveryTimeMinutes ?? 30} min',
                        style: theme.textTheme.bodySmall,
                      ),
                      if (restaurant.deliveryFee > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${restaurant.deliveryFee.toStringAsFixed(0)} FCFA',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              restaurant.isOpen
                  ? Icons.chevron_right
                  : Icons.lock_outline,
              color: restaurant.isOpen
                  ? null
                  : theme.colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) => Container(
        width: 72,
        height: 72,
        color: theme.colorScheme.surfaceContainerHighest,
        child: Icon(Icons.restaurant,
            color: theme.colorScheme.onSurfaceVariant),
      );
}
