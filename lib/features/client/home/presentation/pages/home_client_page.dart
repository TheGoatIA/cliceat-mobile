import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/banner/data/models/banner_model.dart';
import 'package:cliceat_app/features/client/banner/data/repositories/banner_repository.dart';
import 'package:cliceat_app/features/client/home/data/models/restaurant_model.dart';
import 'package:cliceat_app/features/client/home/data/repositories/restaurant_repository.dart';
import '../../../../../shared/widgets/banner_carousel.dart';
import '../../../../../shared/widgets/empty_state.dart';
import '../../../../../shared/widgets/restaurant_card.dart';
import '../../../../../shared/widgets/section_header.dart';
import 'package:cliceat_app/core/config/feature_flags.dart';
import 'package:cliceat_app/core/widgets/feature_gate_sliver.dart';
import '../bloc/promotion_cubit.dart';
import '../../../../../shared/widgets/promotion_banner.dart';
import 'package:cliceat_app/features/client/profile/presentation/bloc/profile_cubit.dart';

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
  String _selectedCity = 'Yaound\u00e9';
  String _selectedFilter = '';
  String _sortBy = 'default';
  bool _isOpenOnly = false;
  bool _freeDelivery = false;
  String? _selectedCuisineType;

  List<RestaurantModel> _allRestaurants = [];
  List<RestaurantModel> _displayedRestaurants = [];
  List<BannerModel> _banners = [];
  List<(String, String)> _categories = _fallbackCategories;

  bool _loadingRestaurants = true;
  bool _loadingBanners = true;

  static const _fallbackCategories = [
    ('\u{1F96C}', 'Ndolé'),
    ('\u{1F357}', 'Poulet DG'),
    ('\u{1F41F}', 'Poisson'),
    ('\u{1F525}', 'Grillades'),
    ('\u{1F369}', 'Beignets'),
    ('\u{1F33F}', 'Eru'),
    ('\u{1F956}', 'Bobolo'),
    ('\u{1F964}', 'Jus local'),
  ];

  // Internal filter key constants
  static const _kFilterTopCity = 'top_city';
  static const _kFilterOpenNow = 'open_now';
  static const _kFilterRating45 = 'rating_4_5';
  static const _kFilterUnder30 = 'under_30min';
  static const _kFilterPremium = 'premium';

  static const _emojiMap = {
    'burger': '\u{1F354}',
    'pizza': '\u{1F355}',
    'poulet': '\u{1F357}',
    'chicken': '\u{1F357}',
    'salade': '\u{1F957}',
    'salad': '\u{1F957}',
    'healthy': '\u{1F957}',
    'ndolé': '\u{1F96C}',
    'ndole': '\u{1F96C}',
    'poisson': '\u{1F41F}',
    'fish': '\u{1F41F}',
    'sushi': '\u{1F371}',
    'tacos': '\u{1F32E}',
    'sandwich': '\u{1F959}',
    'shawarma': '\u{1F32F}',
    'chawarma': '\u{1F32F}',
    'pasta': '\u{1F35D}',
    'pate': '\u{1F35D}',
    'dessert': '\u{1F370}',
    'gateau': '\u{1F370}',
    'jus': '\u{1F964}',
    'boisson': '\u{1F964}',
    'drink': '\u{1F964}',
    'rice': '\u{1F35A}',
    'riz': '\u{1F35A}',
    'viande': '\u{1F969}',
    'meat': '\u{1F969}',
    'eru': '\u{1F33F}',
    'beignet': '\u{1F369}',
    'grillades': '\u{1F525}',
    'bbq': '\u{1F525}',
    'camerounais': '\u{1F1E8}\u{1F1F2}',
    'cameroon': '\u{1F1E8}\u{1F1F2}',
    'african': '\u{1F30D}',
    'afrique': '\u{1F30D}',
    'traditional': '\u{1F372}',
    'traditionnel': '\u{1F372}',
    'chinese': '\u{1F962}',
    'chinois': '\u{1F962}',
    'japanese': '\u{1F371}',
    'japonais': '\u{1F371}',
    'italian': '\u{1F35D}',
    'italien': '\u{1F35D}',
    'french': '\u{1F950}',
    'francais': '\u{1F950}',
    'seafood': '\u{1F364}',
    'fruits de mer': '\u{1F364}',
    'soup': '\u{1F963}',
    'soupe': '\u{1F963}',
    'coffee': '☕',
    'cafe': '☕',
    'bobolo': '\u{1F956}',
    'miondo': '\u{1F956}',
  };

  static const _fallbackFoodEmojis = [
    '\u{1F37D}️',
    '\u{1F372}',
    '\u{1F958}',
    '\u{1F959}',
    '\u{1F373}',
    '\u{1F956}',
    '\u{1F358}',
    '\u{1F359}',
    '\u{1F35B}',
    '\u{1F371}',
    '\u{1F963}',
    '\u{1F957}',
  ];

  static String _getEmojiForCuisine(String cuisine) {
    final cleaned = cuisine.toLowerCase().trim();
    for (final entry in _emojiMap.entries) {
      if (cleaned.contains(entry.key)) {
        return entry.value;
      }
    }
    final index = cleaned.hashCode.abs() % _fallbackFoodEmojis.length;
    return _fallbackFoodEmojis[index];
  }

  @override
  void initState() {
    super.initState();
    _initializeCity();
    _loadData();
  }

  void _initializeCity() {
    final profileState = context.read<ProfileCubit>().state;
    profileState.maybeWhen(
      loaded: (user) {
        if (user.city != null && user.city!.isNotEmpty) {
          _selectedCity = _normalizeCity(user.city!);
        } else {
          _selectedCity = 'Yaound\u00e9';
        }
      },
      orElse: () {
        _selectedCity = 'Yaound\u00e9';
      },
    );
  }

  String _normalizeCity(String city) {
    final lower = city.toLowerCase().trim();
    if (lower == 'douala') return 'Douala';
    if (lower == 'yaounde' || lower == 'yaound\u00e9') return 'Yaound\u00e9';
    return 'Yaound\u00e9';
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
    final cityResult = await getIt<RestaurantRepository>().getRestaurants(
      city: _selectedCity,
    );

    List<RestaurantModel> restaurants = [];
    cityResult.fold((_) {}, (list) => restaurants = list);

    if (restaurants.isEmpty) {
      final featuredResult = await getIt<RestaurantRepository>()
          .getFeaturedRestaurants();
      featuredResult.fold((_) {}, (list) => restaurants = list);
    }

    if (!mounted) return;

    final categories = _extractCategories(restaurants);
    setState(() {
      _allRestaurants = restaurants;
      _loadingRestaurants = false;
      if (categories.isNotEmpty) _categories = categories;
    });
    _applyFilters();
  }

  Future<void> _loadBanners() async {
    setState(() => _loadingBanners = true);
    final result = await getIt<BannerRepository>().getBanners();
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
        _searchQuery = '';
        _selectedCategory = null;
      });
      await _loadRestaurants();
      return;
    }
    setState(() => _loadingRestaurants = true);
    final result = await getIt<RestaurantRepository>().search(query.trim());
    if (!mounted) return;
    result.fold((_) => setState(() => _loadingRestaurants = false), (
      restaurants,
    ) {
      setState(() {
        _allRestaurants = restaurants;
        _loadingRestaurants = false;
      });
      _applyFilters();
    });
  }

  List<(String, String)> _extractCategories(List<RestaurantModel> restaurants) {
    final seen = <String>{};
    final result = <(String, String)>[];
    for (final r in restaurants) {
      final candidates = [
        if (r.cuisineType != null) r.cuisineType!.trim(),
        ...r.cuisines.map((c) => c.trim()),
      ];

      for (final c in candidates) {
        if (c.isNotEmpty && seen.add(c.toLowerCase())) {
          final displayName = c[0].toUpperCase() + c.substring(1).toLowerCase();
          final emoji = _getEmojiForCuisine(c);
          result.add((emoji, displayName));
          if (result.length >= 12) break;
        }
      }
      if (result.length >= 12) break;
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

  bool get _isFilterActive =>
      _sortBy != 'default' ||
      _isOpenOnly ||
      _freeDelivery ||
      _selectedCuisineType != null;

  void _onFilterTap(String filterKey) {
    setState(() {
      if (filterKey.isEmpty || _selectedFilter == filterKey) {
        _selectedFilter = '';
      } else {
        _selectedFilter = filterKey;
      }
    });
    _applyFilters();
  }

  List<RestaurantModel> _getFilteredRestaurantsList() {
    List<RestaurantModel> filteredList = List.from(_allRestaurants);

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filteredList = filteredList
          .where(
            (r) =>
                r.name.toLowerCase().contains(q) ||
                (r.description?.toLowerCase().contains(q) ?? false) ||
                (r.cuisineType?.toLowerCase().contains(q) ?? false) ||
                r.cuisines.any((c) => c.toLowerCase().contains(q)),
          )
          .toList();
    }

    if (_selectedFilter == _kFilterTopCity ||
        _selectedFilter == _kFilterPremium) {
      final filteredByRating = filteredList
          .where((r) => (r.rating ?? 0.0) >= 4.0)
          .toList();
      if (filteredByRating.isNotEmpty) {
        filteredList = filteredByRating;
      } else {
        filteredList.sort((a, b) {
          final ra = a.rating ?? 0.0;
          final rb = b.rating ?? 0.0;
          if (ra != rb) return rb.compareTo(ra);
          if (a.isOpen != b.isOpen) return a.isOpen ? -1 : 1;
          return a.name.compareTo(b.name);
        });
      }
    } else if (_selectedFilter == _kFilterOpenNow) {
      filteredList = filteredList.where((r) => r.isOpen == true).toList();
    } else if (_selectedFilter == _kFilterRating45) {
      final filteredByRating = filteredList
          .where((r) => (r.rating ?? 0.0) >= 4.5)
          .toList();
      if (filteredByRating.isNotEmpty) {
        filteredList = filteredByRating;
      } else {
        filteredList.sort((a, b) {
          final ra = a.rating ?? 0.0;
          final rb = b.rating ?? 0.0;
          if (ra != rb) return rb.compareTo(ra);
          if (a.isOpen != b.isOpen) return a.isOpen ? -1 : 1;
          return a.name.compareTo(b.name);
        });
      }
    }

    if (_isOpenOnly) {
      filteredList = filteredList.where((r) => r.isOpen == true).toList();
    }
    if (_freeDelivery) {
      filteredList = filteredList.where((r) => r.deliveryFee == 0).toList();
    }
    if (_selectedCuisineType != null) {
      filteredList = filteredList
          .where(
            (r) =>
                r.cuisineType == _selectedCuisineType ||
                r.cuisines.contains(_selectedCuisineType),
          )
          .toList();
    }

    if (_sortBy == 'rating') {
      filteredList.sort((a, b) => (b.rating ?? 0.0).compareTo(a.rating ?? 0.0));
    } else if (_sortBy == 'deliveryTime') {
      filteredList.sort(
        (a, b) => (a.deliveryTimeMinutes ?? 999).compareTo(
          b.deliveryTimeMinutes ?? 999,
        ),
      );
    } else if (_sortBy == 'deliveryFee') {
      filteredList.sort((a, b) => a.deliveryFee.compareTo(b.deliveryFee));
    }

    return filteredList;
  }

  void _applyFilters() {
    setState(() {
      _displayedRestaurants = _getFilteredRestaurantsList();
    });
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'home.city_picker_title'.tr(),
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 20),
            _buildCityTile('Douala', 'home.douala_subtitle'.tr()),
            _buildCityTile('Yaoundé', 'home.yaounde_subtitle'.tr()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCityTile(String city, String sub) {
    final isSelected = _selectedCity == city;
    return ListTile(
      onTap: () {
        setState(() {
          _selectedCity = city;
        });
        context.pop();
        _loadData();
        final lowerCity = city == 'Yaound\u00e9' ? 'yaounde' : 'douala';
        context.read<ProfileCubit>().updateProfile({'city': lowerCity});
      },
      leading: Icon(
        Icons.location_city_rounded,
        color: isSelected ? AppTheme.primaryRed : AppTheme.muted,
      ),
      title: Text(
        city,
        style: GoogleFonts.inter(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      subtitle: Text(sub, style: GoogleFonts.inter(fontSize: 12)),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppTheme.primaryRed)
          : null,
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required ValueChanged<bool> onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppTheme.redSoft,
      backgroundColor: AppTheme.bgWarm,
      labelStyle: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? AppTheme.primaryRed : AppTheme.inkSoft,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected
              ? AppTheme.primaryRed.withValues(alpha: 0.5)
              : AppTheme.lineSoft,
        ),
      ),
      showCheckmark: false,
    );
  }

  void _showSearchFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final cuisines = _allRestaurants
            .expand(
              (r) => [if (r.cuisineType != null) r.cuisineType!, ...r.cuisines],
            )
            .where((c) => c.trim().isNotEmpty)
            .toSet()
            .toList();

        return StatefulBuilder(
          builder: (context, setModalState) {
            int getFilteredCount() {
              return _getFilteredRestaurantsList().length;
            }

            final count = getFilteredCount();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'home.filter_title'.tr(),
                          style: GoogleFonts.bricolageGrotesque(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: AppTheme.ink,
                            letterSpacing: -0.5,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _sortBy = 'default';
                              _isOpenOnly = false;
                              _freeDelivery = false;
                              _selectedCuisineType = null;
                            });
                          },
                          child: Text(
                            'home.reset'.tr(),
                            style: GoogleFonts.inter(
                              color: AppTheme.primaryRed,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(height: 1, color: AppTheme.lineSoft),
                    const SizedBox(height: 20),
                    Text(
                      'home.sort_by'.tr(),
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppTheme.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFilterChip(
                          label: 'home.sort_default'.tr(),
                          isSelected: _sortBy == 'default',
                          onSelected: (selected) {
                            setModalState(() => _sortBy = 'default');
                          },
                        ),
                        _buildFilterChip(
                          label: 'home.sort_rating'.tr(),
                          isSelected: _sortBy == 'rating',
                          onSelected: (selected) {
                            setModalState(() => _sortBy = 'rating');
                          },
                        ),
                        _buildFilterChip(
                          label: 'home.sort_speed'.tr(),
                          isSelected: _sortBy == 'deliveryTime',
                          onSelected: (selected) {
                            setModalState(() => _sortBy = 'deliveryTime');
                          },
                        ),
                        _buildFilterChip(
                          label: 'home.sort_price'.tr(),
                          isSelected: _sortBy == 'deliveryFee',
                          onSelected: (selected) {
                            setModalState(() => _sortBy = 'deliveryFee');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'home.options'.tr(),
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppTheme.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      value: _isOpenOnly,
                      onChanged: (val) {
                        setModalState(() => _isOpenOnly = val);
                      },
                      title: Text(
                        'home.open_now'.tr(),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppTheme.ink,
                        ),
                      ),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: AppTheme.primaryRed,
                    ),
                    SwitchListTile(
                      value: _freeDelivery,
                      onChanged: (val) {
                        setModalState(() => _freeDelivery = val);
                      },
                      title: Text(
                        'home.free_delivery'.tr(),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppTheme.ink,
                        ),
                      ),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: AppTheme.primaryRed,
                    ),
                    const SizedBox(height: 20),
                    if (cuisines.isNotEmpty) ...[
                      Text(
                        'home.cuisine_type'.tr(),
                        style: GoogleFonts.bricolageGrotesque(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppTheme.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: cuisines.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final cuisine = cuisines[index];
                            final isSelected = _selectedCuisineType == cuisine;
                            return ChoiceChip(
                              label: Text(cuisine),
                              selected: isSelected,
                              onSelected: (selected) {
                                setModalState(() {
                                  _selectedCuisineType = selected
                                      ? cuisine
                                      : null;
                                });
                              },
                              selectedColor: AppTheme.redSoft,
                              backgroundColor: AppTheme.bgWarm,
                              labelStyle: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppTheme.primaryRed
                                    : AppTheme.inkSoft,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppTheme.primaryRed.withValues(
                                          alpha: 0.5,
                                        )
                                      : AppTheme.lineSoft,
                                ),
                              ),
                              showCheckmark: false,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          _applyFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryRed,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          count > 0
                              ? 'home.see_restaurants'.tr(
                                  namedArgs: {'count': '$count'},
                                )
                              : 'common.no_results'.tr(),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PromotionCubit>()..loadGlobalPromotions(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded: (user) {
              if (user.city != null && user.city!.isNotEmpty) {
                final normalized = _normalizeCity(user.city!);
                if (_selectedCity != normalized) {
                  setState(() {
                    _selectedCity = normalized;
                  });
                  _loadData();
                }
              }
            },
            orElse: () {},
          );
        },
        child: Scaffold(
        backgroundColor: AppTheme.bg,
        body: RefreshIndicator(
          color: AppTheme.primaryRed,
          onRefresh: () async {
            _searchController.clear();
            setState(() {
              _searchQuery = '';
              _selectedCategory = null;
            });
            await _loadData();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              SliverToBoxAdapter(child: _buildSearchBar(context)),
              if (!_isSearching) ...[
                SliverToBoxAdapter(child: _buildHeroBanner()),
                SliverToBoxAdapter(child: _buildPromotions(context)),
              ],
              SliverToBoxAdapter(child: _buildCategories()),
              SliverToBoxAdapter(child: _buildRestaurantSection(context)),
              if (!_isSearching)
                FeatureGateSliver(
                  featureKey: FeatureFlags.referral,
                  child: SliverToBoxAdapter(child: _buildReferralBanner()),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
        floatingActionButton: _buildFAB(context),
      ),
    ),
  );
}

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 16, 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'client.deliver_to'.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.muted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: _showCityPicker,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: AppTheme.primaryRed,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _selectedCity,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.ink,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: AppTheme.muted,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/client/notifications'),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.lineSoft),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.notifications_outlined,
                        size: 20,
                        color: AppTheme.ink,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 9,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => context.push('/client/chat'),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.ink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: GestureDetector(
        onTap: () {
          final q = _searchController.text.trim();
          if (q.isNotEmpty) context.push('/search?q=${Uri.encodeComponent(q)}');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.lineSoft),
            boxShadow: AppTheme.shadowSm,
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, size: 20, color: AppTheme.muted),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (query) {
                    final q = query.trim();
                    if (q.isNotEmpty) {
                      context.push('/search?q=${Uri.encodeComponent(q)}');
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'home.search_hint'.tr(),
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.muted,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.ink),
                ),
              ),
              Container(width: 1, height: 20, color: AppTheme.line),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _showSearchFilters,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _isFilterActive
                        ? AppTheme.redSoft
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 18,
                    color: _isFilterActive ? AppTheme.primaryRed : AppTheme.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    if (_loadingBanners && _banners.isEmpty) {
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        height: 148,
        decoration: BoxDecoration(
          color: AppTheme.bgWarm,
          borderRadius: BorderRadius.circular(24),
        ),
      );
    }
    if (_banners.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: BannerCarousel(banners: _banners, height: 160),
      );
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 148,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryRed, AppTheme.redDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppTheme.honey.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(80),
              ),
            ),
          ),
          const Positioned(
            right: 20,
            bottom: 12,
            child: Text('\u{1F372}', style: TextStyle(fontSize: 84)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        size: 11,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'home.daily_offer'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'home.free_delivery_title'.tr(),
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    children: [
                      TextSpan(text: 'home.welcome_code_prefix'.tr()),
                      TextSpan(
                        text: 'BIENVENUE',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.honeyLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotions(BuildContext context) {
    return BlocConsumer<PromotionCubit, PromotionState>(
      listener: (context, state) {
        state.maybeWhen(
          error: (msg) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg.tr()),
                backgroundColor: AppTheme.primaryRed,
              ),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (promotions) {
            if (promotions.isEmpty) return const SizedBox.shrink();
            return Column(
              children: [
                SectionHeader(title: 'promotion.exclusive_offers'.tr()),
                PromotionBanner(
                  promotions: promotions,
                  onTap: (promo) {
                    final restaurantId = promo['restaurantId'] as String?;
                    if (restaurantId != null) {
                      context.push('/client/restaurant/$restaurantId');
                    }
                  },
                ),
                const SizedBox(height: 12),
              ],
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            itemCount: _categories.length,
            itemBuilder: (_, index) {
              final (emoji, label) = _categories[index];
              final isSelected = _selectedCategory == label;
              return GestureDetector(
                onTap: () => _onCategoryTap(label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 72,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.ink : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? null
                        : Border.all(color: AppTheme.lineSoft),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppTheme.ink,
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
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildRestaurantSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: _isSearching ? 'home.results'.tr() : 'home.near_you'.tr(),
          actionLabel: _isSearching ? null : 'client.see_all'.tr(),
          onAction: () => context.push('/search?city=$_selectedCity'),
          leading: _isSearching
              ? null
              : const Icon(
                  Icons.local_fire_department_rounded,
                  size: 20,
                  color: AppTheme.primaryRed,
                ),
        ),
        if (!_isSearching) _buildFilterStrip(),
        _buildRestaurantList(),
      ],
    );
  }

  Widget _buildFilterStrip() {
    final filters = <(String, String)>[
      ('', 'home.all_restaurants'.tr()),
      (_kFilterTopCity, 'home.top_city'.tr(namedArgs: {'city': _selectedCity})),
      (_kFilterOpenNow, 'home.open_now'.tr()),
      (_kFilterRating45, '⭐ 4.5+'),
      (_kFilterUnder30, 'home.under_30min'.tr()),
      (_kFilterPremium, 'Premium'),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20, right: 80),
        child: Row(
          children: filters.map<Widget>((f) {
            final (key, label) = f;
            final isSelected = _selectedFilter == key;
            return GestureDetector(
              onTap: () => _onFilterTap(key),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.ink : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: isSelected ? null : Border.all(color: AppTheme.line),
                ),
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppTheme.ink,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRestaurantList() {
    if (_loadingRestaurants) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: AppTheme.primaryRed),
        ),
      );
    }
    if (_displayedRestaurants.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
          child: EmptyState(
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
          ),
        ),
      );
    }

    if (!_isSearching) {
      final top5 = _displayedRestaurants.take(5).toList();
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: top5
              .map(
                (r) => Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  child: RestaurantCard(restaurant: r, compact: true),
                ),
              )
              .toList(),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        if (isTablet) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _displayedRestaurants.length,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: RestaurantCard(restaurant: _displayedRestaurants[i]),
          ),
        );
      },
    );
  }

  Widget _buildReferralBanner() {
    return GestureDetector(
      onTap: () => context.push('/client/profile/referrals'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.honeySoft,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.honeyLight.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.honey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('\u{1F381}', style: TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'home.referral_title'.tr(),
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'home.referral_subtitle'.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.inkSoft,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.inkSoft),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/client/ai'),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryRed, AppTheme.redDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x59C41E1A),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
            BoxShadow(
              color: Color(0x4DC41E1A),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.honey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
