import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:chopper/chopper.dart';
import '../../../../../core/config/app_constants.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/services/coupon_service.dart';
import '../../data/datasources/restaurant_service.dart';

class HomeClientPage extends StatelessWidget {
  const HomeClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'client.deliver_to'.tr(),
              style: theme.textTheme.bodySmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppConstants.defaultCity,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 20),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: RefreshIndicator(
        color: theme.colorScheme.primary,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchBar(context),
              _buildPromotionsCarousel(context),
              _buildCategories(context),
              _buildRecommendedRestaurants(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'client.search_hint'.tr(),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.tune),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).cardTheme.color,
        ),
      ),
    );
  }
  
  Widget _buildPromotionsCarousel(BuildContext context) {
    return FutureBuilder<Response<Map<String, dynamic>>>(
      future: getIt<CouponService>().getBanners(),
      builder: (context, snapshot) {
        List<Map<String, dynamic>> banners = [];
        if (snapshot.hasData && snapshot.data!.isSuccessful && snapshot.data!.body != null) {
          final data = snapshot.data!.body!['data'];
          if (data is List) {
            banners = data.map((e) => e as Map<String, dynamic>).toList();
          }
        }
        if (banners.isEmpty) {
          banners = [
            {
              'title': 'Livraison Gratuite',
              'subtitle': 'Sur votre 1ère commande',
              'image': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1000&auto=format&fit=crop',
            }
          ];
        }
        return Container(
          height: 160,
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: PageView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              final imageUrl = banner['imageUrl'] as String? ??
                  banner['image'] as String? ??
                  'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1000&auto=format&fit=crop';
              final title = banner['title'] as String? ?? '';
              final subtitle = banner['subtitle'] as String? ?? banner['description'] as String? ?? '';
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (title.isNotEmpty)
                          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        if (subtitle.isNotEmpty)
                          Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = ['Burger', 'Pizza', 'Ndolé', 'Poulet', 'Salades'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'client.categories'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedRestaurants(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          future: getIt<RestaurantService>().getFeaturedRestaurants(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()));
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data?.body == null) {
              return Center(child: Padding(padding: const EdgeInsets.all(32.0), child: Text('common.error'.tr())));
            }
            
            final responseBody = snapshot.data!.body;
            List<dynamic> restaurants = [];
            if (responseBody is Map && responseBody.containsKey('data')) {
              restaurants = responseBody['data'] as List<dynamic>;
            } else if (responseBody is List) {
              restaurants = responseBody;
            }

            if (restaurants.isEmpty) {
               return Center(child: Padding(padding: const EdgeInsets.all(32.0), child: Text('restaurant.none_available'.tr())));
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
                                Text('restaurant.variable_fee'.tr(), style: Theme.of(context).textTheme.bodySmall),
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
        ),
      ],
    );
  }
}
