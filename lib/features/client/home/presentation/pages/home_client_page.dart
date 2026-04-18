import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import '../../../../data/datasources/restaurant_service.dart';

class HomeClientPage extends StatefulWidget {
  const HomeClientPage({super.key});

  @override
  State<HomeClientPage> createState() => _HomeClientPageState();
}

class _HomeClientPageState extends State<HomeClientPage> {
  late final RestaurantService _service;
  List<dynamic> _restaurants = [];
  List<dynamic> _featured = [];
  bool _loading = true;
  String? _error;
  final _searchCtrl = TextEditingController();
  final _pageCtrl = PageController();
  int _bannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _service = GetIt.instance<RestaurantService>();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _service.getFeaturedRestaurants(),
        _service.getRestaurants('douala', null, null, null, true),
      ]);
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (results[0].isSuccessful) {
          final d = results[0].body as Map<String, dynamic>?;
          _featured = (d?['data'] as List?) ?? [];
        }
        if (results[1].isSuccessful) {
          final d = results[1].body as Map<String, dynamic>?;
          _restaurants = (d?['data'] as List?) ?? [];
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Impossible de charger les restaurants.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: _buildAppBar(theme),
      body: RefreshIndicator(
        color: theme.colorScheme.primary,
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildError(theme)
                : _buildBody(theme),
      ),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Livrer à', style: theme.textTheme.bodySmall),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Douala, Akwa',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildError(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(_error!, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            onPressed: _load,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearch(theme),
          _buildBanner(theme),
          _buildCategories(theme),
          _buildRestaurantSection(theme),
        ],
      ),
    );
  }

  Widget _buildSearch(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        controller: _searchCtrl,
        readOnly: true,
        onTap: () {},
        decoration: InputDecoration(
          hintText: 'client.search_hint'.tr(),
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tune_rounded,
                color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(ThemeData theme) {
    final items = _featured.isNotEmpty
        ? _featured
        : List.generate(3, (i) => null);

    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _pageCtrl,
            itemCount: items.length,
            onPageChanged: (i) => setState(() => _bannerIndex = i),
            itemBuilder: (_, i) {
              final r = items[i] as Map<String, dynamic>?;
              return _BannerCard(restaurant: r);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(items.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _bannerIndex == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _bannerIndex == i
                    ? theme.colorScheme.primary
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategories(ThemeData theme) {
    final cats = [
      {'icon': Icons.lunch_dining_rounded, 'label': 'Burger'},
      {'icon': Icons.local_pizza_rounded, 'label': 'Pizza'},
      {'icon': Icons.rice_bowl_rounded, 'label': 'Ndolé'},
      {'icon': Icons.set_meal_rounded, 'label': 'Poulet'},
      {'icon': Icons.eco_rounded, 'label': 'Salade'},
      {'icon': Icons.local_drink_rounded, 'label': 'Boissons'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text('client.categories'.tr(),
              style: theme.textTheme.titleLarge),
        ),
        SizedBox(
          height: 96,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: cats.length,
            itemBuilder: (_, i) {
              final c = cats[i];
              return GestureDetector(
                onTap: () {},
                child: Container(
                  width: 76,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          c['icon'] as IconData,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        c['label'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600),
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
      ],
    );
  }

  Widget _buildRestaurantSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('client.recommended'.tr(),
                  style: theme.textTheme.titleLarge),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Voir tout',
                  style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        if (_restaurants.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                'Aucun restaurant disponible pour le moment.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: _restaurants.length,
            itemBuilder: (_, i) =>
                _RestaurantCard(data: _restaurants[i] as Map<String, dynamic>),
          ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  final Map<String, dynamic>? restaurant;
  const _BannerCard({this.restaurant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = (restaurant?['coverImage'] as String?) ?? '';
    final name = (restaurant?['name'] as String?) ?? 'Offre spéciale';
    final promo = restaurant != null
        ? 'Livraison gratuite sur votre 1ère commande'
        : 'Découvrez nos restaurants partenaires';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.primary.withValues(alpha: 0.15),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl.isNotEmpty)
            Image.network(imageUrl, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox())
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.local_fire_department_rounded,
                  size: 80, color: Colors.white30),
            ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.65),
                  Colors.transparent
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(promo,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _RestaurantCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = (data['name'] as String?) ?? 'Restaurant';
    final cover = (data['coverImage'] as String?) ?? '';
    final rating = ((data['rating'] as num?)?.toDouble() ?? 0.0);
    final deliveryFee =
        ((data['deliveryFee'] as num?)?.toInt() ?? 0);
    final cuisine =
        ((data['cuisine'] as List?)?.join(' • ')) ?? '';
    final isOpen = (data['isOpen'] as bool?) ?? true;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: cover.isNotEmpty
                      ? Image.network(cover, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _placeholder(theme))
                      : _placeholder(theme),
                ),
                if (!isOpen)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black54,
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Fermé',
                            style:
                                TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                if (rating > 0)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 14, color: Colors.white),
                          const SizedBox(width: 3),
                          Text(rating.toStringAsFixed(1),
                              style: theme.textTheme.labelLarge
                                  ?.copyWith(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: theme.textTheme.titleLarge),
                  if (cuisine.isNotEmpty) ...
                    [
                      const SizedBox(height: 4),
                      Text(cuisine,
                          style: theme.textTheme.bodySmall),
                    ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.delivery_dining_rounded,
                          size: 16,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5)),
                      const SizedBox(width: 4),
                      Text(
                        deliveryFee == 0
                            ? 'Livraison gratuite'
                            : '$deliveryFee FCFA',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.schedule_rounded,
                          size: 16,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5)),
                      const SizedBox(width: 4),
                      Text('25-35 min',
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.primary.withValues(alpha: 0.08),
      child: Center(
        child: Icon(Icons.restaurant_menu_rounded,
            size: 48,
            color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
    );
  }
}
