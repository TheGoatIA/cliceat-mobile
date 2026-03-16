import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/config/app_constants.dart';
import '../../../../../core/di/injection.dart';
import '../../data/datasources/restaurant_service.dart';

class MapClientPage extends StatefulWidget {
  const MapClientPage({super.key});

  @override
  State<MapClientPage> createState() => _MapClientPageState();
}

class _MapClientPageState extends State<MapClientPage> {
  MapboxMap? _mapboxMap;
  List<Map<String, dynamic>> _restaurants = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    try {
      final res = await getIt<RestaurantService>().getRestaurants(AppConstants.defaultCity, null, null);
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        List<dynamic> data = [];
        if (body is Map && body.containsKey('data')) {
          data = body['data'] as List<dynamic>? ?? [];
        } else if (body is List) {
          data = body;
        }
        setState(() {
          _restaurants = data.cast<Map<String, dynamic>>();
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _centerOnUser() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      final pos = await Geolocator.getCurrentPosition();
      await _mapboxMap?.setCamera(CameraOptions(
        center: Point(coordinates: Position(pos.longitude, pos.latitude)),
        zoom: 14.0,
      ));
    } catch (_) {}
  }

  void _onMapCreated(MapboxMap map) {
    _mapboxMap = map;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey('clientMapWidget'),
            onMapCreated: _onMapCreated,
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(AppConstants.defaultLng, AppConstants.defaultLat)),
              zoom: AppConstants.defaultZoom,
            ),
          ),

          // Top search bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: TextField(
                readOnly: true,
                onTap: () {},
                decoration: InputDecoration(
                  hintText: 'client.search_hint'.tr(),
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Restaurant count pill
          if (!_loading)
            Positioned(
              top: MediaQuery.of(context).padding.top + 72,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_restaurants.length} restaurants',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),

          // Center on user button
          Positioned(
            bottom: 200,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: 'locateMe',
              onPressed: _centerOnUser,
              child: const Icon(Icons.my_location),
            ),
          ),

          // Bottom sheet with restaurant list
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildRestaurantBottomSheet(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantBottomSheet(ThemeData theme) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('client.recommended'.tr(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _restaurants.length,
                    itemBuilder: (context, index) {
                      final r = _restaurants[index];
                      final id = r['_id']?.toString() ?? r['id']?.toString() ?? '$index';
                      final name = r['name'] as String? ?? 'Restaurant';
                      final cuisine = r['cuisineType'] as String? ?? '';
                      final image = r['coverImage'] as String?;
                      return GestureDetector(
                        onTap: () => context.push('/restaurant/$id'),
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: image != null
                                    ? Image.network(image, height: 70, width: 140, fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(height: 70, color: theme.colorScheme.surfaceContainerHighest))
                                    : Container(height: 70, color: theme.colorScheme.surfaceContainerHighest,
                                        child: const Icon(Icons.restaurant, size: 32)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    if (cuisine.isNotEmpty)
                                      Text(cuisine, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
