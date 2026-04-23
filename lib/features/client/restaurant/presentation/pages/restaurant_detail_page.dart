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
import '../../../cart/presentation/bloc/cart_cubit.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;
  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  RestaurantModel? _restaurant;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRestaurant();
  }

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
      (restaurant) {
        setState(() {
          _restaurant = restaurant;
          _loading = false;
        });
        getIt<AnalyticsService>().logRestaurantViewed(
          restaurant.id,
          restaurant.name,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.read<CartCubit>().setDeliveryFee(
              restaurant.deliveryFee > 0
                  ? restaurant.deliveryFee
                  : AppConstants.defaultDeliveryFee,
            );
          }
        });
      },
    );
  }

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
    final deliveryFee = restaurant.deliveryFee > 0
        ? restaurant.deliveryFee
        : AppConstants.defaultDeliveryFee;
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
                  onTap: () {},
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      size: 18,
                      color: Colors.white,
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

          // Restaurant info header
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

          // Menu title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'restaurant.menu'.tr(),
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.ink,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ),

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

  Widget _buildMenuSliver(
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
              context,
              item,
              restaurantId,
              deliveryFee,
              lang,
            ),
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
                      fallbackAsset: 'assets/images/restaurant_placeholder.jpg',
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
                          context,
                          item,
                          restaurantId,
                          deliveryFee,
                          lang,
                        );
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

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('restaurant.added_to_cart'.tr()),
          backgroundColor: AppTheme.ink,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 1),
          action: SnackBarAction(
            label: 'restaurant.view_cart'.tr(),
            textColor: AppTheme.honey,
            onPressed: () => context.push('/client/cart'),
          ),
        ),
      );
    }
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
