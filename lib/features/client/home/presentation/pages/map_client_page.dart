import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:cliceat_app/features/client/profile/presentation/bloc/profile_cubit.dart';

import 'package:cliceat_app/core/services/location_service.dart';
import '../../../../../core/config/app_constants.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/home/data/models/restaurant_model.dart';
import 'package:cliceat_app/features/client/home/data/repositories/restaurant_repository.dart';
import '../../../../../shared/widgets/app_network_image.dart';

// ─── Source / Layer IDs ───────────────────────────────────────────────────────

const _kSourceId = 'restaurant-source';
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
  String _selectedCity = 'Yaound\u00e9';

  @override
  void initState() {
    super.initState();
    _initializeCity();
    _loadRestaurants();
  }

  void _initializeCity() {
    final profileState = context.read<ProfileCubit>().state;
    profileState.maybeWhen(
      loaded: (user) {
        if (user.city != null && user.city!.isNotEmpty) {
          _selectedCity = _normalizeCity(user.city!);
        } else {
          _selectedCity = 'Yaound\u00e9';
        }
      },
      orElse: () {
        _selectedCity = 'Yaound\u00e9';
      },
    );
  }

  String _normalizeCity(String city) {
    final lower = city.toLowerCase().trim();
    if (lower == 'douala') return 'Douala';
    if (lower == 'yaounde' || lower == 'yaound\u00e9') return 'Yaound\u00e9';
    return 'Yaound\u00e9';
  }

  Future<void> _centerOnCity() async {
    if (_mapboxMap == null) return;
    final (lat, lng) = _getCityCenter(_selectedCity);
    await _mapboxMap!.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(lng, lat)),
        zoom: 12.0,
      ),
      MapAnimationOptions(duration: 800),
    );
  }

  (double, double) _getCityCenter(String city) {
    final lower = city.toLowerCase().trim();
    if (lower == 'douala') {
      return (4.0511, 9.7679);
    }
    return (3.8480, 11.5021);
  }

  // ─── Data ─────────────────────────────────────────────────────────────────

  Future<void> _loadRestaurants() async {
    setState(() => _loading = true);
    final result = await getIt<RestaurantRepository>().getRestaurants(
      city: _selectedCity,
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
    _centerOnCity();
    // Écouter les clics sur les features
    map.setOnMapTapListener(_onMapTap);
    // Désactiver l'échelle et les attributions encombrantes si besoin
    map.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingMaxRadius: 50.0,
      ),
    );
    map.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    map.compass.updateSettings(CompassSettings(enabled: false));
    map.attribution.updateSettings(AttributionSettings(enabled: false));
    map.logo.updateSettings(LogoSettings(enabled: false));

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
      'cluster-halo-small',
      'cluster-halo-medium',
      'cluster-halo-large',
      'cluster-small',
      'cluster-medium',
      'cluster-large',
      'cluster-count-small',
      'cluster-count-medium',
      'cluster-count-large',
      _kUnclusteredLayerId,
    ]) {
      try {
        await style.removeStyleLayer(id);
      } catch (e, s) {
        debugPrint('[map_client_page.dart] error: $e\n$s');
      }
    }
    try {
      await style.removeStyleSource(_kSourceId);
    } catch (e, s) {
      debugPrint('[map_client_page.dart] error: $e\n$s');
    }

    // Ajouter l'icône de marqueur individuel (généré en haute définition 48x48)
    final markerBytes = await _buildMarkerIcon();
    try {
      await style.addStyleImage(
        _kMarkerImageId,
        1.0,
        MbxImage(width: 48, height: 48, data: markerBytes),
        false,
        [],
        [],
        null,
      );
    } catch (e, s) {
      debugPrint('[map_client_page.dart] error: $e\n$s');
    }

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

    // ── CONFIGURATION DES FILTRES DE CLUSTERS PAR TAILLE ─────────────────────────
    final smallFilter = [
      'all',
      ['has', 'point_count'],
      [
        '<',
        ['get', 'point_count'],
        10,
      ],
    ];
    final mediumFilter = [
      'all',
      ['has', 'point_count'],
      [
        '>=',
        ['get', 'point_count'],
        10,
      ],
      [
        '<',
        ['get', 'point_count'],
        50,
      ],
    ];
    final largeFilter = [
      'all',
      ['has', 'point_count'],
      [
        '>=',
        ['get', 'point_count'],
        50,
      ],
    ];

    // ── 1. PETITS CLUSTERS (< 10) ──────────────────────────────────────────────
    await style.addLayer(
      CircleLayer(
        id: 'cluster-halo-small',
        sourceId: _kSourceId,
        filter: smallFilter,
        circleColor: 0xFFE53935, // Rouge ClicEat
        circleRadius: 24.0,
        circleOpacity: 0.3,
        circleBlur: 0.6,
      ),
    );
    await style.addLayer(
      CircleLayer(
        id: 'cluster-small',
        sourceId: _kSourceId,
        filter: smallFilter,
        circleColor: 0xFFE53935,
        circleRadius: 18.0,
        circleOpacity: 0.95,
        circleStrokeWidth: 2.0,
        circleStrokeColor: 0xFFFFFFFF,
      ),
    );
    await style.addLayer(
      SymbolLayer(
        id: 'cluster-count-small',
        sourceId: _kSourceId,
        filter: smallFilter,
        textField: '{point_count_abbreviated}',
        textSize: 12.0,
        textColor: 0xFFFFFFFF,
        textIgnorePlacement: true,
        textAllowOverlap: true,
      ),
    );

    // ── 2. CLUSTERS MOYENS (10 - 49) ──────────────────────────────────────────
    await style.addLayer(
      CircleLayer(
        id: 'cluster-halo-medium',
        sourceId: _kSourceId,
        filter: mediumFilter,
        circleColor: 0xFFD32F2F, // Rouge moyen
        circleRadius: 28.0,
        circleOpacity: 0.35,
        circleBlur: 0.6,
      ),
    );
    await style.addLayer(
      CircleLayer(
        id: 'cluster-medium',
        sourceId: _kSourceId,
        filter: mediumFilter,
        circleColor: 0xFFD32F2F,
        circleRadius: 22.0,
        circleOpacity: 0.95,
        circleStrokeWidth: 2.0,
        circleStrokeColor: 0xFFFFFFFF,
      ),
    );
    await style.addLayer(
      SymbolLayer(
        id: 'cluster-count-medium',
        sourceId: _kSourceId,
        filter: mediumFilter,
        textField: '{point_count_abbreviated}',
        textSize: 13.0,
        textColor: 0xFFFFFFFF,
        textIgnorePlacement: true,
        textAllowOverlap: true,
      ),
    );

    // ── 3. GRANDS CLUSTERS (>= 50) ─────────────────────────────────────────────
    await style.addLayer(
      CircleLayer(
        id: 'cluster-halo-large',
        sourceId: _kSourceId,
        filter: largeFilter,
        circleColor: 0xFFC62828, // Rouge sombre
        circleRadius: 34.0,
        circleOpacity: 0.4,
        circleBlur: 0.6,
      ),
    );
    await style.addLayer(
      CircleLayer(
        id: 'cluster-large',
        sourceId: _kSourceId,
        filter: largeFilter,
        circleColor: 0xFFC62828,
        circleRadius: 28.0,
        circleOpacity: 0.95,
        circleStrokeWidth: 2.0,
        circleStrokeColor: 0xFFFFFFFF,
      ),
    );
    await style.addLayer(
      SymbolLayer(
        id: 'cluster-count-large',
        sourceId: _kSourceId,
        filter: largeFilter,
        textField: '{point_count_abbreviated}',
        textSize: 15.0,
        textColor: 0xFFFFFFFF,
        textIgnorePlacement: true,
        textAllowOverlap: true,
      ),
    );

    // ── 4. MARQUEURS INDIVIDUELS ──────────────────────────────────────────────
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

    // Vérifier si l'utilisateur a tapé sur un cluster (petits, moyens ou grands) → zoomer
    final clusterFeatures = await _mapboxMap!.queryRenderedFeatures(
      RenderedQueryGeometry.fromScreenCoordinate(gestureContext.touchPosition),
      RenderedQueryOptions(
        layerIds: ['cluster-small', 'cluster-medium', 'cluster-large'],
      ),
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
    const size = 48.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size, size));

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(
      const Offset(size / 2, size / 2 + 2),
      size / 2 - 4,
      shadowPaint,
    );

    // Red outer circle
    final redPaint = Paint()..color = AppTheme.primaryRed;
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2 - 3, redPaint);

    // White ring/border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 3,
      borderPaint,
    );

    // Inner White circle
    final innerWhitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 9,
      innerWhitePaint,
    );

    // Draw fork & spoon icon in the center (utilisant le TextDirection de dart:ui pour éviter les conflits Mapbox)
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(Icons.restaurant_rounded.codePoint),
      style: TextStyle(
        fontSize: 18,
        fontFamily: Icons.restaurant_rounded.fontFamily,
        color: AppTheme.primaryRed,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // ─── Location & Zoom Controls ─────────────────────────────────────────────

  Future<void> _centerOnUser() async {
    try {
      final locationService = getIt<LocationService>();
      final pos = await locationService.getCurrentPosition();
      if (pos != null) {
        _mapboxMap?.setCamera(
          CameraOptions(
            center: Point(coordinates: Position(pos.longitude, pos.latitude)),
            zoom: 14,
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('client.location_error'.tr())));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('client.location_error'.tr())));
      }
    }
  }

  Future<void> _zoomIn() async {
    if (_mapboxMap == null) return;
    try {
      final currentZoom = await _mapboxMap!.getCameraState().then(
        (s) => s.zoom,
      );
      await _mapboxMap!.flyTo(
        CameraOptions(zoom: (currentZoom + 1.0).clamp(0.0, 22.0)),
        MapAnimationOptions(duration: 400),
      );
    } catch (e, s) {
      debugPrint('[map_client_page.dart] error: $e\n$s');
    }
  }

  Future<void> _zoomOut() async {
    if (_mapboxMap == null) return;
    try {
      final currentZoom = await _mapboxMap!.getCameraState().then(
        (s) => s.zoom,
      );
      await _mapboxMap!.flyTo(
        CameraOptions(zoom: (currentZoom - 1.0).clamp(0.0, 22.0)),
        MapAnimationOptions(duration: 400),
      );
    } catch (e, s) {
      debugPrint('[map_client_page.dart] error: $e\n$s');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (user) {
            if (user.city != null && user.city!.isNotEmpty) {
              final normalized = _normalizeCity(user.city!);
              if (_selectedCity != normalized) {
                setState(() {
                  _selectedCity = normalized;
                });
                _loadRestaurants();
                _centerOnCity();
              }
            }
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            MapWidget(
              key: const ValueKey('clientMapWidget'),
              onMapCreated: _onMapCreated,
              styleUri: MapboxStyles.MAPBOX_STREETS,
              cameraOptions: CameraOptions(
                center: Point(
                  coordinates: Position(
                    _selectedCity == 'Douala' ? 9.7679 : 11.5021,
                    _selectedCity == 'Douala' ? 4.0511 : 3.8480,
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

          // Boutons de navigation et zoom
          Positioned(
            bottom: 230,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bouton Zoom In (+)
                FloatingActionButton.small(
                  heroTag: 'zoomIn',
                  onPressed: _zoomIn,
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.ink,
                  child: const Icon(Icons.add_rounded, size: 20),
                ),
                const SizedBox(height: 8),
                // Bouton Zoom Out (-)
                FloatingActionButton.small(
                  heroTag: 'zoomOut',
                  onPressed: _zoomOut,
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.ink,
                  child: const Icon(Icons.remove_rounded, size: 20),
                ),
                const SizedBox(height: 8),
                // Bouton Localisation
                FloatingActionButton.small(
                  heroTag: 'locateMe',
                  onPressed: _centerOnUser,
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryRed,
                  child: const Icon(Icons.my_location_rounded, size: 18),
                ),
              ],
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
    ),
  );
}

  Widget _buildRestaurantBottomSheet(ThemeData theme) {
    return Container(
      height: 210,
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
