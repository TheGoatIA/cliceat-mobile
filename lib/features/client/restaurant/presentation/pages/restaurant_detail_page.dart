import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/config/app_constants.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/home/data/models/menu_item_model.dart';
import 'package:cliceat_app/features/client/home/data/models/restaurant_model.dart';
import 'package:cliceat_app/features/client/home/data/repositories/restaurant_repository.dart';
import '../../../../../shared/widgets/app_network_image.dart';
import '../../../../../core/services/analytics_service.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/data/local/daos/favorites_dao.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/data/repositories/order_repository.dart';
import '../widgets/restaurant_reviews_list.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;
  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage>
    with SingleTickerProviderStateMixin {
  RestaurantModel? _restaurant;
  bool _loading = true;
  String? _error;

  // ─── Tab state ────────────────────────────────────────────────────────────
  int _activeTab = 0; // 0 = Menu, 1 = Infos, 2 = Avis

  // ─── Menu layout ───────────────────────────────────────────────────────
  bool _isGridView = false; // false = list, true = grid

  // ─── Review-write CTA ────────────────────────────────────────────────
  bool _checkingOrders = false;

  @override
  void initState() {
    super.initState();
    _loadRestaurant();
  }

  // ─── Data loading ─────────────────────────────────────────────────────────

  Future<void> _loadRestaurant() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await getIt<RestaurantRepository>().getDetails(
      widget.restaurantId,
    );
    if (!mounted) return;
    result.fold(
      (err) => setState(() {
        _error = err.message;
        _loading = false;
      }),
      (restaurant) async {
        // Check Drift DB for local favorite status — source-of-truth
        bool isFav;
        try {
          isFav = await getIt<FavoritesDao>().isFavorite(widget.restaurantId);
        } catch (e, s) {
          debugPrint('Drift isFavorite error: $e\n$s');
          // Drift not ready yet — fall back to server value
          isFav = restaurant.isFavorite;
        }
        if (!mounted) return;
        setState(() {
          _restaurant = restaurant.copyWith(isFavorite: isFav);
          _loading = false;
        });
        getIt<AnalyticsService>().logRestaurantViewed(
          restaurant.id,
          restaurant.name,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.read<CartCubit>().setDeliveryFee(AppConstants.defaultDeliveryFee);
          }
        });
      },
    );
  }

  // ─── Favorite toggle ──────────────────────────────────────────────────────

  Future<void> _toggleFavorite() async {
    if (_restaurant == null) return;
    HapticFeedback.mediumImpact();

    final newStatus = !_restaurant!.isFavorite;

    // 1. Optimistic update — instantaneous, no page reload
    setState(() {
      _restaurant = _restaurant!.copyWith(isFavorite: newStatus);
    });

    // 2. Persist in Drift DB immediately
    try {
      if (newStatus) {
        await getIt<FavoritesDao>().addFavorite(widget.restaurantId);
      } else {
        await getIt<FavoritesDao>().removeFavorite(widget.restaurantId);
      }
    } catch (e, s) {
      debugPrint('Drift toggleFavorite error: $e\n$s');
      // Drift write failed — still proceed with API call
    }

    // 3. Call API in background — rollback only on error
    final result = await getIt<RestaurantRepository>().toggleFavorite(
      widget.restaurantId,
    );

    result.fold(
      (err) async {
        // API failed → rollback UI and Drift DB
        if (mounted) {
          setState(() {
            _restaurant = _restaurant!.copyWith(isFavorite: !newStatus);
          });
        }
        try {
          if (newStatus) {
            await getIt<FavoritesDao>().removeFavorite(widget.restaurantId);
          } else {
            await getIt<FavoritesDao>().addFavorite(widget.restaurantId);
          }
        } catch (e, s) {
          debugPrint('Drift toggleFavorite rollback error: $e\n$s');
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.message.tr())),
          );
        }
      },
      (_) {
        // Success — Drift + optimistic update already in place
      },
    );
  }

  // ─── Review CTA — find a deliverable unrated order ────────────────────────

  Future<void> _onWriteReviewTapped() async {
    if (_checkingOrders) return;
    setState(() => _checkingOrders = true);

    final result = await getIt<OrderRepository>().getOrders(page: 1, limit: 50);

    if (!mounted) return;
    setState(() => _checkingOrders = false);

    result.fold((err) => _showNoOrderDialog(), (orders) {
      // Find a delivered, unrated order for this restaurant
      final eligible = orders.where((o) {
        final matchesRestaurant = o.restaurantId == widget.restaurantId;
        final isDelivered = o.status == 'delivered';
        final notRated = o.rating == null;
        return matchesRestaurant && isDelivered && notRated;
      }).toList();

      if (eligible.isEmpty) {
        _showNoOrderDialog();
      } else {
        // Use the most recent eligible order
        final order = eligible.first;
        context.push('/client/rate/${order.id}');
      }
    });
  }

  void _showNoOrderDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.bgWarm,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 30,
                color: AppTheme.muted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'review.no_eligible_order_title'.tr(),
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'review.no_eligible_order_message'.tr(),
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.muted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(dialogCtx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text('common.understood'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppTheme.bg,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryRed,
            strokeWidth: 2,
          ),
        ),
      );
    }
    if (_error != null || _restaurant == null) {
      return Scaffold(
        backgroundColor: AppTheme.bg,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppTheme.redSoft,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    size: 36,
                    color: AppTheme.primaryRed,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'restaurant.error_load'.tr(),
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.ink,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loadRestaurant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text('common.retry'.tr()),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'common.back'.tr(),
                    style: const TextStyle(color: AppTheme.muted),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final restaurant = _restaurant!;
    final name = restaurant.name;
    final cuisine = restaurant.cuisineType ?? '';
    final rating = restaurant.rating?.toStringAsFixed(1) ?? 'N/A';
    final minTime = restaurant.deliveryTimeMinutes?.toString() ?? '30';
    final deliveryFee = AppConstants.defaultDeliveryFee;
    final description = restaurant.description ?? '';
    final menus = restaurant.menus;

    final lang = context.locale.languageCode;
    final menusByCategory = <String, List<MenuItemModel>>{};
    for (final item in menus) {
      final cat = (item.category ?? '').trim();
      menusByCategory.putIfAbsent(cat, () => []).add(item);
    }
    final categoryEntries = [
      ...menusByCategory.entries.where((e) => e.key.isNotEmpty),
      if (menusByCategory.containsKey('')) MapEntry('', menusByCategory['']!),
    ];

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: CustomScrollView(
        slivers: [
          // ── Hero app bar ────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppTheme.ink,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                child: GestureDetector(
                  onTap: _toggleFavorite,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.lineSoft),
                    ),
                    child: Icon(
                      _restaurant?.isFavorite == true
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 20,
                      color: _restaurant?.isFavorite == true
                          ? AppTheme.primaryRed
                          : AppTheme.ink,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppNetworkImage(
                    url: restaurant.coverImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 260,
                    fallbackAsset: 'assets/images/restaurant_placeholder.jpg',
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.ink.withValues(alpha: 0.7),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Row(
                      children: [
                        if (!restaurant.isOpen)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryRed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Fermé',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.ink,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 13,
                                color: AppTheme.honey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
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
            ),
          ),

          // ── Restaurant info ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.ink,
                      letterSpacing: -0.6,
                    ),
                  ),
                  if (cuisine.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      cuisine,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.access_time_rounded,
                        label: '$minTime min',
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.delivery_dining_rounded,
                        label: deliveryFee > 0
                            ? '${deliveryFee.toStringAsFixed(0)} FCFA'
                            : 'restaurant.variable_fee'.tr(),
                      ),
                    ],
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.muted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Tab switcher ────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildTabBar()),

          // ── Menu layout toggle (only shown on menu tab) ──────────────────
          if (_activeTab == 0 && menus.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'restaurant.tab_menu'.tr(),
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    // Toggle button
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.bgWarm,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.lineSoft),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _LayoutToggleBtn(
                            icon: Icons.view_list_rounded,
                            isActive: !_isGridView,
                            onTap: () {
                              if (_isGridView) {
                                HapticFeedback.selectionClick();
                                setState(() => _isGridView = false);
                              }
                            },
                          ),
                          _LayoutToggleBtn(
                            icon: Icons.grid_view_rounded,
                            isActive: _isGridView,
                            onTap: () {
                              if (!_isGridView) {
                                HapticFeedback.selectionClick();
                                setState(() => _isGridView = true);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Tab content ─────────────────────────────────────────────────
          if (_activeTab == 0) ...[
            // Menu tab
            if (menus.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppTheme.bgWarm,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: const Icon(
                            Icons.restaurant_menu_rounded,
                            size: 28,
                            color: AppTheme.muted,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'restaurant.no_items'.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              _buildMenuSliver(
                context,
                categoryEntries,
                widget.restaurantId,
                deliveryFee,
                lang,
              ),
          ] else if (_activeTab == 1) ...[
            // Infos tab
            _buildInfosSliver(),
          ] else ...[
            // Reviews tab
            _buildReviewsSliver(),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          if (cartState.itemCount == 0) return const SizedBox.shrink();
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppTheme.lineSoft)),
            ),
            child: SafeArea(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.push('/client/cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${cartState.itemCount}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'restaurant.view_cart'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${cartState.subtotal.toStringAsFixed(0)} FCFA',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Tab bar widget ────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Container(
            height: 46,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.bgWarm,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              children: [
                // Animated indicator pill
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOutCubic,
                  left: _activeTab * (MediaQuery.of(context).size.width - 32 - 8) / 3,
                  top: 0,
                  bottom: 0,
                  width: (MediaQuery.of(context).size.width - 32 - 8) / 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tab labels
                Row(
                  children: [
                    _TabItem(
                      label: 'restaurant.tab_menu'.tr(),
                      icon: Icons.restaurant_menu_rounded,
                      isActive: _activeTab == 0,
                      onTap: () {
                        if (_activeTab != 0) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeTab = 0);
                        }
                      },
                    ),
                    _TabItem(
                      label: 'restaurant.tab_infos'.tr(),
                      icon: Icons.info_outline_rounded,
                      isActive: _activeTab == 1,
                      onTap: () {
                        if (_activeTab != 1) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeTab = 1);
                        }
                      },
                    ),
                    _TabItem(
                      label: 'restaurant.tab_reviews'.tr(),
                      icon: Icons.star_rounded,
                      isActive: _activeTab == 2,
                      onTap: () {
                        if (_activeTab != 2) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeTab = 2);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1, color: AppTheme.lineSoft),
        ],
      ),
    );
  }

  // ─── Infos sliver ──────────────────────────────────────────────────────────

  bool _checkCurrentlyOpen(List<OpeningHoursModel> hours) {
    if (_restaurant == null || !_restaurant!.isOpen) return false;
    final now = DateTime.now();
    final currentDay = now.weekday % 7;
    final todayHours = hours.firstWhere(
      (h) => h.dayOfWeek == currentDay,
      orElse: () => const OpeningHoursModel(dayOfWeek: 0, openTime: '', closeTime: '', isClosed: true),
    );

    if (todayHours.isClosed || todayHours.openTime.isEmpty || todayHours.closeTime.isEmpty) {
      return false;
    }

    try {
      final openParts = todayHours.openTime.split(':');
      final closeParts = todayHours.closeTime.split(':');
      final openMin = int.parse(openParts[0]) * 60 + int.parse(openParts[1]);
      final closeMin = int.parse(closeParts[0]) * 60 + int.parse(closeParts[1]);
      final currentMin = now.hour * 60 + now.minute;
      
      return currentMin >= openMin && currentMin <= closeMin;
    } catch (_) {
      return true;
    }
  }

  String _getLocalizedDayName(int day) {
    switch (day) {
      case 0: return 'restaurant.sun'.tr();
      case 1: return 'restaurant.mon'.tr();
      case 2: return 'restaurant.tue'.tr();
      case 3: return 'restaurant.wed'.tr();
      case 4: return 'restaurant.thu'.tr();
      case 5: return 'restaurant.fri'.tr();
      case 6: return 'restaurant.sat'.tr();
      default: return '';
    }
  }

  Widget _buildInfosSliver() {
    final restaurant = _restaurant!;
    final hours = restaurant.openingHours;
    final isOpen = _checkCurrentlyOpen(hours);
    final phone = restaurant.phone ?? '';
    final address = restaurant.address ?? '';

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Open status glassmorphic card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.lineSoft),
                boxShadow: AppTheme.shadowSm,
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isOpen ? AppTheme.green.withValues(alpha: 0.1) : AppTheme.primaryRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isOpen ? Icons.check_circle_outline_rounded : Icons.cancel_outlined,
                      color: isOpen ? AppTheme.green : AppTheme.primaryRed,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOpen ? 'restaurant.open'.tr() : 'restaurant.closed'.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isOpen ? AppTheme.green : AppTheme.primaryRed,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'restaurant.opening_hours'.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Address & Phone Section
            if (address.isNotEmpty || phone.isNotEmpty) ...[
              Text(
                'restaurant.contact_info'.tr(),
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.ink,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),
              
              if (address.isNotEmpty) ...[
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: address));
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${'restaurant.address'.tr()} copié !'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.lineSoft),
                      boxShadow: AppTheme.shadowSm,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: AppTheme.primaryRed, size: 20),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'restaurant.address'.tr(),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.muted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                address,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.copy_rounded, color: AppTheme.muted, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              if (phone.isNotEmpty) ...[
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: phone));
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${'restaurant.phone'.tr()} copié !'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.lineSoft),
                      boxShadow: AppTheme.shadowSm,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.phone_rounded, color: AppTheme.green, size: 20),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'restaurant.phone'.tr(),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.muted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                phone,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.copy_rounded, color: AppTheme.muted, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ],

            // Opening Hours Section
            Text(
              'restaurant.opening_hours'.tr(),
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            
            if (hours.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.lineSoft),
                ),
                alignment: Alignment.center,
                child: Text(
                  'restaurant.no_items'.tr(),
                  style: GoogleFonts.inter(color: AppTheme.muted, fontSize: 14),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.lineSoft),
                  boxShadow: AppTheme.shadowSm,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: 7,
                  separatorBuilder: (context, index) => const Divider(height: 16, color: AppTheme.lineSoft),
                  itemBuilder: (context, index) {
                    // Mongoose starts with 0 = Sunday, 1 = Monday...
                    // In our list, let's display Monday through Sunday logically (index 0 = Monday (1), index 5 = Saturday (6), index 6 = Sunday (0))
                    final displayDayOfWeek = (index + 1) % 7;
                    final dayHours = hours.firstWhere(
                      (h) => h.dayOfWeek == displayDayOfWeek,
                      orElse: () => OpeningHoursModel(dayOfWeek: displayDayOfWeek, openTime: '', closeTime: '', isClosed: true),
                    );

                    final isToday = DateTime.now().weekday % 7 == displayDayOfWeek;
                    final dayName = _getLocalizedDayName(displayDayOfWeek);
                    final hoursText = dayHours.isClosed || dayHours.openTime.isEmpty
                        ? 'restaurant.closed'.tr()
                        : '${dayHours.openTime} - ${dayHours.closeTime}';

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (isToday) ...[
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryRed,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              isToday ? '$dayName (${'restaurant.today'.tr()})' : dayName,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                color: isToday ? AppTheme.ink : AppTheme.inkSoft,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          hoursText,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                            color: dayHours.isClosed || dayHours.openTime.isEmpty
                                ? AppTheme.primaryRed
                                : (isToday ? AppTheme.green : AppTheme.inkSoft),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ─── Reviews sliver ────────────────────────────────────────────────────────

  Widget _buildReviewsSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Rating summary row
            if (_restaurant?.rating != null && _restaurant!.rating! > 0) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.lineSoft),
                  boxShadow: AppTheme.shadowSm,
                ),
                child: Row(
                  children: [
                    // Big rating number
                    Column(
                      children: [
                        Text(
                          _restaurant!.rating!.toStringAsFixed(1),
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.ink,
                            letterSpacing: -1,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (i) {
                            final filled = i < _restaurant!.rating!.round();
                            return Icon(
                              filled
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              size: 14,
                              color: filled
                                  ? AppTheme.honey
                                  : AppTheme.lineSoft,
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'review.overall_rating'.tr(),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.inkSoft,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'review.based_on_reviews'.tr(),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Write-review CTA button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _checkingOrders ? null : _onWriteReviewTapped,
                icon: _checkingOrders
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primaryRed,
                        ),
                      )
                    : const Icon(Icons.rate_review_rounded, size: 18),
                label: Text(
                  _checkingOrders
                      ? 'common.loading'.tr()
                      : 'review.write_review'.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryRed,
                  side: const BorderSide(
                    color: AppTheme.primaryRed,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Reviews list title
            Text(
              'review.client_reviews'.tr(),
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),

            // Reviews list widget
            RestaurantReviewsList(restaurantId: widget.restaurantId),
          ],
        ),
      ),
    );
  }

  // ─── Menu sliver ─────────────────────────────────────────────────────────────

  Widget _buildMenuSliver(
    BuildContext context,
    List<MapEntry<String, List<MenuItemModel>>> categoryEntries,
    String restaurantId,
    double deliveryFee,
    String lang,
  ) {
    if (_isGridView) {
      return _buildMenuGrid(
        context, categoryEntries, restaurantId, deliveryFee, lang);
    }
    return _buildMenuList(
      context, categoryEntries, restaurantId, deliveryFee, lang);
  }

  // ── List mode ──────────────────────────────────────────────────────────────

  Widget _buildMenuList(
    BuildContext context,
    List<MapEntry<String, List<MenuItemModel>>> categoryEntries,
    String restaurantId,
    double deliveryFee,
    String lang,
  ) {
    final rows = <Object>[];
    for (final entry in categoryEntries) {
      if (entry.key.isNotEmpty) rows.add(entry.key);
      rows.addAll(entry.value);
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final row = rows[index];
          if (row is String) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(4, 20, 4, 10),
              child: Text(
                row,
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.ink,
                  letterSpacing: -0.3,
                ),
              ),
            );
          }
          final item = row as MenuItemModel;
          final hasVariations = item.variations.isNotEmpty;

          return GestureDetector(
            onTap: () => _showItemDetailModal(
              context, item, restaurantId, deliveryFee, lang),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.lineSoft),
                boxShadow: AppTheme.shadowSm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AppNetworkImage(
                      url: item.image,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      fallbackAsset:
                          'assets/images/restaurant_placeholder.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.getName(lang),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.ink,
                          ),
                        ),
                        if (item.getDescription(lang)?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 3),
                          Text(
                            item.getDescription(lang)!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.muted,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          '${item.price.toStringAsFixed(0)} FCFA',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      if (hasVariations) {
                        _showItemDetailModal(
                            context, item, restaurantId, deliveryFee, lang);
                      } else {
                        _addToCartWithConfirmation(
                          context: context,
                          restaurantId: restaurantId,
                          item: item,
                          deliveryFee: deliveryFee,
                        );
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }, childCount: rows.length),
      ),
    );
  }

  // ── Grid mode ──────────────────────────────────────────────────────────────

  Widget _buildMenuGrid(
    BuildContext context,
    List<MapEntry<String, List<MenuItemModel>>> categoryEntries,
    String restaurantId,
    double deliveryFee,
    String lang,
  ) {
    // Flatten to mixed rows: String = category header, MenuItemModel = item
    final rows = <Object>[];
    for (final entry in categoryEntries) {
      if (entry.key.isNotEmpty) rows.add(entry.key);
      rows.addAll(entry.value);
    }

    // Build slivers: headers as full-width SliverToBoxAdapter, items as
    // SliverGrid blocks per category
    final slivers = <Widget>[];
    var currentItems = <MenuItemModel>[];

    void flushItems(String categoryName) {
      if (currentItems.isEmpty) return;
      final items = List<MenuItemModel>.from(currentItems);
      currentItems = [];
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) => _buildGridMenuCard(
                context, items[i], restaurantId, deliveryFee, lang),
              childCount: items.length,
            ),
          ),
        ),
      );
    }

    for (final row in rows) {
      if (row is String) {
        flushItems(row);
        slivers.add(
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Text(
                row,
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.ink,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
        );
      } else {
        currentItems.add(row as MenuItemModel);
      }
    }
    flushItems('');

    return SliverMainAxisGroup(slivers: slivers);
  }

  /// Single card for grid mode.
  Widget _buildGridMenuCard(
    BuildContext context,
    MenuItemModel item,
    String restaurantId,
    double deliveryFee,
    String lang,
  ) {
    final hasVariations = item.variations.isNotEmpty;
    return GestureDetector(
      onTap: () =>
          _showItemDetailModal(context, item, restaurantId, deliveryFee, lang),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.lineSoft),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: AppNetworkImage(
                url: item.image,
                width: double.infinity,
                height: 110,
                fit: BoxFit.cover,
                fallbackAsset: 'assets/images/restaurant_placeholder.jpg',
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.getName(lang),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.ink,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.getDescription(lang)?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 3),
                      Text(
                        item.getDescription(lang)!,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.muted,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.price.toStringAsFixed(0)} FCFA',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryRed,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            if (hasVariations) {
                              _showItemDetailModal(context, item,
                                  restaurantId, deliveryFee, lang);
                            } else {
                              _addToCartWithConfirmation(
                                context: context,
                                restaurantId: restaurantId,
                                item: item,
                                deliveryFee: deliveryFee,
                              );
                            }
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryRed,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmClearCart(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'cart.clear_confirm_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.ink,
          ),
        ),
        content: Text(
          'cart.clear_confirm_message'.tr(),
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'common.cancel'.tr(),
              style: const TextStyle(color: AppTheme.muted),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('common.yes'.tr()),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _addToCartWithConfirmation({
    required BuildContext context,
    required String restaurantId,
    required MenuItemModel item,
    required double deliveryFee,
    String? variation,
    String? notes,
    double? priceOverride,
  }) async {
    final cartCubit = context.read<CartCubit>();
    final lang = context.locale.languageCode;
    final messenger = ScaffoldMessenger.of(context);

    if (cartCubit.state.wouldClearCart(restaurantId)) {
      final confirmed = await _confirmClearCart(context);
      if (!confirmed) return;
      await cartCubit.clearCart();
    }

    final displayName = variation != null
        ? '${item.getName(lang)} ($variation)'
        : item.getName(lang);

    await cartCubit.addItem(
      restaurantId: restaurantId,
      itemId: item.id,
      name: displayName,
      price: priceOverride ?? item.price,
      deliveryFee: deliveryFee,
      variation: variation,
      notes: notes,
    );

    // The persistent bottom bar (bottomNavigationBar) already shows "Voir le panier"
    // so the SnackBar only needs to confirm the add – no action button needed.
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text('restaurant.added_to_cart'.tr()),
          ],
        ),
        backgroundColor: AppTheme.ink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }



  void _showItemDetailModal(
    BuildContext context,
    MenuItemModel item,
    String restaurantId,
    double deliveryFee,
    String lang,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: AppNetworkImage(
                  url: item.image,
                  height: item.image != null ? 200 : 80,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  fallbackAsset: 'assets/images/restaurant_placeholder.jpg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.getName(lang),
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.ink,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${item.price.toStringAsFixed(0)} FCFA',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryRed,
                      ),
                    ),
                    if (item.getDescription(lang)?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 12),
                      Text(
                        item.getDescription(lang)!,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.muted,
                          height: 1.5,
                        ),
                      ),
                    ],
                    if (item.variations.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        'restaurant.choose_variation'.tr(),
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.ink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...item.variations.map(
                        (v) => GestureDetector(
                          onTap: () {
                            Navigator.pop(ctx);
                            _addToCartWithConfirmation(
                              context: context,
                              restaurantId: restaurantId,
                              item: item,
                              deliveryFee: deliveryFee,
                              variation: v.name,
                              priceOverride: item.price + v.price,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.bg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppTheme.line),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  v.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.ink,
                                  ),
                                ),
                                Text(
                                  v.price > 0
                                      ? '+${v.price.toStringAsFixed(0)} FCFA'
                                      : '${(item.price + v.price).toStringAsFixed(0)} FCFA',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    if (item.variations.isEmpty)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _addToCartWithConfirmation(
                              context: context,
                              restaurantId: restaurantId,
                              item: item,
                              deliveryFee: deliveryFee,
                            );
                          },
                          icon: const Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 18,
                          ),
                          label: Text(
                            'restaurant.add_to_cart'.tr(),
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryRed,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tab item widget ──────────────────────────────────────────────────────────

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: isActive ? AppTheme.primaryRed : AppTheme.muted,
              ),
              const SizedBox(width: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppTheme.ink : AppTheme.muted,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Info chip widget ─────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.lineSoft),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.muted),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Layout toggle button widget ──────────────────────────────────────────────

class _LayoutToggleBtn extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _LayoutToggleBtn({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryRed : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : AppTheme.muted,
        ),
      ),
    );
  }
}
