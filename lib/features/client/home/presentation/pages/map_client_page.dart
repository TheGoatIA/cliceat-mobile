import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:geolocator/geolocator.dart' hide Position;
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../../../core/config/app_constants.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/home/data/models/restaurant_model.dart';
import 'package:cliceat_app/features/client/home/data/repositories/restaurant_repository.dart';
import '../../../../../shared/widgets/app_network_image.dart';

// ─── Source / Layer IDs ───────────────────────────────────────────────────────

const _kSourceId = 'restaurant-source';
const _kClusterCircleLayerId = 'cluster-circles';
const _kClusterCountLayerId = 'cluster-count';
const _kUnclusteredLayerId = 'unclustered-points';
const _kMarkerImageId = 'restaurant-marker';

class MapClientPage extends StatefulWidget {
  const MapClientPage({super.key});

  @override
  State<MapClientPage> createState() => _MapClientPageState();
}

class _MapClientPageState extends State<MapClientPage> {
  MapboxMap? _mapboxMap;
  List<RestaurantModel> _restaurants = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  // ─── Data ─────────────────────────────────────────────────────────────────

  Future<void> _loadRestaurants() async {
    final result = await getIt<RestaurantRepository>().getRestaurants(
      city: AppConstants.defaultCity,
    );
    if (!mounted) return;
    result.fold((_) => setState(() => _loading = false), (restaurants) {
      setState(() {
        _restaurants = restaurants;
        _loading = false;
      });
      if (_mapboxMap != null) {
        _addClusteredSource();
      }
    });
  }

  // ─── Map creation ─────────────────────────────────────────────────────────

  Future<void> _onMapCreated(MapboxMap map) async {
    _mapboxMap = map;
    // Écouter les clics sur les features
    map.setOnMapTapListener(_onMapTap);
    // Désactiver l'échelle et les attributions encombrantes si besoin
    map.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    map.compass.updateSettings(CompassSettings(enabled: false));

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
        MbxImage(width: 32, height: 32, data: markerBytes),
        false,
        [],
        [],
        null,
      );
    } catch (_) {}

    // GeoJSON source avec clustering activé
    final features = _restaurants
        .where((r) => r.lat != 0.0 || r.lng != 0.0)
        .map(
          (r) => {
            'type': 'Feature',
            'geometry': {
              'type': 'Point',
              'coordinates': [r.lng, r.lat],
            },
            'properties': {'id': r.id, 'name': r.name},
          },
        )
        .toList();

    final geojson = jsonEncode({
      'type': 'FeatureCollection',
      'features': features,
    });

    await style.addSource(
      GeoJsonSource(
        id: _kSourceId,
        data: geojson,
        cluster: true,
        clusterMaxZoom: 14,
        clusterRadius: 50,
      ),
    );

    // ── Layer 1 : cercles de cluster ────────────────────────────────────────
    await style.addLayer(
      CircleLayer(
        id: _kClusterCircleLayerId,
        sourceId: _kSourceId,
        filter: ['has', 'point_count'],
        circleColor: const int.fromEnvironment(
          'circleColor',
          defaultValue: 0xFFE53935, // rouge ClicEat
        ),
        circleRadius: 18.0,
        circleOpacity: 0.95,
        circleStrokeWidth: 1.5,
        circleStrokeColor: 0xFFFFFFFF,
      ),
    );

    // ── Layer 2 : nombre dans le cluster ────────────────────────────────────
    await style.addLayer(
      SymbolLayer(
        id: _kClusterCountLayerId,
        sourceId: _kSourceId,
        filter: ['has', 'point_count'],
        textField: '{point_count_abbreviated}',
        textSize: 12.0,
        textColor: 0xFFFFFFFF,
        textIgnorePlacement: true,
        textAllowOverlap: true,
      ),
    );

    // ── Layer 3 : marqueurs individuels ─────────────────────────────────────
    await style.addLayer(
      SymbolLayer(
        id: _kUnclusteredLayerId,
        sourceId: _kSourceId,
        filter: [
          '!',
          ['has', 'point_count'],
        ],
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
      ),
    );
  }

  // ─── Map click handler ────────────────────────────────────────────────────

  Future<void> _onMapTap(MapContentGestureContext gestureContext) async {
    if (_mapboxMap == null) return;

    // Vérifier si l'utilisateur a tapé sur un cluster → zoomer
    final clusterFeatures = await _mapboxMap!.queryRenderedFeatures(
      RenderedQueryGeometry.fromScreenCoordinate(gestureContext.touchPosition),
      RenderedQueryOptions(layerIds: [_kClusterCircleLayerId]),
    );

    if (clusterFeatures.isNotEmpty) {
      final feature = clusterFeatures.first?.queriedFeature.feature;
      final geometry = feature?['geometry'] as Map<String, dynamic>?;
      final coordinates = geometry?['coordinates'] as List<dynamic>?;

      if (coordinates != null && coordinates.length >= 2) {
        final lng = (coordinates[0] as num).toDouble();
        final lat = (coordinates[1] as num).toDouble();
        final currentZoom = await _mapboxMap!.getCameraState().then(
          (s) => s.zoom,
        );
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
      RenderedQueryGeometry.fromScreenCoordinate(gestureContext.touchPosition),
      RenderedQueryOptions(layerIds: [_kUnclusteredLayerId]),
    );

    if (markerFeatures.isNotEmpty && mounted) {
      final feature = markerFeatures.first?.queriedFeature.feature;
      final props = feature?['properties'] as Map?;
      final id = props?['id']?.toString() ?? '';
      if (id.isNotEmpty) {
        context.push('/restaurant/$id');
      }
    }
  }

  // ─── Marker icon builder ─────────────────────────────────────────────────

  Future<Uint8List> _buildMarkerIcon() async {
    const size = 32.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(
      const Offset(size / 2, size / 2 + 1),
      size / 2 - 2,
      shadowPaint,
    );

    // White background
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 2,
      whitePaint,
    );

    // Red center
    final redPaint = Paint()..color = AppTheme.primaryRed;
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 4, redPaint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // ─── Location ─────────────────────────────────────────────────────────────

  Future<void> _centerOnUser() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      _mapboxMap?.setCamera(
        CameraOptions(
          center: Point(coordinates: Position(pos.longitude, pos.latitude)),
          zoom: 14,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('client.location_error'.tr())));
      }
    }
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
              center: Point(
                coordinates: Position(
                  AppConstants.defaultLng,
                  AppConstants.defaultLat,
                ),
              ),
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
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                readOnly: true,
                onTap: () => context.push('/search'),
                decoration: InputDecoration(
                  hintText: 'client.search_hint'.tr(),
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_restaurants.length} ${'client.restaurants'.tr()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
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
        color: AppTheme.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
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
                color: AppTheme.lineSoft,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'client.recommended'.tr(),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppTheme.ink,
              ),
            ),
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
                      return GestureDetector(
                        onTap: () => context.push('/restaurant/${r.id}'),
                        child: Container(
                          width: 160,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.lineSoft),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: AppNetworkImage(
                                      url: r.coverImage,
                                      height: 80,
                                      width: 160,
                                      fit: BoxFit.cover,
                                      fallbackAsset:
                                          'assets/images/restaurant_placeholder.jpg',
                                    ),
                                  ),
                                  if (r.rating != null)
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          boxShadow: AppTheme.shadowSm,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              size: 10,
                                              color: AppTheme.honey,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              r.rating!.toStringAsFixed(1),
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.name,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: AppTheme.ink,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time_rounded,
                                          size: 12,
                                          color: AppTheme.muted,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${r.deliveryTimeMinutes ?? 30} min',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: AppTheme.muted,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.delivery_dining_rounded,
                                          size: 12,
                                          color: AppTheme.muted,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${r.deliveryFee.toInt()}F',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: AppTheme.muted,
                                          ),
                                        ),
                                      ],
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
      ),
    );
  }
}
