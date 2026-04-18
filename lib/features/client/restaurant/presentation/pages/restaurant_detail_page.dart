import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../cart/models/cart_item.dart';
import '../../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../../../../../core/di/injection.dart';
import '../../../../../../../core/network/services/order_service.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const RestaurantDetailPage({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  List<dynamic> _categories = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    try {
      // Use RestaurantService to fetch menu
      final service = getIt<OrderService>();
      // GET /restaurants/:id/menu — via RestaurantService
      setState(() {
        _loading = false;
        _categories = [];
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartBloc>().state;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.restaurantName,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              background: CachedNetworkImage(
                imageUrl: '',
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  color: theme.colorScheme.primaryContainer,
                  child: Icon(Icons.restaurant,
                      size: 64,
                      color: theme.colorScheme.primary),
                ),
              ),
            ),
            actions: [
              if (cart.itemCount > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Badge(
                    label: Text('${cart.itemCount}'),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () => context.push('/cart'),
                    ),
                  ),
                ),
            ],
          ),
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 8),
                    Text(_error!),
                    TextButton(
                      onPressed: _loadMenu,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            )
          else if (_categories.isEmpty)
            SliverFillRemaining(
              child: _DemoMenuSection(
                restaurantId: widget.restaurantId,
                onAddToCart: (item) {
                  context.read<CartBloc>().add(AddToCart(item));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} ajouté au panier'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _CategorySection(
                  category: _categories[i],
                  restaurantId: widget.restaurantId,
                  onAddToCart: (item) {
                    context.read<CartBloc>().add(AddToCart(item));
                  },
                ),
                childCount: _categories.length,
              ),
            ),
        ],
      ),
      bottomNavigationBar: cart.itemCount > 0
          ? _CartBottomBar(
              cart: cart,
              onCheckout: () => context.push('/cart'),
            )
          : null,
    );
  }
}

class _DemoMenuSection extends StatelessWidget {
  final String restaurantId;
  final void Function(CartItem) onAddToCart;

  const _DemoMenuSection(
      {required this.restaurantId, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final demoItems = [
      {'name': 'Poulet DG', 'price': 3500.0, 'desc': 'Poulet avec légumes'},
      {'name': 'Ndolé', 'price': 2500.0, 'desc': 'Plat traditionnel camerounais'},
      {'name': 'Eru', 'price': 2000.0, 'desc': 'Légumes avec viande'},
      {'name': 'Poisson braisé', 'price': 4000.0, 'desc': 'Poisson grillé avec plantain'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: demoItems.length,
      itemBuilder: (context, i) {
        final item = demoItems[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Text(item['name'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['desc'] as String),
                const SizedBox(height: 4),
                Text(
                  '${(item['price'] as double).toStringAsFixed(0)} XAF',
                  style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add_circle),
              color: theme.colorScheme.primary,
              onPressed: () => onAddToCart(CartItem(
                itemId: 'demo_$i',
                restaurantId: restaurantId,
                name: item['name'] as String,
                price: item['price'] as double,
              )),
            ),
          ),
        );
      },
    );
  }
}

class _CategorySection extends StatelessWidget {
  final Map<String, dynamic> category;
  final String restaurantId;
  final void Function(CartItem) onAddToCart;

  const _CategorySection({
    required this.category,
    required this.restaurantId,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final items = (category['items'] as List?) ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(
            category['name'] as String? ?? '',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ...items.map((item) => _MenuItemTile(
              item: item as Map<String, dynamic>,
              restaurantId: restaurantId,
              onAdd: onAddToCart,
            )),
      ],
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final String restaurantId;
  final void Function(CartItem) onAdd;

  const _MenuItemTile(
      {required this.item, required this.restaurantId, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price =
        ((item['price'] as num?) ?? 0).toDouble();
    return ListTile(
      title: Text(item['name'] as String? ?? ''),
      subtitle: Text(item['description'] as String? ?? ''),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${price.toStringAsFixed(0)} XAF',
            style: TextStyle(color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.add_circle),
            color: theme.colorScheme.primary,
            onPressed: () => onAdd(CartItem(
              itemId: item['_id'] as String? ?? '',
              restaurantId: restaurantId,
              name: item['name'] as String? ?? '',
              price: price,
              imageUrl: item['image'] as String?,
            )),
          ),
        ],
      ),
    );
  }
}

class _CartBottomBar extends StatelessWidget {
  final CartState cart;
  final VoidCallback onCheckout;

  const _CartBottomBar({required this.cart, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: onCheckout,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Badge(
                label: Text('${cart.itemCount}'),
                child: const Icon(Icons.shopping_cart),
              ),
              const Text('Voir le panier',
                  style: TextStyle(fontSize: 16)),
              Text(
                '${cart.subtotal.toStringAsFixed(0)} XAF',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
