import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:chopper/chopper.dart';
import '../../../../../core/config/app_constants.dart';
import '../../../../../core/di/injection.dart';
import '../../../home/data/datasources/restaurant_service.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;
  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late Future<Response> _restaurantFuture;

  @override
  void initState() {
    super.initState();
    _restaurantFuture =
        getIt<RestaurantService>().getRestaurantDetails(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
      future: _restaurantFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data?.body == null) {
          return Scaffold(
            appBar: AppBar(title: Text('common.error'.tr())),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('restaurant.error_load'.tr()),
                  TextButton(
                      onPressed: () => context.pop(),
                      child: Text('common.back'.tr()))
                ],
              ),
            ),
          );
        }

        final data = snapshot.data!.body;
        Map<String, dynamic> restaurant = {};
        if (data is Map && data.containsKey('data')) {
          restaurant = data['data'] as Map<String, dynamic>;
        } else if (data is Map) {
          restaurant = data as Map<String, dynamic>;
        }

        final name = restaurant['name'] ?? 'Restaurant';
        final cuisine = restaurant['cuisineType'] ?? 'Cuisine';
        final rating = restaurant['rating']?.toString() ?? 'N/A';
        final minTime =
            restaurant['deliveryTimeMinutes']?.toString() ?? '30';
        final image = restaurant['coverImage'] ??
            'https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=1000&auto=format&fit=crop';
        final deliveryFee =
            (restaurant['deliveryFee'] as num?)?.toDouble() ??
                AppConstants.defaultDeliveryFee;
        final description = restaurant['description'] as String? ?? '';

        // Update delivery fee in cart state (once per build cycle)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.read<CartCubit>().setDeliveryFee(deliveryFee);
          }
        });

        final List<dynamic> menus = restaurant['menus'] ?? [];

        // Group menu items by category
        final menusByCategory = <String, List<dynamic>>{};
        for (final item in menus) {
          final cat = (item as Map<String, dynamic>)['category'] as String? ?? '';
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
                  background: Image.network(
                    image,
                    fit: BoxFit.cover,
                    color: Colors.black.withValues(alpha: 0.3),
                    colorBlendMode: BlendMode.darken,
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
                      // Tabs: Menu + Avis
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              tabs: [
                                Tab(text: 'restaurant.menu'.tr()),
                                Tab(text: 'restaurant.reviews'.tr()),
                              ],
                            ),
                          ],
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
      },
    );
  }

  Widget _buildMenuSliver(
    BuildContext context,
    List<MapEntry<String, List<dynamic>>> categoryEntries,
    String restaurantId,
    double deliveryFee,
  ) {
    final rows = <dynamic>[];
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
          final item = row as Map<String, dynamic>;
          final itemName = item['name'] as String? ?? '';
          final itemDesc = item['description'] as String? ?? '';
          final itemPrice = (item['price'] as num?)?.toDouble() ?? 0.0;
          final itemImage = item['image'] as String?;
          final variations = item['variations'] as List<dynamic>? ?? [];
          final hasVariations = variations.isNotEmpty;

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                image: itemImage != null && itemImage.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(itemImage), fit: BoxFit.cover)
                    : null,
              ),
              child: (itemImage == null || itemImage.isEmpty)
                  ? Icon(Icons.fastfood,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)
                  : null,
            ),
            title: Text(itemName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (itemDesc.isNotEmpty) Text(itemDesc),
                Text('${itemPrice.toStringAsFixed(0)} FCFA',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            isThreeLine: itemDesc.isNotEmpty,
            trailing: IconButton(
              icon: const Icon(Icons.add_circle),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (hasVariations) {
                  _showItemVariantModal(context, item, restaurantId,
                      deliveryFee);
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
            onTap: () => _showItemDetailModal(context, item, restaurantId,
                deliveryFee),
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
    required Map<String, dynamic> item,
    required double deliveryFee,
    String? variation,
    String? notes,
  }) async {
    final cartCubit = context.read<CartCubit>();
    if (cartCubit.state.wouldClearCart(restaurantId)) {
      final confirmed = await _confirmClearCart(context);
      if (!confirmed) return;
      await cartCubit.clearCart();
    }

    final itemName = item['name'] as String? ?? '';
    final itemPrice = (item['price'] as num?)?.toDouble() ?? 0.0;
    final displayName =
        variation != null ? '$itemName ($variation)' : itemName;

    await cartCubit.addItem(
      restaurantId: restaurantId,
      itemId: item['_id']?.toString() ?? item['id']?.toString() ?? itemName,
      name: displayName,
      price: itemPrice,
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
    Map<String, dynamic> item,
    String restaurantId,
    double deliveryFee,
  ) {
    final theme = Theme.of(context);
    final itemName = item['name'] as String? ?? '';
    final itemDesc = item['description'] as String? ?? '';
    final itemPrice = (item['price'] as num?)?.toDouble() ?? 0.0;
    final itemImage = item['image'] as String?;
    final variations = item['variations'] as List<dynamic>? ?? [];

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
              if (itemImage != null && itemImage.isNotEmpty)
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(itemImage,
                      height: 200, fit: BoxFit.cover),
                )
              else
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24)),
                  ),
                  child: Icon(Icons.fastfood,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5)),
                ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(itemName,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('${itemPrice.toStringAsFixed(0)} FCFA',
                        style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    if (itemDesc.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(itemDesc,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                    ],
                    if (variations.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('restaurant.choose_variation'.tr(),
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...variations.map((v) {
                        final vName = v['name']?.toString() ?? v.toString();
                        final vExtra =
                            (v['extraPrice'] as num?)?.toDouble() ?? 0.0;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(vName),
                          subtitle: vExtra > 0
                              ? Text('+${vExtra.toStringAsFixed(0)} FCFA')
                              : null,
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _addToCartWithConfirmation(
                                context: context,
                                restaurantId: restaurantId,
                                item: {
                                  ...item,
                                  'price': itemPrice + vExtra,
                                },
                                deliveryFee: deliveryFee,
                                variation: vName,
                              );
                            },
                            child: Text('restaurant.add_to_cart'.tr()),
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: 24),
                    if (variations.isEmpty)
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

  /// Variant selection modal when item has variations.
  void _showItemVariantModal(
    BuildContext context,
    Map<String, dynamic> item,
    String restaurantId,
    double deliveryFee,
  ) {
    _showItemDetailModal(context, item, restaurantId, deliveryFee);
  }
}
