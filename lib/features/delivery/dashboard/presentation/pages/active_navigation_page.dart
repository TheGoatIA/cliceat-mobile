import 'dart:async';
import 'package:cliceat_app/features/delivery/dashboard/data/models/mission_model.dart';
import 'package:cliceat_app/features/navigation/data/models/osrm_route_model.dart';
import 'package:cliceat_app/features/navigation/data/repositories/navigation_repository.dart';
import 'package:cliceat_app/features/navigation/presentation/bloc/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:cliceat_app/core/network/services/navigation_service.dart';
import 'package:cliceat_app/features/client/cart/data/datasources/order_service.dart';

class ActiveNavigationPage extends StatelessWidget {
  final MissionModel mission;
  const ActiveNavigationPage({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(
        NavigationRepository(getIt<NavigationService>()),
      ),
      child: _ActiveNavigationView(mission: mission),
    );
  }
}

class _ActiveNavigationView extends StatefulWidget {
  final MissionModel mission;
  const _ActiveNavigationView({required this.mission});

  @override
  State<_ActiveNavigationView> createState() => _ActiveNavigationViewState();
}

class _ActiveNavigationViewState extends State<_ActiveNavigationView> {
  MapboxMap? mapboxMap;
  StreamSubscription<geo.Position>? _locationSub;

  PolylineAnnotationManager? _polylineAnnotationManager;
  PolylineAnnotation? _routeAnnotation;

  late MissionModel _mission;
  bool _navigationStarted = false;
  String? _lastNavDestKey; // tracks which destination nav was last started for
  bool _showStepsList = false;
  double _currentSpeedKmh = 0.0;

  @override
  void initState() {
    super.initState();
    _mission = widget.mission;
    _loadFreshMission();
    _startLocationEmitting();
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    super.dispose();
  }

  Future<void> _loadFreshMission() async {
    try {
      final response = await getIt<OrderService>().getOrderById(_mission.id);
      if (response.isSuccessful && response.body != null && mounted) {
        final data = response.body!['data'] as Map<String, dynamic>? ?? response.body!;
        final orderData = data['order'] as Map<String, dynamic>? ?? data;
        setState(() {
          _mission = MissionModel.fromJson(orderData);
        });
        _tryStartNavigation();
      }
    } catch (e) {
      debugPrint('[active_navigation_page] loadFresh error: $e');
      _tryStartNavigation();
    }
  }

  void _startLocationEmitting() {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final geo.LocationSettings settings;
    if (isAndroid) {
      settings = geo.AndroidSettings(
        accuracy: geo.LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
        foregroundNotificationConfig: geo.ForegroundNotificationConfig(
          notificationText: 'delivery.bg_location_text'.tr(),
          notificationTitle: 'delivery.bg_location_title'.tr(),
          enableWakeLock: true,
        ),
      );
    } else if (isIOS) {
      settings = geo.AppleSettings(
        accuracy: geo.LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
        activityType: geo.ActivityType.otherNavigation,
        allowBackgroundLocationUpdates: true,
        showBackgroundLocationIndicator: true,
      );
    } else {
      settings = const geo.LocationSettings(
        accuracy: geo.LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      );
    }

    _locationSub = geo.Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen((pos) {
      if (!mounted) return;
      setState(() => _currentSpeedKmh = (pos.speed * 3.6).clamp(0.0, 200.0));
      getIt<WebSocketService>().emitLocationUpdate(
        pos.latitude, pos.longitude,
        heading: pos.heading,
      );
    });
  }

  Future<void> _tryStartNavigation() async {
    final isRestaurantPhase = _mission.status != 'picked_up' && _mission.status != 'en_route';
    final destLat = isRestaurantPhase ? _mission.restaurantLat : _mission.deliveryAddress?.lat;
    final destLng = isRestaurantPhase ? _mission.restaurantLng : _mission.deliveryAddress?.lng;

    if (destLat == null || destLng == null || !mounted) return;

    // Build a key that uniquely identifies this leg of the journey.
    // If the destination changes (restaurant → client) we restart navigation.
    final destKey = '${destLat.toStringAsFixed(5)},${destLng.toStringAsFixed(5)}';
    if (_navigationStarted && _lastNavDestKey == destKey) return;

    _navigationStarted = true;
    _lastNavDestKey = destKey;

    final pos = await geo.Geolocator.getCurrentPosition(
      locationSettings: const geo.LocationSettings(accuracy: geo.LocationAccuracy.high),
    ).catchError((_) async => await geo.Geolocator.getLastKnownPosition() ?? _defaultPos());

    if (!mounted) return;

    context.read<NavigationCubit>().startNavigation(
      originLat: pos.latitude,
      originLng: pos.longitude,
      destLat: destLat,
      destLng: destLng,
      orderId: _mission.id,
      languageCode: context.locale.languageCode,
    );
  }

  geo.Position _defaultPos() => geo.Position(
    latitude: 4.0511, longitude: 9.7679,
    timestamp: DateTime.now(), accuracy: 0, altitude: 0,
    altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0,
  );

  void _onMapCreated(MapboxMap map) {
    mapboxMap = map;
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
  }

  Future<void> _drawOsrmRoute(OsrmRoute route) async {
    if (mapboxMap == null) return;
    try {
      _polylineAnnotationManager ??=
          await mapboxMap!.annotations.createPolylineAnnotationManager();

      final coords = route.geometry.coordinates
          .map((c) => Position(c[0], c[1]))
          .toList();
      if (coords.isEmpty) return;

      if (_routeAnnotation == null) {
        _routeAnnotation = await _polylineAnnotationManager!.create(
          PolylineAnnotationOptions(
            geometry: LineString(coordinates: coords),
            lineColor: AppTheme.primaryRed.toARGB32(),
            lineWidth: 6.0,
            lineOpacity: 0.9,
          ),
        );
      } else {
        _routeAnnotation!.geometry = LineString(coordinates: coords);
        await _polylineAnnotationManager!.update(_routeAnnotation!);
      }

      // Fit camera to route bounds
      if (coords.length >= 2) {
        final minLng = coords.map((p) => p.lng).reduce((a, b) => a < b ? a : b);
        final maxLng = coords.map((p) => p.lng).reduce((a, b) => a > b ? a : b);
        final minLat = coords.map((p) => p.lat).reduce((a, b) => a < b ? a : b);
        final maxLat = coords.map((p) => p.lat).reduce((a, b) => a > b ? a : b);
        mapboxMap?.setCamera(CameraOptions(
          center: Point(coordinates: Position(
            (minLng + maxLng) / 2,
            (minLat + maxLat) / 2,
          )),
          zoom: 14.0,
          pitch: 45.0,
        ));
      }
    } catch (e) {
      debugPrint('[active_navigation_page] drawRoute error: $e');
    }
  }

  void _recenterOnDriver(double lat, double lng, double? heading) {
    mapboxMap?.setCamera(CameraOptions(
      center: Point(coordinates: Position(lng, lat)),
      zoom: 17.0,
      pitch: 60.0,
      bearing: heading ?? 0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isRestaurantPhase = _mission.status != 'picked_up' && _mission.status != 'en_route';

    return BlocConsumer<NavigationCubit, NavigationState>(
      listener: (context, state) {
        state.whenOrNull(
          navigating: (route, stepIndex, lat, lng, isRerouting) {
            _drawOsrmRoute(route);
            if (isRerouting) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('delivery.reroute_success'.tr()), duration: const Duration(seconds: 2)),
              );
            }
          },
          arrived: (_) {
            HapticFeedback.heavyImpact();
          },
        );
      },
      builder: (context, navState) {
        return Scaffold(
          body: Stack(
            children: [
              MapWidget(
                key: const ValueKey('navigationMap'),
                onMapCreated: _onMapCreated,
                styleUri: MapboxStyles.MAPBOX_STREETS,
                cameraOptions: CameraOptions(
                  center: Point(coordinates: Position(9.7679, 4.0511)),
                  zoom: 17.0,
                  pitch: 60.0,
                  bearing: 45.0,
                ),
              ),
              if (navState is NavigationLoading)
                const Center(child: CircularProgressIndicator(color: AppTheme.primaryRed)),
              _buildTopPanel(navState),
              _buildBottomPanel(isRestaurantPhase, navState),
              // Speed HUD
              Positioned(
                top: MediaQuery.of(context).padding.top + 100,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _speedColor(_currentSpeedKmh),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppTheme.shadowMd,
                  ),
                  child: Column(
                    children: [
                      Text(
                        _currentSpeedKmh.round().toString(),
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white,
                        ),
                      ),
                      Text('km/h', style: GoogleFonts.inter(fontSize: 10, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              // Arrival overlay
              if (navState is NavigationArrived)
                _buildArrivalOverlay(navState),
              // Steps list overlay
              if (_showStepsList)
                _buildStepsListOverlay(navState),
              // FABs
              Positioned(
                right: 16,
                bottom: 200,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'recenter_nav',
                      backgroundColor: Colors.white,
                      onPressed: () {
                        final s = navState;
                        if (s is NavigationNavigating) {
                          _recenterOnDriver(s.currentLat, s.currentLng, null);
                        }
                      },
                      child: const Icon(Icons.gps_fixed, color: AppTheme.primaryRed),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'steps_nav',
                      backgroundColor: Colors.white,
                      onPressed: () => setState(() => _showStepsList = !_showStepsList),
                      child: Icon(
                        _showStepsList ? Icons.list_alt : Icons.format_list_numbered,
                        color: AppTheme.primaryRed,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'reroute_nav',
                      backgroundColor: Colors.white,
                      onPressed: () => context.read<NavigationCubit>().requestReroute(),
                      child: const Icon(Icons.refresh, color: AppTheme.primaryRed),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopPanel(NavigationState navState) {
    String instruction = 'delivery.calculating_route'.tr();
    String distanceLabel = '';
    IconData maneuverIcon = Icons.straight;

    if (navState is NavigationNavigating) {
      final steps = navState.route.allSteps;
      if (steps.isNotEmpty && navState.currentStepIndex < steps.length) {
        final step = steps[navState.currentStepIndex];
        instruction = step.displayInstruction;
        distanceLabel = step.distanceLabel;
        maneuverIcon = _maneuverIcon(step.maneuver.type, step.maneuver.modifier);
      }
    } else if (navState is NavigationArrived) {
      instruction = 'delivery.arrived_destination'.tr();
      maneuverIcon = Icons.flag;
    } else if (navState is NavigationError) {
      instruction = 'delivery.navigation_error'.tr();
      maneuverIcon = Icons.warning_amber_rounded;
    }

    return Positioned(
      top: 0, left: 0, right: 0,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 24, left: 16, right: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              boxShadow: AppTheme.shadowMd,
            ),
            child: Row(
              children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.redSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(maneuverIcon, size: 36, color: AppTheme.primaryRed),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (distanceLabel.isNotEmpty)
                        Text(
                          distanceLabel,
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 24, fontWeight: FontWeight.w800,
                            color: AppTheme.ink, letterSpacing: -0.5,
                          ),
                        ),
                      Text(
                        instruction,
                        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.inkSoft),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  Widget _buildBottomPanel(bool isRestaurantPhase, NavigationState navState) {
    String etaLabel = 'delivery.calculating'.tr();
    String distLabel = '--';

    if (navState is NavigationNavigating) {
      etaLabel = navState.route.durationLabel;
      distLabel = navState.route.distanceLabel;
    }

    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                            '$etaLabel • $distLabel',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 22, fontWeight: FontWeight.w800,
                              color: AppTheme.ink, letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'delivery.destination_label'.tr(args: [
                              isRestaurantPhase
                                  ? (_mission.restaurantName ?? '')
                                  : (_mission.clientName ?? '')
                            ]),
                            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.muted),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _confirmExitNavigation();
                        },
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.redSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.close, color: AppTheme.primaryRed, size: 20),
                        ),
                      ),
                    ],
                  ),
                  if (_mission.clientPhone != null && _mission.clientPhone!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.lineSoft.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: AppTheme.honeySoft,
                            child: Icon(Icons.person, color: AppTheme.honey, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _mission.clientName ?? 'delivery.client'.tr(),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.ink,
                                  ),
                                ),
                                Text(
                                  _mission.clientPhone!,
                                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.muted),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.phone_in_talk_rounded, color: AppTheme.green),
                            onPressed: () async {
                              final phone = _mission.clientPhone;
                              if (phone == null || phone.isEmpty) return;
                              HapticFeedback.mediumImpact();
                              final cleaned = phone.replaceAll(RegExp(r'\s+'), '');
                              final uri = Uri.parse('tel:$cleaned');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity, height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRestaurantPhase ? AppTheme.primaryRed : AppTheme.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (isRestaurantPhase) {
                          context.push('/delivery/confirm-pickup', extra: _mission);
                        } else {
                          context.push('/delivery/dropoff', extra: _mission);
                        }
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          isRestaurantPhase
                              ? 'delivery.arrived_at_restaurant'.tr()
                              : 'delivery.arrived_at_client'.tr(),
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
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

  Widget _buildStepsListOverlay(NavigationState navState) {
    List<OsrmStep> steps = [];
    int currentIndex = 0;
    if (navState is NavigationNavigating) {
      steps = navState.route.allSteps;
      currentIndex = navState.currentStepIndex;
    }

    return Positioned(
      top: 120, left: 16, right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 320),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      'delivery.route_steps'.tr(),
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.ink,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _showStepsList = false),
                      child: const Icon(Icons.close, size: 20, color: AppTheme.muted),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: steps.length,
                  itemBuilder: (ctx, i) {
                    final step = steps[i];
                    final isCurrent = i == currentIndex;
                    return Container(
                      color: isCurrent ? AppTheme.redSoft : Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Icon(
                            _maneuverIcon(step.maneuver.type, step.maneuver.modifier),
                            size: 20,
                            color: isCurrent ? AppTheme.primaryRed : AppTheme.muted,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              step.displayInstruction,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                                color: isCurrent ? AppTheme.ink : AppTheme.inkSoft,
                              ),
                            ),
                          ),
                          Text(
                            step.distanceLabel,
                            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.muted),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmExitNavigation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'delivery.quit_navigation'.tr(),
          style: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w700, fontSize: 18, color: AppTheme.ink),
        ),
        content: Text(
          'delivery.quit_warning'.tr(),
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.inkSoft),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text('common.cancel'.tr(), style: GoogleFonts.inter(color: AppTheme.muted)),
          ),
          TextButton(
            onPressed: () {
              context.read<NavigationCubit>().stopNavigation();
              context.pop();
              context.pop();
            },
            child: Text(
              'delivery.quit'.tr(),
              style: GoogleFonts.inter(color: AppTheme.primaryRed, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Color _speedColor(double speed) {
    if (speed > 60) return Colors.red;
    if (speed > 30) return Colors.orange;
    return AppTheme.primaryRed;
  }

  Widget _buildArrivalOverlay(NavigationArrived state) {
    // Auto-pop after 3s
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.pop();
    });

    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppTheme.shadowLg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, size: 80, color: AppTheme.green),
                const SizedBox(height: 16),
                Text(
                  'delivery.arrived_success_title'.tr(),
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.ink,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.route.distanceLabel} • ${state.route.durationLabel}',
                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _maneuverIcon(String type, String? modifier) {
    if (type == 'arrive') return Icons.flag;
    if (type == 'depart') return Icons.play_arrow;
    if (type == 'roundabout' || type == 'rotary') return Icons.roundabout_left;
    if (type == 'u-turn') return Icons.u_turn_left;
    if (modifier == 'left' || modifier == 'sharp left') return Icons.turn_left;
    if (modifier == 'right' || modifier == 'sharp right') return Icons.turn_right;
    if (modifier == 'slight left') return Icons.turn_slight_left;
    if (modifier == 'slight right') return Icons.turn_slight_right;
    return Icons.straight;
  }
}
