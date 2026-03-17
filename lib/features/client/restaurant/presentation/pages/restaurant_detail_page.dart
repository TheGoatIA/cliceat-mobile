import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:chopper/chopper.dart';
import '../../../../../core/di/injection.dart';
import '../../../home/data/datasources/restaurant_service.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';

class RestaurantDetailPage extends StatelessWidget {
  final String restaurantId;
  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
      future: getIt<RestaurantService>().getRestaurantDetails(restaurantId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data?.body == null) {
          return Scaffold(
            appBar: AppBar(title: Text('common.error'.tr())),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('restaurant.error_load'.tr()),
                  TextButton(onPressed: () => context.pop(), child: Text('common.back'.tr()))
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
        final minTime = restaurant['deliveryTimeMinutes']?.toString() ?? '30';
        final image = restaurant['coverImage'] ?? 'https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=1000&auto=format&fit=crop';
        
        List<dynamic> menus = restaurant['menus'] ?? [];

        // Group menu items by category (falls back to a single default group)
        final menusByCategory = <String, List<dynamic>>{};
        for (final item in menus) {
          final cat = (item as Map<String, dynamic>)['category'] as String? ?? '';
          menusByCategory.putIfAbsent(cat, () => []).add(item);
        }
        // Entries: named categories first, then the unnamed bucket
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
                        shadows: [Shadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 4)],
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
                          Text(cuisine, style: Theme.of(context).textTheme.titleMedium),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(rating, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text('restaurant.delivery_in_min'.tr(args: [minTime])),
                          const Spacer(),
                          Icon(Icons.delivery_dining, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text('restaurant.variable_fee'.tr()),
                        ],
                      ),
                      const Divider(height: 32),
                      Text('restaurant.menu'.tr(), style: Theme.of(context).textTheme.titleLarge),
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
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ),
                  ),
                )
              else
                _buildMenuSliver(context, categoryEntries, restaurantId),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('${'restaurant.view_cart'.tr()} (${cartState.itemCount})'),
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }

  Widget _buildMenuSliver(
    BuildContext context,
    List<MapEntry<String, List<dynamic>>> categoryEntries,
    String restaurantId,
  ) {
    // Pre-build a flat list of row models (header strings or item maps)
    final rows = <dynamic>[];
    for (final entry in categoryEntries) {
      if (entry.key.isNotEmpty) rows.add(entry.key); // category header
      rows.addAll(entry.value);                       // menu items
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final row = rows[index];
          if (row is String) {
            // Category header
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
          final itemPrice = item['price']?.toString() ?? '0';
          final itemImage = item['image'] as String?;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                image: itemImage != null && itemImage.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(itemImage),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: (itemImage == null || itemImage.isEmpty)
                  ? Icon(Icons.fastfood, color: Theme.of(context).colorScheme.onSurfaceVariant)
                  : null,
            ),
            title: Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('$itemDesc\n$itemPrice FCFA'),
            isThreeLine: itemDesc.isNotEmpty,
            trailing: IconButton(
              icon: const Icon(Icons.add_circle),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                final price = (item['price'] as num?)?.toDouble() ?? 0.0;
                context.read<CartCubit>().addItem(
                  restaurantId: restaurantId,
                  itemId: item['_id']?.toString() ?? item['id']?.toString() ?? itemName,
                  name: itemName,
                  price: price,
                );
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
              },
            ),
            onTap: () {},
          );
        },
        childCount: rows.length,
      ),
    );
  }
}
