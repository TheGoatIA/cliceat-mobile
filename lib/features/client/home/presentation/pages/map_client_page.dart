<<<<<<< HEAD
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' hide Position;
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../../../core/config/app_constants.dart';
import 'package:cliceat_app/di/injection.dart';
import 'package:cliceat_app/features/client/home/data/models/restaurant_model.dart';
import 'package:cliceat_app/features/client/home/data/repositories/restaurant_repository.dart';
import '../../../../../shared/widgets/app_network_image.dart';

// ─── Source / Layer IDs ───────────────────────────────────────────────────────

const _kSourceId = 'restaurant-source';
const _kClusterCircleLayerId = 'cluster-circles';
const _kClusterCountLayerId = 'cluster-count';
const _kUnclusteredLayerId = 'unclustered-points';
const _kMarkerImageId = 'restaurant-marker';
=======
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:cliceat_app/core/services/location_service.dart';
import 'package:cliceat_app/core/di/injection.dart';
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa

class MapClientPage extends StatefulWidget {
  const MapClientPage({super.key});

  @override
  State<MapClientPage> createState() => _MapClientPageState();
}

class _MapClientPageState extends State<MapClientPage> {
<<<<<<< HEAD
  MapboxMap? _mapboxMap;
  List<RestaurantModel> _restaurants = [];
  bool _loading = true;
=======
  MapboxMap? mapboxMap;
  geo.Position? currentPosition;
  bool isLoading = true;
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _loadRestaurants();
  }

  // ─── Data ─────────────────────────────────────────────────────────────────

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
        if (_mapboxMap != null) {
          _addClusteredSource();
        }
      },
    );
  }

  // ─── Map creation ─────────────────────────────────────────────────────────

  Future<void> _onMapCreated(MapboxMap map) async {
    _mapboxMap = map;
    // Écouter les clics sur les features
    map.setOnMapTapListener(_onMapTap);
    if (_restaurants.isNotEmpty) {
      await _addClusteredSource();
    }
  }

  // ─── Clustering via GeoJSON source ────────────────────────────────────────

  Future<void> _addClusteredSource() async {
    final style = _mapboxMap?.style;
    if (style == null) return;

    // Supprimer les layers et la source existants si présents
    for (final id in [
      _kClusterCircleLayerId,
      _kClusterCountLayerId,
      _kUnclusteredLayerId,
    ]) {
      try {
        await style.removeStyleLayer(id);
      } catch (_) {}
    }
    try {
      await style.removeStyleSource(_kSourceId);
    } catch (_) {}

    // Ajouter l'icône de marqueur individuel
    final markerBytes = await _buildMarkerIcon();
    try {
      await style.addStyleImage(
        _kMarkerImageId,
        1.0,
        MbxImage(
          width: 48,
          height: 48,
          data: markerBytes,
        ),
        false,
        [],
        [],
        null,
      );
    } catch (_) {}

    // GeoJSON source avec clustering activé
    final features = _restaurants
        .where((r) => r.lat != 0.0 || r.lng != 0.0)
        .map((r) => {
              'type': 'Feature',
              'geometry': {
                'type': 'Point',
                'coordinates': [r.lng, r.lat],
              },
              'properties': {
                'id': r.id,
                'name': r.name,
              },
            })
        .toList();

    final geojson = jsonEncode({
      'type': 'FeatureCollection',
      'features': features,
    });

    await style.addSource(GeoJsonSource(
      id: _kSourceId,
      data: geojson,
      cluster: true,
      clusterMaxZoom: 14,
      clusterRadius: 50,
    ));

    // ── Layer 1 : cercles de cluster ────────────────────────────────────────
    await style.addLayer(CircleLayer(
      id: _kClusterCircleLayerId,
      sourceId: _kSourceId,
      filter: ['has', 'point_count'],
      circleColor: const int.fromEnvironment(
        'circleColor',
        defaultValue: 0xFFE53935, // rouge ClicEat
      ),
      circleRadius: 22.0,
      circleOpacity: 0.9,
      circleStrokeWidth: 2.0,
      circleStrokeColor: 0xFFFFFFFF,
    ));

    // ── Layer 2 : nombre dans le cluster ────────────────────────────────────
    await style.addLayer(SymbolLayer(
      id: _kClusterCountLayerId,
      sourceId: _kSourceId,
      filter: ['has', 'point_count'],
      textField: '{point_count_abbreviated}',
      textSize: 14.0,
      textColor: 0xFFFFFFFF,
      textIgnorePlacement: true,
      textAllowOverlap: true,
    ));

    // ── Layer 3 : marqueurs individuels ─────────────────────────────────────
    await style.addLayer(SymbolLayer(
      id: _kUnclusteredLayerId,
      sourceId: _kSourceId,
      filter: ['!', ['has', 'point_count']],
      iconImage: _kMarkerImageId,
      iconSize: 0.9,
      iconAllowOverlap: true,
      textFieldExpression: ['get', 'name'],
      textSize: 10.0,
      textOffset: [0.0, 2.5],
      textAnchor: TextAnchor.TOP,
      textColor: 0xFF222222,
      textHaloColor: 0xFFFFFFFF,
      textHaloWidth: 1.5,
      textOptional: true,
    ));
  }

  // ─── Map click handler ────────────────────────────────────────────────────

  Future<void> _onMapTap(MapContentGestureContext gestureContext) async {
    if (_mapboxMap == null) return;

    // Vérifier si l'utilisateur a tapé sur un cluster → zoomer
    final clusterFeatures = await _mapboxMap!.queryRenderedFeatures(
      RenderedQueryGeometry.fromScreenCoordinate(
        gestureContext.touchPosition,
      ),
      RenderedQueryOptions(layerIds: [_kClusterCircleLayerId]),
    );

    if (clusterFeatures.isNotEmpty) {
      final coords = clusterFeatures.first?.queriedFeature.feature['geometry']
          as Map<String, dynamic>?;
      final coordinates =
          coords?['coordinates'] as List<dynamic>?;
      if (coordinates != null && coordinates.length >= 2) {
        final lng = (coordinates[0] as num).toDouble();
        final lat = (coordinates[1] as num).toDouble();
        final currentZoom =
            await _mapboxMap!.getCameraState().then((s) => s.zoom);
        await _mapboxMap!.flyTo(
          CameraOptions(
            center: Point(coordinates: Position(lng, lat)),
            zoom: (currentZoom + 2).clamp(0, 22),
          ),
          MapAnimationOptions(duration: 600),
        );
      }
      return;
    }

    // Vérifier si l'utilisateur a tapé sur un marqueur individuel
    final markerFeatures = await _mapboxMap!.queryRenderedFeatures(
      RenderedQueryGeometry.fromScreenCoordinate(
        gestureContext.touchPosition,
      ),
      RenderedQueryOptions(layerIds: [_kUnclusteredLayerId]),
    );

    if (markerFeatures.isNotEmpty && mounted) {
      final props = markerFeatures.first?.queriedFeature.feature['properties']
          as Map<String, dynamic>?;
      final id = props?['id'] as String? ?? '';
      if (id.isNotEmpty) {
        context.push('/restaurant/$id');
      }
    }
  }

  // ─── Marker icon builder ─────────────────────────────────────────────────

  Future<Uint8List> _buildMarkerIcon() async {
    const size = 48.0;
    final recorder = ui.PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromLTWH(0, 0, size, size));

    final paintOuter = Paint()..color = const Color(0xFFCC0000);
    canvas.drawCircle(const Offset(24, 24), 20, paintOuter);

    final paintRing = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(const Offset(24, 24), 20, paintRing);

    final paintInner = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(24, 24), 7, paintInner);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final data =
        await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  // ─── UI ───────────────────────────────────────────────────────────────────

  Future<void> _centerOnUser() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      final pos = await Geolocator.getCurrentPosition();
      await _mapboxMap?.flyTo(
        CameraOptions(
          center: Point(
              coordinates: Position(pos.longitude, pos.latitude)),
          zoom: 14.0,
        ),
        MapAnimationOptions(duration: 800),
      );
    } catch (_) {}
=======
    _initLocation();
  }

  Future<void> _initLocation() async {
    final locationService = getIt<LocationService>();
    final position = await locationService.getCurrentPosition();
    setState(() {
      currentPosition = position;
      isLoading = false;
    });
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    // Activate location puck
    mapboxMap.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
      )
    );
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey('clientMapWidget'),
            onMapCreated: _onMapCreated,
            cameraOptions: CameraOptions(
              center: Point(
                  coordinates: Position(
                      AppConstants.defaultLng, AppConstants.defaultLat)),
              zoom: AppConstants.defaultZoom,
            ),
          ),

          // Barre de recherche
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

          // Compteur restaurants
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
                  '${_restaurants.length} ${'client.restaurants'.tr()}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
            ),

          // Bouton localisation
          Positioned(
            bottom: 200,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: 'locateMe',
              onPressed: _centerOnUser,
              child: const Icon(Icons.my_location),
            ),
          ),

          // Bottom sheet liste restaurants
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
                        onTap: () =>
                            context.push('/restaurant/${r.id}'),
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
                                    if ((r.cuisineType ?? '')
                                        .isNotEmpty)
                                      Text(
                                        r.cuisineType!,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                                color: theme.colorScheme
                                                    .onSurfaceVariant),
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow.ellipsis,
                                      ),
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
=======
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: MapWidget(
        key: const ValueKey("mapWidget"),
        cameraOptions: CameraOptions(
          center: currentPosition != null 
              ? Point(coordinates: Position(currentPosition!.longitude, currentPosition!.latitude))
              : Point(coordinates: Position(9.7093, 4.0511)), // Douala par défaut
          zoom: 14.0,
        ),
        onMapCreated: _onMapCreated,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentPosition != null && mapboxMap != null) {
            mapboxMap?.setCamera(
              CameraOptions(
                center: Point(coordinates: Position(currentPosition!.longitude, currentPosition!.latitude)),
                zoom: 16.0,
              )
            );
          }
        },
        child: const Icon(Icons.my_location),
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
      ),
    );
  }
}
