import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/config/app_constants.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/models/coupon_model.dart';
import '../../../../../core/models/restaurant_model.dart';
import '../../../../../core/repositories/coupon_repository.dart';
import '../../../../../core/repositories/restaurant_repository.dart';
import '../../../../../shared/widgets/banner_carousel.dart';
import '../../../../../shared/widgets/empty_state.dart';
import '../../../../../shared/widgets/restaurant_card.dart';
import '../../../../../shared/widgets/section_header.dart';

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
            Text('client.deliver_to'.tr(), style: theme.textTheme.bodySmall),
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
        SectionHeader(
          title: _isSearching
              ? 'client.search_results'.tr()
              : 'client.recommended'.tr(),
          actionLabel: _isSearching ? null : 'client.see_all'.tr(),
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
