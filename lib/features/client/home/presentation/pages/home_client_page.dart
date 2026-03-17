import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:chopper/chopper.dart';
import '../../../../../core/config/app_constants.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/services/coupon_service.dart';
import '../../data/datasources/restaurant_service.dart';

class HomeClientPage extends StatefulWidget {
  const HomeClientPage({super.key});

  @override
  State<HomeClientPage> createState() => _HomeClientPageState();
}

class _HomeClientPageState extends State<HomeClientPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  Timer? _debounce;

  // Dynamic categories (emoji, label) loaded from API
  static const _fallbackCategories = [
    ('🍔', 'Burger'),
    ('🍕', 'Pizza'),
    ('🥗', 'Ndolé'),
    ('🍗', 'Poulet'),
    ('🥙', 'Salade'),
  ];

  List<(String, String)> _categories = _fallbackCategories;
  bool _categoriesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadDynamicCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// Loads cuisine categories from the featured restaurant list.
  /// Falls back to static categories if API fails.
  Future<void> _loadDynamicCategories() async {
    if (_categoriesLoaded) return;
    try {
      final res = await getIt<RestaurantService>().getFeaturedRestaurants();
      if (!res.isSuccessful || res.body == null) return;

      final body = res.body;
      List<dynamic> restaurants = [];
      if (body is Map && body.containsKey('data')) {
        restaurants = body['data'] as List<dynamic>? ?? [];
      } else if (body is List) {
        restaurants = body;
      }

      // Extract unique cuisine types and map them to emojis
      final cuisineSet = <String>{};
      for (final r in restaurants) {
        final cuisine = (r as Map<String, dynamic>)['cuisineType'] as String?;
        if (cuisine != null && cuisine.trim().isNotEmpty) {
          cuisineSet.add(cuisine.trim());
        }
      }

      if (cuisineSet.isEmpty) return;

      const emojiMap = {
        'burger': '🍔', 'pizza': '🍕', 'poulet': '🍗', 'chicken': '🍗',
        'salade': '🥗', 'salad': '🥗', 'ndolé': '🥘', 'ndole': '🥘',
        'poisson': '🐟', 'fish': '🐟', 'sushi': '🍱', 'tacos': '🌮',
        'sandwich': '🥙', 'pasta': '🍝', 'dessert': '🍰', 'jus': '🥤',
        'rice': '🍚', 'riz': '🍚', 'viande': '🥩', 'meat': '🥩',
      };

      final dynamic = cuisineSet.take(8).map((c) {
        final key = c.toLowerCase();
        final emoji = emojiMap.entries
            .firstWhere(
              (e) => key.contains(e.key),
              orElse: () => const MapEntry('', '🍽️'),
            )
            .value;
        return (emoji, c);
      }).toList();

      if (mounted) {
        setState(() {
          _categories = dynamic;
          _categoriesLoaded = true;
        });
      }
    } catch (_) {
      // Keep fallback categories
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _searchQuery = value.trim());
    });
  }

  void _onCategoryTap(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = null;
        _searchQuery = '';
        _searchController.clear();
      } else {
        _selectedCategory = category;
        _searchQuery = category;
        _searchController.text = category;
      }
    });
  }

  bool get _isSearching => _searchQuery.isNotEmpty;

  Future<Response> _fetchRestaurants() {
    if (_isSearching) {
      return getIt<RestaurantService>().searchRestaurants(_searchQuery);
    }
    return getIt<RestaurantService>().getFeaturedRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'client.deliver_to'.tr(),
              style: theme.textTheme.bodySmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppConstants.defaultCity,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 20),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: RefreshIndicator(
        color: theme.colorScheme.primary,
        onRefresh: () async {
          setState(() {
            _categoriesLoaded = false;
          });
          await _loadDynamicCategories();
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchBar(context),
              if (!_isSearching) _buildPromotionsCarousel(context),
              _buildCategories(context),
              _buildRestaurantList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'client.search_hint'.tr(),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _selectedCategory = null;
                    });
                  },
                )
              : const Icon(Icons.tune),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).cardTheme.color,
        ),
      ),
    );
  }

  Widget _buildPromotionsCarousel(BuildContext context) {
    return FutureBuilder<Response<Map<String, dynamic>>>(
      future: getIt<CouponService>().getBanners(),
      builder: (context, snapshot) {
        List<Map<String, dynamic>> banners = [];
        if (snapshot.hasData &&
            snapshot.data!.isSuccessful &&
            snapshot.data!.body != null) {
          final data = snapshot.data!.body!['data'];
          if (data is List) {
            banners = data.map((e) => e as Map<String, dynamic>).toList();
          }
        }
        if (banners.isEmpty) {
          banners = [
            {
              'title': 'Livraison Gratuite',
              'subtitle': 'Sur votre 1ère commande',
              'image':
                  'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1000&auto=format&fit=crop',
            }
          ];
        }
        return Container(
          height: 160,
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: PageView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              final imageUrl = banner['imageUrl'] as String? ??
                  banner['image'] as String? ??
                  'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1000&auto=format&fit=crop';
              final title = banner['title'] as String? ?? '';
              final subtitle = banner['subtitle'] as String? ??
                  banner['description'] as String? ?? '';
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.2),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (title.isNotEmpty)
                          Text(title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        if (subtitle.isNotEmpty)
                          Text(subtitle,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategories(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'client.categories'.tr(),
            style: theme.textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final (emoji, label) = _categories[index];
              final isSelected = _selectedCategory == label;
              return GestureDetector(
                onTap: () => _onCategoryTap(label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.cardTheme.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor
                                  .withValues(alpha: 0.08),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(emoji,
                              style: const TextStyle(fontSize: 26)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : null,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantList(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isSearching
                    ? 'client.search_results'.tr()
                    : 'client.recommended'.tr(),
                style: theme.textTheme.titleLarge,
              ),
              if (!_isSearching)
                Text(
                  'client.see_all'.tr(),
                  style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
        FutureBuilder<Response>(
          key: ValueKey('$_searchQuery'),
          future: _fetchRestaurants(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data?.body == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Text('common.error'.tr(),
                          style:
                              TextStyle(color: theme.colorScheme.error)),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => setState(() {}),
                        icon: const Icon(Icons.refresh),
                        label: Text('common.retry'.tr()),
                      ),
                    ],
                  ),
                ),
              );
            }

            final responseBody = snapshot.data!.body;
            List<dynamic> restaurants = [];
            if (responseBody is Map &&
                responseBody.containsKey('data')) {
              restaurants =
                  responseBody['data'] as List<dynamic>;
            } else if (responseBody is List) {
              restaurants = responseBody;
            }

            if (restaurants.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(Icons.search_off,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.4)),
                      const SizedBox(height: 12),
                      Text(
                        _isSearching
                            ? 'common.no_results'.tr()
                            : 'restaurant.none_available'.tr(),
                        style: TextStyle(
                            color:
                                theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                final id = restaurant['_id']?.toString() ??
                    restaurant['id']?.toString() ??
                    (index + 1).toString();
                final name =
                    restaurant['name'] ?? 'Restaurant Gourmet';
                final cuisine =
                    restaurant['cuisineType'] ?? 'Cuisine Locale';
                final rating =
                    restaurant['rating']?.toString() ?? 'N/A';
                final minTime =
                    restaurant['deliveryTimeMinutes']?.toString() ??
                        '30';
                final deliveryFee =
                    (restaurant['deliveryFee'] as num?)
                        ?.toStringAsFixed(0);
                final image = restaurant['coverImage'] ??
                    'https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=1000&auto=format&fit=crop';

                return GestureDetector(
                  onTap: () => context.push('/restaurant/$id'),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style:
                                          theme.textTheme.titleLarge,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2),
                                    decoration: BoxDecoration(
                                      color: theme
                                          .colorScheme.secondary,
                                      borderRadius:
                                          BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.star,
                                            size: 14,
                                            color: theme.colorScheme
                                                .onSecondary),
                                        const SizedBox(width: 4),
                                        Text(rating,
                                            style: theme
                                                .textTheme.labelLarge),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(cuisine,
                                  style: theme.textTheme.bodySmall),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.delivery_dining,
                                      size: 16,
                                      color: theme.colorScheme
                                          .onSurfaceVariant),
                                  const SizedBox(width: 4),
                                  Text(
                                    deliveryFee != null
                                        ? '$deliveryFee FCFA'
                                        : 'restaurant.variable_fee'.tr(),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(Icons.timer,
                                      size: 16,
                                      color: theme.colorScheme
                                          .onSurfaceVariant),
                                  const SizedBox(width: 4),
                                  Text('$minTime min',
                                      style: theme.textTheme.bodySmall),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
