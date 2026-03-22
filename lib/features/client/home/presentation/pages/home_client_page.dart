import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
<<<<<<< HEAD
import '../../../../../core/config/app_constants.dart';
import 'package:cliceat_app/di/injection.dart';
import 'package:cliceat_app/features/client/cart/data/models/coupon_model.dart';
import 'package:cliceat_app/features/client/home/data/models/restaurant_model.dart';
import 'package:cliceat_app/features/client/cart/data/repositories/coupon_repository.dart';
import 'package:cliceat_app/features/client/home/data/repositories/restaurant_repository.dart';
import '../../../../../shared/widgets/banner_carousel.dart';
import '../../../../../shared/widgets/empty_state.dart';
import '../../../../../shared/widgets/restaurant_card.dart';
import '../../../../../shared/widgets/section_header.dart';
=======
import 'package:chopper/chopper.dart';
import '../../../../../core/di/injection.dart';
import '../../data/datasources/restaurant_service.dart';
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa

class HomeClientPage extends StatefulWidget {
  const HomeClientPage({super.key});

  @override
  State<HomeClientPage> createState() => _HomeClientPageState();
}

class _HomeClientPageState extends State<HomeClientPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  String _searchQuery = '';
  String? _selectedCategory;

  // Data
  List<RestaurantModel> _allRestaurants = [];
  List<RestaurantModel> _displayedRestaurants = [];
  List<BannerModel> _banners = [];
  List<(String, String)> _categories = _fallbackCategories;

  bool _loadingRestaurants = true;
  bool _loadingBanners = true;

  static const _fallbackCategories = [
    ('🍔', 'Burger'),
    ('🍕', 'Pizza'),
    ('🥘', 'Ndolé'),
    ('🍗', 'Poulet'),
    ('🥙', 'Salade'),
  ];

  static const _emojiMap = {
    'burger': '🍔',
    'pizza': '🍕',
    'poulet': '🍗',
    'chicken': '🍗',
    'salade': '🥗',
    'salad': '🥗',
    'ndolé': '🥘',
    'ndole': '🥘',
    'poisson': '🐟',
    'fish': '🐟',
    'sushi': '🍱',
    'tacos': '🌮',
    'sandwich': '🥙',
    'pasta': '🍝',
    'dessert': '🍰',
    'jus': '🥤',
    'rice': '🍚',
    'riz': '🍚',
    'viande': '🥩',
    'meat': '🥩',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadRestaurants(), _loadBanners()]);
  }

  Future<void> _loadRestaurants() async {
    setState(() => _loadingRestaurants = true);
    final result = await getIt<RestaurantRepository>().getFeaturedRestaurants();
    if (!mounted) return;
    result.fold((_) => setState(() => _loadingRestaurants = false), (
      restaurants,
    ) {
      final categories = _extractCategories(restaurants);
      setState(() {
        _allRestaurants = restaurants;
        _displayedRestaurants = restaurants;
        _loadingRestaurants = false;
        if (categories.isNotEmpty) _categories = categories;
      });
    });
  }

  Future<void> _loadBanners() async {
    setState(() => _loadingBanners = true);
    final result = await getIt<CouponRepository>().getBanners();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loadingBanners = false),
      (banners) => setState(() {
        _banners = banners;
        _loadingBanners = false;
      }),
    );
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _displayedRestaurants = _allRestaurants;
        _selectedCategory = null;
      });
      return;
    }
    setState(() => _loadingRestaurants = true);
    final result = await getIt<RestaurantRepository>().search(query.trim());
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loadingRestaurants = false),
      (restaurants) => setState(() {
        _displayedRestaurants = restaurants;
        _loadingRestaurants = false;
      }),
    );
  }

  List<(String, String)> _extractCategories(List<RestaurantModel> restaurants) {
    final seen = <String>{};
    final result = <(String, String)>[];
    for (final r in restaurants) {
      final cuisine = r.cuisineType?.trim() ?? '';
      if (cuisine.isNotEmpty && seen.add(cuisine)) {
        final emoji = _emojiMap.entries
            .firstWhere(
              (e) => cuisine.toLowerCase().contains(e.key),
              orElse: () => const MapEntry('', '🍽️'),
            )
            .value;
        result.add((emoji, cuisine));
        if (result.length >= 8) break;
      }
    }
    return result;
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _searchQuery = value.trim());
        _search(value.trim());
      }
    });
  }

  void _onCategoryTap(String category) {
    if (_selectedCategory == category) {
      _searchController.clear();
      setState(() {
        _selectedCategory = null;
        _searchQuery = '';
        _displayedRestaurants = _allRestaurants;
      });
    } else {
      _searchController.text = category;
      setState(() {
        _selectedCategory = category;
        _searchQuery = category;
      });
      _search(category);
    }
  }

  bool get _isSearching => _searchQuery.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
<<<<<<< HEAD
            Text('client.deliver_to'.tr(), style: theme.textTheme.bodySmall),
=======
            Text(
              'client.deliver_to'.tr(),
              style: theme.textTheme.bodySmall,
            ),
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppConstants.defaultCity,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: RefreshIndicator(
        color: theme.colorScheme.primary,
        onRefresh: () async {
          _searchController.clear();
          setState(() {
            _searchQuery = '';
            _selectedCategory = null;
          });
          await _loadData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              _buildSearchBar(context),
              const SizedBox(height: 4),
              if (!_isSearching) _buildBannerCarousel(),
              _buildCategories(context),
              _buildRestaurantSection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        onSubmitted: (query) {
          final q = query.trim();
          if (q.isNotEmpty) context.push('/search?q=${Uri.encodeComponent(q)}');
        },
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
                      _displayedRestaurants = _allRestaurants;
                    });
                  },
                )
              : const Icon(Icons.tune_outlined),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: theme.cardTheme.color,
        ),
      ),
    );
  }
<<<<<<< HEAD

  Widget _buildBannerCarousel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: _loadingBanners && _banners.isEmpty
          ? Container(
              height: 160,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            )
          : BannerCarousel(banners: _banners, height: 160),
=======
  
  Widget _buildPromotionsCarousel(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1000&auto=format&fit=crop'),
                fit: BoxFit.cover,
              )
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Livraison Gratuite', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Sur votre 1ère commande', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    );
  }

  Widget _buildCategories(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'client.categories'.tr()),
        SizedBox(
          height: 96,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
<<<<<<< HEAD
            itemCount: _categories.length,
            itemBuilder: (_, index) {
              final (emoji, label) = _categories[index];
              final isSelected = _selectedCategory == label;
              return GestureDetector(
                onTap: () => _onCategoryTap(label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 76,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.cardTheme.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withValues(alpha: 0.07),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? theme.colorScheme.primary : null,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
=======
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Container(
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                        ]
                      ),
                      child: Center(child: Icon(Icons.fastfood, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      categories[index],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
<<<<<<< HEAD
        SectionHeader(
          title: _isSearching
              ? 'client.search_results'.tr()
              : 'client.recommended'.tr(),
          actionLabel: _isSearching ? null : 'client.see_all'.tr(),
=======
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'client.recommended'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'client.see_all'.tr(),
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        FutureBuilder<Response>(
          future: getIt<RestaurantService>().getRestaurants("Douala", null, null),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()));
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data?.body == null) {
              return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text("Impossible de charger les restaurants.")));
            }
            
            final responseBody = snapshot.data!.body;
            List<dynamic> restaurants = [];
            if (responseBody is Map && responseBody.containsKey('data')) {
              restaurants = responseBody['data'] as List<dynamic>;
            } else if (responseBody is List) {
              restaurants = responseBody;
            }

            if (restaurants.isEmpty) {
               return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text("Aucun restaurant disponible dans votre zone.")));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                final id = restaurant['id']?.toString() ?? (index + 1).toString();
                final name = restaurant['name'] ?? 'Restaurant Gourmet';
                final cuisine = restaurant['cuisineType'] ?? 'Cuisine Locale';
                final rating = restaurant['rating']?.toString() ?? 'N/A';
                final minTime = restaurant['deliveryTimeMinutes']?.toString() ?? '30';
                // La variable `image` n'étant pas systématique dans la db, on laisse le placeholder s'il n'y a rien.
                final image = restaurant['coverImage'] ?? 'https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=1000&auto=format&fit=crop';

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style: Theme.of(context).textTheme.titleLarge,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, size: 14, color: Theme.of(context).colorScheme.onSecondary),
                                      const SizedBox(width: 4),
                                      Text(rating, style: Theme.of(context).textTheme.labelLarge),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cuisine,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.delivery_dining, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Text('Frais variables', style: Theme.of(context).textTheme.bodySmall), // Les frais dépendent de la distance (Mapbox)
                                const SizedBox(width: 16),
                                Icon(Icons.timer, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Text('$minTime min', style: Theme.of(context).textTheme.bodySmall),
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
          }
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
        ),
        _buildRestaurantList(context),
      ],
    );
  }

  Widget _buildRestaurantList(BuildContext context) {
    if (_loadingRestaurants) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_displayedRestaurants.isEmpty) {
      return EmptyState(
        title: _isSearching
            ? 'common.no_results'.tr()
            : 'restaurant.none_available'.tr(),
        subtitle: _isSearching ? 'common.try_other_query'.tr() : null,
        icon: _isSearching ? Icons.search_off : Icons.restaurant_outlined,
        actionLabel: _isSearching ? 'common.clear'.tr() : null,
        onAction: _isSearching
            ? () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = null;
                  _displayedRestaurants = _allRestaurants;
                });
              }
            : null,
      );
    }

    // Responsive: 1 column on phones, 2 columns on tablets
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        if (isTablet) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisExtent: 240,
              ),
              itemCount: _displayedRestaurants.length,
              itemBuilder: (_, i) => RestaurantCard(
                restaurant: _displayedRestaurants[i],
                compact: true,
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _displayedRestaurants.length,
          itemBuilder: (_, i) =>
              RestaurantCard(restaurant: _displayedRestaurants[i]),
        );
      },
    );
  }
}
