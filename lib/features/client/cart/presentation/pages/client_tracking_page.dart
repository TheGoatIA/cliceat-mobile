import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/config/app_constants.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/cart/data/models/order_model.dart';
import 'package:cliceat_app/features/client/cart/data/models/tracking_model.dart';
import 'package:cliceat_app/features/client/cart/data/repositories/order_repository.dart';
import '../../../../../core/services/websocket_service.dart';
import '../../../../../core/theme/app_theme.dart';

class ClientTrackingPage extends StatefulWidget {
  final String orderId;
  const ClientTrackingPage({super.key, required this.orderId});

  @override
  State<ClientTrackingPage> createState() => _ClientTrackingPageState();
}

class _ClientTrackingPageState extends State<ClientTrackingPage> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? _annotationManager;
  PointAnnotation? _driverAnnotation;
  PointAnnotation? _destinationAnnotation;
  Uint8List? _driverIcon;
  Uint8List? _destinationIcon;
  OrderModel? _order;

  TrackingModel? _trackingData;
  TrackingModel? _etaData;
  bool _loading = true;
  String? _error;

  StreamSubscription<Map<String, dynamic>>? _wsSub;
  StreamSubscription<Map<String, dynamic>>? _driverLocationSub;
  StreamSubscription<WsStatus>? _wsStatusSub;
  Timer? _etaTimer;

  static const Map<String, int> _statusToStep = {
    'pending_payment': -1,
    'pending': -1,
    'confirmed': 0,
    'preparing': 1,
    'ready': 1,
    'picked_up': 2,
    'in_transit': 2,
    'en_route': 2,
    'delivered': 3,
  };

  int get _currentStep {
    final status = _trackingData?.status ?? _order?.status ?? 'pending';
    final isCash = (_order?.paymentMethod?.toLowerCase() == 'cash');
    if (status == 'pending') {
      if (isCash) {
        // En attente de validation admin, pas encore confirmée
        return -1;
      } else {
        // Commande déjà payée, d'office confirmée
        return 0;
      }
    }
    return _statusToStep[status] ?? -1;
  }

  String _getLoadingTitle() {
    final status = _trackingData?.status ?? _order?.status ?? 'pending';
    final isCash = (_order?.paymentMethod?.toLowerCase() == 'cash');
    if (status == 'pending_payment') {
      return 'En attente de paiement...';
    } else if (status == 'pending' && isCash) {
      return 'En attente de validation...';
    } else {
      return 'Recherche d\'un livreur...';
    }
  }

  String _getLoadingSubtitle() {
    final status = _trackingData?.status ?? _order?.status ?? 'pending';
    final isCash = (_order?.paymentMethod?.toLowerCase() == 'cash');
    if (status == 'pending_payment') {
      return 'Veuillez finaliser le paiement pour lancer votre commande.';
    } else if (status == 'pending' && isCash) {
      return 'Votre commande sera confirmée après validation par un administrateur.';
    } else {
      return 'Votre commande est en préparation';
    }
  }

  @override
  void initState() {
    super.initState();
    final ws = getIt<WebSocketService>();
    ws.connect();

    // Rejoindre le salon de commande en temps réel
    ws.joinOrder(widget.orderId);

    _loadTracking();
    _etaTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _refreshEta(),
    );

    // Gérer les reconnexions automatiques
    _wsStatusSub = ws.statusStream.listen((status) {
      if (status == WsStatus.connected) {
        ws.joinOrder(widget.orderId);
      }
    });

    // Écouter les changements de statut de commande
    _wsSub = ws.orderTrackingEvents.listen((event) {
      if (event['orderId'] == widget.orderId ||
          event['_id'] == widget.orderId) {
        final newStatus = event['status']?.toString();
        setState(() {
          final mergedMap = <String, dynamic>{
            ...(_trackingData != null
                ? {
                    'orderId': _trackingData!.orderId,
                    'status': _trackingData!.status,
                    if (_trackingData!.driverLat != null)
                      'driverLat': _trackingData!.driverLat,
                    if (_trackingData!.driverLng != null)
                      'driverLng': _trackingData!.driverLng,
                    if (_trackingData!.driverName != null)
                      'driverName': _trackingData!.driverName,
                    if (_trackingData!.driverPhone != null)
                      'driverPhone': _trackingData!.driverPhone,
                    if (_trackingData!.driverAvatar != null)
                      'driverAvatar': _trackingData!.driverAvatar,
                  }
                : <String, dynamic>{}),
            ...event,
          };
          if (mergedMap['status'] == null ||
              mergedMap['status'].toString().isEmpty) {
            mergedMap['status'] =
                _trackingData?.status ?? _order?.status ?? 'pending';
          }
          _trackingData = TrackingModel.fromJson(mergedMap);
        });
        _updateDriverMarker();
        if (newStatus == 'delivered') {
          HapticFeedback.heavyImpact();
          if (mounted) {
            context.go('/client/rate/${widget.orderId}');
          }
        }
      }
    });

    // Écouter les positions du livreur en temps réel
    _driverLocationSub = ws.driverLocationEvents.listen((event) {
      final lat = (event['lat'] as num?)?.toDouble();
      final lng = (event['lng'] as num?)?.toDouble();
      if (lat != null && lng != null && _trackingData != null) {
        setState(() {
          _trackingData = TrackingModel(
            orderId: _trackingData!.orderId,
            status: _trackingData!.status,
            driverLat: lat,
            driverLng: lng,
            etaMinutes: _trackingData!.etaMinutes,
            driverName: _trackingData!.driverName,
            driverPhone: _trackingData!.driverPhone,
            driverAvatar: _trackingData!.driverAvatar,
          );
        });
        _updateDriverMarker();
      }
    });
  }

  @override
  void dispose() {
    final ws = getIt<WebSocketService>();
    ws.leaveOrder(widget.orderId);
    _wsSub?.cancel();
    _driverLocationSub?.cancel();
    _wsStatusSub?.cancel();
    _etaTimer?.cancel();
    super.dispose();
  }

  Future<Uint8List> _buildDriverIcon() async {
    const size = 64.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size, size));

    // Outer shadow/glow
    final paintShadow = Paint()
      ..color = AppTheme.primaryRed.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(const Offset(32, 32), 26, paintShadow);

    // Outer primary circle (Red representing ClicEat)
    final paintOuter = Paint()..color = AppTheme.primaryRed;
    canvas.drawCircle(const Offset(32, 32), 24, paintOuter);

    // White border ring
    final paintRing = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(const Offset(32, 32), 24, paintRing);

    // Draw Material Delivery Dining Icon
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(Icons.delivery_dining_rounded.codePoint),
      style: TextStyle(
        fontSize: 32.0,
        fontFamily: Icons.delivery_dining_rounded.fontFamily,
        package: Icons.delivery_dining_rounded.fontPackage,
        color: Colors.white,
      ),
    );
    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(32 - textPainter.width / 2, 32 - textPainter.height / 2),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  Future<Uint8List> _buildDestinationIcon() async {
    const size = 64.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size, size));

    // Outer shadow
    final paintShadow = Paint()
      ..color = AppTheme.ink.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(const Offset(32, 32), 26, paintShadow);

    // Outer dark circle
    final paintOuter = Paint()..color = AppTheme.ink;
    canvas.drawCircle(const Offset(32, 32), 24, paintOuter);

    // White border ring
    final paintRing = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(const Offset(32, 32), 24, paintRing);

    // Draw Material Home Icon
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(Icons.home_rounded.codePoint),
      style: TextStyle(
        fontSize: 32.0,
        fontFamily: Icons.home_rounded.fontFamily,
        package: Icons.home_rounded.fontPackage,
        color: Colors.white,
      ),
    );
    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(32 - textPainter.width / 2, 32 - textPainter.height / 2),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  Future<void> _onMapCreated(MapboxMap map) async {
    mapboxMap = map;
    _driverIcon = await _buildDriverIcon();
    _destinationIcon = await _buildDestinationIcon();
    _annotationManager = await map.annotations.createPointAnnotationManager();
    _updateDriverMarker();
    _updateDeliveryMarker();
    map.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    map.compass.updateSettings(CompassSettings(enabled: false));
    map.attribution.updateSettings(AttributionSettings(enabled: false));
    map.logo.updateSettings(LogoSettings(enabled: false));
  }

  /// Extracts driver lat/lng from tracking data and places/moves the marker.
  Future<void> _updateDriverMarker() async {
    if (_annotationManager == null || _driverIcon == null) return;
    if (_trackingData == null) return;

    final lat = _trackingData!.driverLat;
    final lng = _trackingData!.driverLng;
    if (lat == null || lng == null) return;

    final point = Point(coordinates: Position(lng, lat));

    if (_driverAnnotation == null) {
      _driverAnnotation = await _annotationManager!.create(
        PointAnnotationOptions(
          geometry: point,
          image: _driverIcon,
          iconSize: 0.9,
          textField: 'tracking.driver'.tr(),
          textSize: 10.0,
          textOffset: [0.0, 2.5],
          textColor: 0xFFD32F2F,
          textHaloColor: 0xFFFFFFFF,
          textHaloWidth: 1.5,
        ),
      );
    } else {
      _driverAnnotation!.geometry = point;
      await _annotationManager!.update(_driverAnnotation!);
    }

    // Pan camera to driver location
    await mapboxMap?.flyTo(
      CameraOptions(center: point, zoom: 15.0),
      MapAnimationOptions(duration: 1000),
    );
  }

  Future<void> _updateDeliveryMarker() async {
    if (_annotationManager == null || _destinationIcon == null) return;
    if (_order == null) return;

    final dest = _order!.deliveryAddress;
    if (dest == null) return;
    final lat = dest.lat;
    final lng = dest.lng;
    if (lat == null || lng == null) return;

    final point = Point(coordinates: Position(lng, lat));

    if (_destinationAnnotation == null) {
      _destinationAnnotation = await _annotationManager!.create(
        PointAnnotationOptions(
          geometry: point,
          image: _destinationIcon,
          iconSize: 0.9,
          textField: 'tracking.destination'.tr(),
          textSize: 10.0,
          textOffset: [0.0, 2.5],
          textColor: 0xFF1E1E1E,
          textHaloColor: 0xFFFFFFFF,
          textHaloWidth: 1.5,
        ),
      );
    } else {
      _destinationAnnotation!.geometry = point;
      await _annotationManager!.update(_destinationAnnotation!);
    }
  }

  Future<void> _refreshEta() async {
    final status = _trackingData?.status ?? '';
    if (status == 'delivered' || status == 'cancelled') {
      _etaTimer?.cancel();
      return;
    }
    final result = await getIt<OrderRepository>().getEta(widget.orderId);
    if (mounted) {
      result.fold((_) {}, (eta) => setState(() => _etaData = eta));
    }
  }

  Future<void> _loadTracking() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final repo = getIt<OrderRepository>();
    final results = await Future.wait([
      repo.getTracking(widget.orderId),
      repo.getEta(widget.orderId),
      repo.getOrderById(widget.orderId),
    ]);
    if (!mounted) return;
    final trackingResult = results[0] as dynamic;
    final etaResult = results[1] as dynamic;
    final orderResult = results[2] as dynamic;
    setState(() {
      trackingResult.fold(
        (err) => _error = err.message,
        (tracking) => _trackingData = tracking,
      );
      etaResult.fold((_) {}, (eta) => _etaData = eta);
      orderResult.fold((_) {}, (order) => _order = order);
      _loading = false;
    });
    _updateDriverMarker();
    _updateDeliveryMarker();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey("clientTrackingMap"),
            onMapCreated: _onMapCreated,
            styleUri: MapboxStyles.MAPBOX_STREETS,
            cameraOptions: CameraOptions(
              center: Point(
                coordinates: Position(
                  AppConstants.defaultLng,
                  AppConstants.defaultLat,
                ),
              ),
              zoom: 14.0,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.ink),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/client');
                  }
                },
              ),
            ),
          ),
          // Indicateur visuel et sémantique de l'état du réseau
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: StreamBuilder<WsStatus>(
              stream: getIt<WebSocketService>().statusStream,
              builder: (context, snapshot) {
                final status = snapshot.data ?? WsStatus.disconnected;
                return Semantics(
                  label: 'Recherche de connexion en temps réel',
                  value: status.name,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: status == WsStatus.connected
                          ? AppTheme.green
                          : AppTheme.primaryRed,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: _loading
                    ? _buildLoadingPanel(theme)
                    : _error != null
                    ? _buildErrorPanel(theme)
                    : _buildTrackingPanel(theme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPanel(ThemeData theme) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(32),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryRed,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorPanel(ThemeData theme) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _error ?? 'common.error'.tr(),
            style: GoogleFonts.inter(color: AppTheme.primaryRed, fontSize: 14),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _loadTracking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text('common.retry'.tr()),
            ),
          ),
        ],
      ),
    );
  }

  double _getDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000.0; // Earth radius in meters
    final dLat = (lat2 - lat1) * math.pi / 180.0;
    final dLon = (lon2 - lon1) * math.pi / 180.0;
    final a =
        math.sin(dLat / 2.0) * math.sin(dLat / 2.0) +
        math.cos(lat1 * math.pi / 180.0) *
            math.cos(lat2 * math.pi / 180.0) *
            math.sin(dLon / 2.0) *
            math.sin(dLon / 2.0);
    final c = 2.0 * math.atan2(math.sqrt(a), math.sqrt(1.0 - a));
    return R * c;
  }

  int? _calculateDynamicEta() {
    if (_trackingData == null || _order == null) return null;
    final driverLat = _trackingData!.driverLat;
    final driverLng = _trackingData!.driverLng;
    final dest = _order!.deliveryAddress;
    if (driverLat == null || driverLng == null || dest == null) return null;

    final destLat = dest.lat;
    final destLng = dest.lng;
    if (destLat == null || destLng == null) return null;

    final distanceInMeters = _getDistance(
      driverLat,
      driverLng,
      destLat,
      destLng,
    );

    // Average urban speed: 25 km/h (motorcycle delivery)
    const speedKmh = 25.0;
    final timeInSeconds = distanceInMeters / (speedKmh * 1000.0 / 3600.0);
    final timeInMinutes = (timeInSeconds / 60.0).round();

    return timeInMinutes <= 0 ? 1 : timeInMinutes;
  }

  Widget _buildTrackingPanel(ThemeData theme) {
    final driverName = _trackingData?.driverName ?? 'tracking.driver'.tr();
    final driverPhoto = _trackingData?.driverAvatar;

    // Dynamically calculate the driver-to-destination ETA in minutes
    final dynamicEtaMinutes = _calculateDynamicEta();
    final etaMinutes =
        dynamicEtaMinutes ?? _etaData?.etaMinutes ?? _trackingData?.etaMinutes;

    String etaDisplay = '--:--';
    if (etaMinutes != null) {
      final arrivalTime = DateTime.now().add(Duration(minutes: etaMinutes));
      etaDisplay = DateFormat('HH:mm').format(arrivalTime);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: AppTheme.shadowLg,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.lineSoft,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'tracking.eta'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.muted,
                        ),
                      ),
                      Text(
                        etaDisplay,
                        style: GoogleFonts.bricolageGrotesque(
                          fontWeight: FontWeight.w800,
                          fontSize: 32,
                          color: AppTheme.primaryRed,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                  if (etaMinutes != null)
                    Semantics(
                      label: 'Temps de livraison restant',
                      value: '$etaMinutes minutes',
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.redSoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'tracking.eta_minutes'.tr(
                            args: [etaMinutes.toString()],
                          ),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppTheme.primaryRed,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildStepper(theme),
            if (_order?.paymentMethod?.toLowerCase() == 'cash' &&
                _order?.confirmationCode != null &&
                _order?.status != 'delivered' &&
                _order?.status != 'cancelled') ...[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.honeySoft,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.honey.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.honey.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.vpn_key_rounded,
                          color: AppTheme.honey,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Code de livraison',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppTheme.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'À donner au livreur à l\'arrivée',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.honey.withValues(alpha: 0.15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.honey.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          _order!.confirmationCode!,
                          style: GoogleFonts.bricolageGrotesque(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: AppTheme.honey,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Divider(),
            if (_trackingData?.driverName == null)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppTheme.redSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primaryRed,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getLoadingTitle(),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppTheme.ink,
                            ),
                          ),
                          Text(
                            _getLoadingSubtitle(),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: driverPhoto != null
                          ? NetworkImage(driverPhoto)
                          : null,
                      backgroundColor: AppTheme.redSoft,
                      child: driverPhoto == null
                          ? const Icon(Icons.person, color: AppTheme.primaryRed)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driverName,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppTheme.ink,
                            ),
                          ),
                          if (_trackingData?.driverPhone != null)
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: AppTheme.muted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _trackingData!.driverPhone!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppTheme.muted,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final phone = _trackingData?.driverPhone;
                        if (phone == null || phone.isEmpty) return;

                        HapticFeedback.mediumImpact();
                        // Nettoyer le numéro (enlever espaces)
                        final cleaned = phone.replaceAll(RegExp(r'\s+'), '');
                        final uri = Uri.parse('tel:$cleaned');

                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('tracking.call_unavailable'.tr()),
                            ),
                          );
                        }
                      },
                      child: Semantics(
                        label: 'Appeler le livreur',
                        button: true,
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor: AppTheme.redSoft,
                          child: const Icon(
                            Icons.call_rounded,
                            color: AppTheme.primaryRed,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper(ThemeData theme) {
    final labels = [
      'tracking.step_confirmed'.tr(),
      'tracking.step_preparing'.tr(),
      'tracking.step_on_the_way'.tr(),
      'tracking.step_delivered'.tr(),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              for (int i = 0; i < 4; i++) ...[
                _buildStepCircle(i, theme),
                if (i < 3) _buildStepLine(i, theme),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < labels.length; i++)
                SizedBox(
                  width: 58,
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: _currentStep >= i
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: _currentStep >= i
                          ? AppTheme.primaryRed
                          : AppTheme.mutedLight,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, ThemeData theme) {
    final isCompleted = _currentStep >= step;
    final isActive = _currentStep == step;
    final stepLabel = [
      'tracking.step_confirmed'.tr(),
      'tracking.step_preparing'.tr(),
      'tracking.step_on_the_way'.tr(),
      'tracking.step_delivered'.tr(),
    ][step];

    return Semantics(
      label: 'Étape $stepLabel',
      value: isCompleted ? 'Terminée' : (isActive ? 'En cours' : 'À venir'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isActive ? 32 : 28,
        height: isActive ? 32 : 28,
        decoration: BoxDecoration(
          color: isCompleted ? AppTheme.primaryRed : AppTheme.lineSoft,
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppTheme.primaryRed.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
          border: isActive
              ? Border.all(
                  color: AppTheme.primaryRed.withValues(alpha: 0.3),
                  width: 4,
                )
              : null,
        ),
        child: isCompleted
            ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildStepLine(int step, ThemeData theme) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 4,
        decoration: BoxDecoration(
          color: _currentStep > step ? AppTheme.primaryRed : AppTheme.lineSoft,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
