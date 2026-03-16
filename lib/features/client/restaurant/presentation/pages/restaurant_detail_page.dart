import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chopper/chopper.dart';
import '../../../../../core/di/injection.dart';
import '../../../home/data/datasources/restaurant_service.dart';

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
            appBar: AppBar(title: const Text('Erreur')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Impossible de charger le restaurant'),
                  TextButton(onPressed: () => context.pop(), child: const Text('Retour'))
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
                          Text('Livraison en $minTime min'),
                          const Spacer(),
                          Icon(Icons.delivery_dining, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          const SizedBox(width: 8),
                          const Text('Frais variables'), // Mapbox calc
                        ],
                      ),
                      const Divider(height: 32),
                      Text('Catégories & Menus', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              menus.isEmpty ? 
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text('Aucun menu disponible pour le moment.', 
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))
                  )
                )
              ) :
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = menus[index];
                    final itemName = item['name'] ?? 'Menu $index';
                    final itemDesc = item['description'] ?? 'Délicieux menu';
                    final itemPrice = item['price']?.toString() ?? '0';
                    final itemImage = item['image'] ?? 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=300&auto=format&fit=crop';
                    
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(itemImage),
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                      title: Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('$itemDesc\n$itemPrice FCFA'),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ajouté au panier !'), duration: Duration(seconds: 1)),
                          );
                        },
                      ),
                      onTap: () {},
                    );
                  },
                  childCount: menus.length,
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  context.push('/cart');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Voir le panier'),
              ),
            ),
          ),
        );
      }
    );
  }
}
