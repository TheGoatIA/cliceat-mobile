import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/config/app_constants.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/models/menu_item_model.dart';
import '../../../../../core/models/restaurant_model.dart';
import '../../../../../core/repositories/restaurant_repository.dart';
import '../../../../../shared/widgets/app_network_image.dart';
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
    setState(() { _loading = true; _error = null; });
    final result =
        await getIt<RestaurantRepository>().getDetails(widget.restaurantId);
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.read<CartCubit>().setDeliveryFee(
                restaurant.deliveryFee > 0
                    ? restaurant.deliveryFee
                    : AppConstants.defaultDeliveryFee);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null || _restaurant == null) {
      return Scaffold(
        appBar: AppBar(title: Text('common.error'.tr())),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('restaurant.error_load'.tr()),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadRestaurant,
                child: Text('common.retry'.tr()),
              ),
              TextButton(
                onPressed: () => context.pop(),
                child: Text('common.back'.tr()),
              ),
            ],
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

        // Group menu items by category
        final menusByCategory = <String, List<MenuItemModel>>{};
        for (final item in menus) {
          final cat = (item.category ?? '').trim();
          menusByCategory.putIfAbsent(cat, () => []).add(item);
        }
        final categoryEntries = [
          ...menusByCategory.entries.where((e) => e.key.isNotEmpty),
          if (menusByCategory.containsKey(''))
            MapEntry('', menusByCategory['']!),
        ];

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(name,
                      style: TextStyle(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                              color: Colors.black.withValues(alpha: 0.8),
                              blurRadius: 4)
                        ],
                      )),
                  background: AppNetworkImage(
                    url: restaurant.coverImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                    fallbackAsset:
                        'assets/images/restaurant_placeholder.jpg',
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(cuisine,
                              style: Theme.of(context).textTheme.titleMedium),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 16, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(rating,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 20,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text('restaurant.delivery_in_min'
                              .tr(args: [minTime])),
                          const Spacer(),
                          Icon(Icons.delivery_dining,
                              size: 20,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text(deliveryFee > 0
                              ? '${deliveryFee.toStringAsFixed(0)} FCFA'
                              : 'restaurant.variable_fee'.tr()),
                        ],
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(description,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                      const Divider(height: 32),
                      Text(
                        'restaurant.menu'.tr(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              if (menus.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Text('restaurant.no_items'.tr(),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)),
                    ),
                  ),
                )
              else
                _buildMenuSliver(context, categoryEntries, widget.restaurantId,
                    deliveryFee),
            ],
          ),
          bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              if (cartState.itemCount == 0) return const SizedBox.shrink();
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () => context.push('/client/cart'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                        '${'restaurant.view_cart'.tr()} (${cartState.itemCount})'),
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
  ) {
    // Flatten category headers (String) and items (MenuItemModel) into one list
    final rows = <Object>[];
    for (final entry in categoryEntries) {
      if (entry.key.isNotEmpty) rows.add(entry.key);
      rows.addAll(entry.value);
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final row = rows[index];
          if (row is String) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                row,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            );
          }
          final item = row as MenuItemModel;
          final hasVariations = item.variations.isNotEmpty;

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppNetworkImage(
                url: item.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                fallbackAsset: 'assets/images/restaurant_placeholder.jpg',
              ),
            ),
            title: Text(item.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((item.description ?? '').isNotEmpty) Text(item.description!),
                Text('${item.price.toStringAsFixed(0)} FCFA',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            isThreeLine: (item.description ?? '').isNotEmpty,
            trailing: IconButton(
              icon: const Icon(Icons.add_circle),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (hasVariations) {
                  _showItemDetailModal(context, item, restaurantId, deliveryFee);
                } else {
                  _addToCartWithConfirmation(
                    context: context,
                    restaurantId: restaurantId,
                    item: item,
                    deliveryFee: deliveryFee,
                  );
                }
              },
            ),
            onTap: () =>
                _showItemDetailModal(context, item, restaurantId, deliveryFee),
          );
        },
        childCount: rows.length,
      ),
    );
  }

  /// Shows a confirmation dialog if the cart has items from a different restaurant.
  Future<bool> _confirmClearCart(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('cart.clear_confirm_title'.tr()),
        content: Text('cart.clear_confirm_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('common.cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'common.yes'.tr(),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error),
            ),
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
    if (cartCubit.state.wouldClearCart(restaurantId)) {
      final confirmed = await _confirmClearCart(context);
      if (!confirmed) return;
      await cartCubit.clearCart();
    }

    final displayName =
        variation != null ? '${item.name} ($variation)' : item.name;

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
          duration: const Duration(seconds: 1),
          action: SnackBarAction(
            label: 'restaurant.view_cart'.tr(),
            onPressed: () => context.push('/client/cart'),
          ),
        ),
      );
    }
  }

  /// Bottom sheet for item detail with description, photo, and add to cart.
  void _showItemDetailModal(
    BuildContext context,
    MenuItemModel item,
    String restaurantId,
    double deliveryFee,
  ) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                child: AppNetworkImage(
                  url: item.image,
                  height: item.image != null ? 200 : 120,
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
                    Text(item.name,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('${item.price.toStringAsFixed(0)} FCFA',
                        style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    if ((item.description ?? '').isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(item.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                    ],
                    if (item.variations.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('restaurant.choose_variation'.tr(),
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...item.variations.map((v) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(v.name),
                            subtitle: v.price > 0
                                ? Text('+${v.price.toStringAsFixed(0)} FCFA')
                                : null,
                            trailing: ElevatedButton(
                              onPressed: () {
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
                              child: Text('restaurant.add_to_cart'.tr()),
                            ),
                          )),
                    ],
                    const SizedBox(height: 24),
                    if (item.variations.isEmpty)
                      SizedBox(
                        width: double.infinity,
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
                          icon: const Icon(Icons.add_shopping_cart),
                          label: Text('restaurant.add_to_cart'.tr()),
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14)),
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
