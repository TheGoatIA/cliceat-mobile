import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/config/app_constants.dart';
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
import '../bloc/promotion_cubit.dart';
import '../../../../../shared/widgets/promotion_banner.dart';

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

  List<RestaurantModel> _allRestaurants = [];
  List<RestaurantModel> _displayedRestaurants = [];
  List<BannerModel> _banners = [];
  List<(String, String)> _categories = _fallbackCategories;

  bool _loadingRestaurants = true;
  bool _loadingBanners = true;

  static const _fallbackCategories = [
    ('🥬', 'Ndolé'),
    ('🍗', 'Poulet DG'),
    ('🐟', 'Poisson'),
    ('🔥', 'Grillades'),
    ('🍩', 'Beignets'),
    ('🌿', 'Eru'),
    ('🥖', 'Bobolo'),
    ('🥤', 'Jus local'),
  ];

  static const _emojiMap = {
    'burger': '🍔', 'pizza': '🍕', 'poulet': '🍗', 'chicken': '🍗',
    'salade': '🥗', 'salad': '🥗', 'ndolé': '🥬', 'ndole': '🥬',
    'poisson': '🐟', 'fish': '🐟', 'sushi': '🍱', 'tacos': '🌮',
    'sandwich': '🥙', 'pasta': '🍝', 'dessert': '🍰', 'jus': '🥤',
    'rice': '🍚', 'riz': '🍚', 'viande': '🥩', 'meat': '🥩',
    'eru': '🌿', 'beignet': '🍩', 'grillades': '🔥',
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
    result.fold((_) => setState(() => _loadingRestaurants = false), (restaurants) {
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
            .firstWhere((e) => cuisine.toLowerCase().contains(e.key), orElse: () => const MapEntry('', '🍽️'))
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
      setState(() { _selectedCategory = null; _searchQuery = ''; _displayedRestaurants = _allRestaurants; });
    } else {
      _searchController.text = category;
      setState(() { _selectedCategory = category; _searchQuery = category; });
      _search(category);
    }
  }

  bool get _isSearching => _searchQuery.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PromotionCubit>()..loadGlobalPromotions(),
      child: Scaffold(
        backgroundColor: AppTheme.bg,
        body: RefreshIndicator(
          color: AppTheme.primaryRed,
          onRefresh: () async {
            _searchController.clear();
            setState(() { _searchQuery = ''; _selectedCategory = null; });
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
              if (!_isSearching) SliverToBoxAdapter(child: _buildReferralBanner()),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
        floatingActionButton: _buildFAB(context),
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
                    'Livrer à',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.muted, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 16, color: AppTheme.primaryRed),
                      const SizedBox(width: 4),
                      Text(
                        AppConstants.defaultCity,
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.ink),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.muted),
                    ],
                  ),
                ],
              ),
            ),
            // Notification bell
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.lineSoft),
                ),
                child: Stack(
                  children: [
                    const Center(child: Icon(Icons.notifications_outlined, size: 20, color: AppTheme.ink)),
                    Positioned(
                      top: 8, right: 9,
                      child: Container(
                        width: 8, height: 8,
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
            // Chat
            GestureDetector(
              onTap: () => context.push('/client/chat'),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.ink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Colors.white),
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
                    if (q.isNotEmpty) context.push('/search?q=${Uri.encodeComponent(q)}');
                  },
                  decoration: InputDecoration(
                    hintText: 'Chercher un plat, un restaurant...',
                    hintStyle: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
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
              const Icon(Icons.tune_rounded, size: 18, color: AppTheme.ink),
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
    // Default hero
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
          // Decorative circle
          Positioned(
            right: -30, top: -30,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                color: AppTheme.honey.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(80),
              ),
            ),
          ),
          // Food emoji
          const Positioned(
            right: 20, bottom: 12,
            child: Text('🍲', style: TextStyle(fontSize: 84)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department_rounded, size: 11, color: Colors.white),
                      const SizedBox(width: 4),
                      Text('Offre du jour', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Livraison\ngratuite',
                  style: GoogleFonts.bricolageGrotesque(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white, height: 1.1, letterSpacing: -0.5),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withValues(alpha: 0.85)),
                    children: [
                      const TextSpan(text: 'Code '),
                      TextSpan(
                        text: 'BIENVENUE',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppTheme.honeyLight),
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
    return BlocBuilder<PromotionCubit, PromotionState>(
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
                    if (restaurantId != null) context.push('/client/restaurant/$restaurantId');
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
                    border: isSelected ? null : Border.all(color: AppTheme.lineSoft),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 11, fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppTheme.ink,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
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
          title: _isSearching ? 'Résultats' : 'Près de toi',
          actionLabel: _isSearching ? null : 'Voir tout',
          leading: _isSearching ? null : const Icon(Icons.local_fire_department_rounded, size: 20, color: AppTheme.primaryRed),
        ),
        _buildRestaurantList(),
        if (!_isSearching) _buildFilterStrip(),
      ],
    );
  }

  Widget _buildFilterStrip() {
    final filters = ['Top Douala', 'Ouvert maintenant', '⭐ 4.5+', 'Moins de 30min', 'Premium'];
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: filters.asMap().entries.map((e) {
            final isFirst = e.key == 0;
            return Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: isFirst ? AppTheme.ink : Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: isFirst ? null : Border.all(color: AppTheme.line),
              ),
              child: Text(
                e.value,
                style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w600,
                  color: isFirst ? Colors.white : AppTheme.ink,
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
      return EmptyState(
        title: _isSearching ? 'common.no_results'.tr() : 'restaurant.none_available'.tr(),
        subtitle: _isSearching ? 'common.try_other_query'.tr() : null,
        icon: _isSearching ? Icons.search_off : Icons.restaurant_outlined,
        actionLabel: _isSearching ? 'common.clear'.tr() : null,
        onAction: _isSearching ? () {
          _searchController.clear();
          setState(() { _searchQuery = ''; _selectedCategory = null; _displayedRestaurants = _allRestaurants; });
        } : null,
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
                crossAxisCount: 2, crossAxisSpacing: 14, mainAxisExtent: 240,
              ),
              itemCount: _displayedRestaurants.length,
              itemBuilder: (_, i) => RestaurantCard(restaurant: _displayedRestaurants[i], compact: true),
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
    return Container(
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
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: AppTheme.honey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text('🎁', style: TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Parraine un ami', style: GoogleFonts.bricolageGrotesque(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.ink, letterSpacing: -0.2)),
                const SizedBox(height: 2),
                Text('Gagne 500 FCFA à chaque inscription', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.inkSoft)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppTheme.inkSoft),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/client/ai'),
      child: Container(
        width: 56, height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryRed, AppTheme.redDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            const BoxShadow(color: Color(0x59C41E1A), blurRadius: 24, offset: Offset(0, 8)),
            const BoxShadow(color: Color(0x4DC41E1A), blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 24),
            ),
            Positioned(
              top: 10, right: 10,
              child: Container(
                width: 8, height: 8,
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
