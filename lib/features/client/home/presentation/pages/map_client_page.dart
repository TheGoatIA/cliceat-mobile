import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/config/app_constants.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/models/restaurant_model.dart';
import '../../../../../core/repositories/restaurant_repository.dart';
import '../../../../../shared/widgets/app_network_image.dart';

class MapClientPage extends StatefulWidget {
  const MapClientPage({super.key});

  @override
  State<MapClientPage> createState() => _MapClientPageState();
}

class _MapClientPageState extends State<MapClientPage> {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _annotationManager;
  List<RestaurantModel> _restaurants = [];
  bool _loading = true;
  Uint8List? _markerIcon;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    final result = await getIt<RestaurantRepository>().getRestaurants(
      city: AppConstants.defaultCity,
    );
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loading = false),
      (restaurants) {
        setState(() {
          _restaurants = restaurants;
          _loading = false;
        });
        if (_annotationManager != null) {
          _addRestaurantMarkers();
        }
      },
    );
  }

  /// Renders a red pin icon as a PNG Uint8List using Canvas.
  Future<Uint8List> _buildMarkerIcon() async {
    const size = 48.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromLTWH(0, 0, size, size));

    // Outer red circle
    final paintOuter = Paint()..color = const Color(0xFFCC0000);
    canvas.drawCircle(const Offset(24, 24), 20, paintOuter);

    // White ring
    final paintRing = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(const Offset(24, 24), 20, paintRing);

    // Inner dot
    final paintInner = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(24, 24), 7, paintInner);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  Future<void> _onMapCreated(MapboxMap map) async {
    _mapboxMap = map;
    _markerIcon = await _buildMarkerIcon();
    _annotationManager =
        await map.annotations.createPointAnnotationManager();
    _annotationManager!
        .addOnPointAnnotationClickListener(_RestaurantAnnotationListener(
      restaurants: _restaurants,
      context: context,
    ));
    if (_restaurants.isNotEmpty) {
      await _addRestaurantMarkers();
    }
  }

  Future<void> _addRestaurantMarkers() async {
    if (_annotationManager == null || _markerIcon == null) return;
    await _annotationManager!.deleteAll();

    for (final r in _restaurants) {
      if (r.lat == 0.0 && r.lng == 0.0) continue;

      await _annotationManager!.create(PointAnnotationOptions(
        geometry: Point(coordinates: Position(r.lng, r.lat)),
        image: _markerIcon,
        iconSize: 0.9,
        textField: r.name,
        textSize: 10.0,
        textOffset: [0.0, 2.5],
        textColor: 0xFF222222,
        textHaloColor: 0xFFFFFFFF,
        textHaloWidth: 1.5,
      ));
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
              center: Point(coordinates: Position(
                  AppConstants.defaultLng, AppConstants.defaultLat)),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: TextField(
                readOnly: true,
                onTap: () {},
                decoration: InputDecoration(
                  hintText: 'client.search_hint'.tr(),
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_restaurants.length} restaurants',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
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
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -4)),
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
            child: Text('client.recommended'.tr(),
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _restaurants.length,
                    itemBuilder: (context, index) {
                      final r = _restaurants[index];
                      return GestureDetector(
                        onTap: () => context.push('/restaurant/${r.id}'),
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4),
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.vertical(
                                        top: Radius.circular(12)),
                                child: AppNetworkImage(
                                  url: r.coverImage,
                                  height: 70,
                                  width: 140,
                                  fit: BoxFit.cover,
                                  fallbackAsset:
                                      'assets/images/restaurant_placeholder.jpg',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(r.name,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                                fontWeight:
                                                    FontWeight.bold),
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow.ellipsis),
                                    if ((r.cuisineType ?? '').isNotEmpty)
                                      Text(r.cuisineType!,
                                          style: theme
                                              .textTheme.bodySmall
                                              ?.copyWith(
                                                  color: theme.colorScheme
                                                      .onSurfaceVariant),
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis),
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

/// Handles clicks on restaurant pins on the map.
class _RestaurantAnnotationListener
    extends OnPointAnnotationClickListener {
  final List<RestaurantModel> restaurants;
  final BuildContext context;

  _RestaurantAnnotationListener({
    required this.restaurants,
    required this.context,
  });

  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    final coords = annotation.geometry.coordinates;
    final coordLat = (coords[1] as num).toDouble();
    final coordLng = (coords[0] as num).toDouble();

    for (final r in restaurants) {
      if ((coordLat - r.lat).abs() < 0.0001 &&
          (coordLng - r.lng).abs() < 0.0001) {
        if (r.id.isNotEmpty && context.mounted) {
          context.push('/restaurant/${r.id}');
        }
        return true;
      }
    }
    return true;
  }
}
