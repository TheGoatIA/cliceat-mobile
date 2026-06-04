import 'dart:async';
import 'package:cliceat_app/features/delivery/dashboard/data/models/mission_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:url_launcher/url_launcher.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/services/websocket_service.dart';
import 'package:cliceat_app/features/client/cart/data/datasources/order_service.dart';

class ActiveNavigationPage extends StatefulWidget {
  final MissionModel mission;
  const ActiveNavigationPage({super.key, required this.mission});

  @override
  State<ActiveNavigationPage> createState() => _ActiveNavigationPageState();
}

class _ActiveNavigationPageState extends State<ActiveNavigationPage> {
  MapboxMap? mapboxMap;
  final String _currentInstruction = 'Tournez à droite sur Rue Sylvie';
  final String _distanceToTurn = '150 m';
  String _totalEta = 'Calcul en cours...';
  String _totalDistance = '--';
  StreamSubscription<geo.Position>? _positionSubscription;

  PolylineAnnotationManager? _polylineAnnotationManager;
  PolylineAnnotation? _polylineAnnotation;
  late MissionModel _mission;

  @override
  void initState() {
    super.initState();
    _mission = widget.mission;
    _startPositionTracking();
    _loadFreshMission();
  }

  Future<void> _loadFreshMission() async {
    try {
      final response = await getIt<OrderService>().getOrderById(_mission.id);
      if (response.isSuccessful && response.body != null && mounted) {
        final data =
            response.body!['data'] as Map<String, dynamic>? ?? response.body!;
        final orderData = data['order'] as Map<String, dynamic>? ?? data;
        setState(() {
          _mission = MissionModel.fromJson(orderData);
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  void _startPositionTracking() {
    // 1. Obtenir la dernière position connue pour une initialisation immédiate
    geo.Geolocator.getLastKnownPosition().then((pos) {
      if (pos != null && mounted) {
        _updateDistanceAndEta(pos);
      }
    });

    // 2. Écouter les mises à jour de position en temps réel
    _positionSubscription =
        geo.Geolocator.getPositionStream(
          locationSettings: const geo.LocationSettings(
            accuracy: geo.LocationAccuracy.high,
            distanceFilter: 10, // Actualise tous les 10 mètres de déplacement
          ),
        ).listen((geo.Position position) {
          if (mounted) {
            _updateDistanceAndEta(position);
            // Émettre la position au serveur pour le suivi client en temps réel
            getIt<WebSocketService>().emitLocationUpdate(
              position.latitude,
              position.longitude,
            );
          }
        });
  }

  void _updateDistanceAndEta(geo.Position currentPos) {
    final isRestaurantPhase =
        _mission.status != 'picked_up' && _mission.status != 'en_route';

    final destLat = isRestaurantPhase
        ? _mission.restaurantLat
        : _mission.deliveryAddress?.lat;
    final destLng = isRestaurantPhase
        ? _mission.restaurantLng
        : _mission.deliveryAddress?.lng;

    if (destLat == null || destLng == null) {
      setState(() {
        _totalEta = 'Indisponible';
        _totalDistance = '--';
      });
      return;
    }

    final distanceInMeters = geo.Geolocator.distanceBetween(
      currentPos.latitude,
      currentPos.longitude,
      destLat,
      destLng,
    );

    // Heuristique : Vitesse moyenne urbaine de 25 km/h (moto/trafic)
    const speedKmh = 25.0;
    final timeInSeconds = distanceInMeters / (speedKmh * 1000 / 3600);
    final timeInMinutes = (timeInSeconds / 60).round();

    setState(() {
      if (distanceInMeters >= 1000) {
        _totalDistance = '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
      } else {
        _totalDistance = '${distanceInMeters.round()} m';
      }
      _totalEta = timeInMinutes <= 0 ? '1 min' : '$timeInMinutes min';
    });

    _drawRoutePolyline(currentPos, destLat, destLng);
  }

  Future<void> _drawRoutePolyline(
    geo.Position currentPos,
    double destLat,
    double destLng,
  ) async {
    if (mapboxMap == null) return;
    try {
      _polylineAnnotationManager ??= await mapboxMap!.annotations
          .createPolylineAnnotationManager();

      final points = [
        Position(currentPos.longitude, currentPos.latitude),
        Position(destLng, destLat),
      ];

      if (_polylineAnnotation == null) {
        _polylineAnnotation = await _polylineAnnotationManager!.create(
          PolylineAnnotationOptions(
            geometry: LineString(coordinates: points),
            lineColor: Colors.blue.toARGB32(),
            lineWidth: 6.0,
            lineOpacity: 0.8,
          ),
        );
      } else {
        _polylineAnnotation!.geometry = LineString(coordinates: points);
        await _polylineAnnotationManager!.update(_polylineAnnotation!);
      }

      // Automatically adjust camera bounds to center between driver and destination
      final centerLat = (currentPos.latitude + destLat) / 2;
      final centerLng = (currentPos.longitude + destLng) / 2;
      mapboxMap?.setCamera(
        CameraOptions(
          center: Point(coordinates: Position(centerLng, centerLat)),
          zoom: 14.0,
        ),
      );
    } catch (_) {}
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
    mapboxMap.attribution.updateSettings(AttributionSettings(enabled: false));
    mapboxMap.logo.updateSettings(LogoSettings(enabled: false));
  }

  @override
  Widget build(BuildContext context) {
    final isRestaurantPhase =
        _mission.status != 'picked_up' && _mission.status != 'en_route';

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey("navigationMap"),
            onMapCreated: _onMapCreated,
            styleUri: MapboxStyles.MAPBOX_STREETS,
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(9.7679, 4.0511)),
              zoom: 17.0,
              pitch: 60.0,
              bearing: 45.0,
            ),
          ),
          _buildTopPanel(),
          _buildBottomPanel(isRestaurantPhase),
          Positioned(
            right: 16,
            bottom: 180,
            child: FloatingActionButton(
              heroTag: 'recenter_nav',
              backgroundColor: Colors.white,
              onPressed: () {},
              child: const Icon(Icons.gps_fixed, color: AppTheme.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPanel() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 24,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
              boxShadow: AppTheme.shadowMd,
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.redSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.turn_right,
                    size: 36,
                    color: AppTheme.primaryRed,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _distanceToTurn,
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.ink,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        _currentInstruction,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel(bool isRestaurantPhase) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: AppTheme.shadowLg,
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$_totalEta • $_totalDistance',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.ink,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            isRestaurantPhase
                                ? 'Destination: ${_mission.restaurantName}'
                                : 'Destination: ${_mission.clientName}',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _confirmExitNavigation();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.redSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: AppTheme.primaryRed,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_mission.clientPhone != null &&
                      _mission.clientPhone!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lineSoft.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: AppTheme.honeySoft,
                            child: Icon(
                              Icons.person,
                              color: AppTheme.honey,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _mission.clientName ?? 'Client',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppTheme.ink,
                                  ),
                                ),
                                Text(
                                  _mission.clientPhone!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppTheme.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.phone_in_talk_rounded,
                              color: AppTheme.green,
                            ),
                            onPressed: () async {
                              final phone = _mission.clientPhone;
                              if (phone == null || phone.isEmpty) return;
                              HapticFeedback.mediumImpact();
                              final cleaned = phone.replaceAll(
                                RegExp(r'\s+'),
                                '',
                              );
                              final uri = Uri.parse('tel:$cleaned');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRestaurantPhase
                            ? AppTheme.primaryRed
                            : AppTheme.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (isRestaurantPhase) {
                          context.push(
                            '/delivery/confirm-pickup',
                            extra: _mission,
                          );
                        } else {
                          context.push('/delivery/dropoff', extra: _mission);
                        }
                      },
                      child: Text(
                        isRestaurantPhase
                            ? 'delivery.arrived_at_restaurant'.tr()
                            : 'delivery.arrived_at_client'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmExitNavigation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'delivery.quit_navigation'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
          ),
        ),
        content: Text(
          'delivery.quit_warning'.tr(),
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.inkSoft),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'common.cancel'.tr(),
              style: GoogleFonts.inter(color: AppTheme.muted),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              context.pop();
            },
            child: Text(
              'delivery.quit'.tr(),
              style: GoogleFonts.inter(
                color: AppTheme.primaryRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
