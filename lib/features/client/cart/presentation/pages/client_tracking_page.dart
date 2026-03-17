import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/services.dart';
import '../../../../../core/config/app_constants.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/services/tracking_service.dart';
import '../../../../../core/services/websocket_service.dart';

class ClientTrackingPage extends StatefulWidget {
  final String orderId;
  const ClientTrackingPage({super.key, required this.orderId});

  @override
  State<ClientTrackingPage> createState() => _ClientTrackingPageState();
}

class _ClientTrackingPageState extends State<ClientTrackingPage> {
  MapboxMap? mapboxMap;

  Map<String, dynamic>? _trackingData;
  Map<String, dynamic>? _etaData;
  bool _loading = true;
  String? _error;

  StreamSubscription<Map<String, dynamic>>? _wsSub;
  Timer? _etaTimer;

  static const Map<String, int> _statusToStep = {
    'pending': 0,
    'confirmed': 0,
    'preparing': 1,
    'ready': 1,
    'picked_up': 2,
    'in_transit': 2,
    'delivered': 3,
  };

  int get _currentStep {
    final status = _trackingData?['status'] as String? ?? 'pending';
    return _statusToStep[status] ?? 0;
  }

  @override
  void initState() {
    super.initState();
    final ws = getIt<WebSocketService>();
    ws.connect(); // ensure connected (no-op if already connected)
    _loadTracking();
    // Poll ETA every 15 s while order is not yet delivered
    _etaTimer = Timer.periodic(const Duration(seconds: 15), (_) => _refreshEta());
    _wsSub = ws.orderTrackingEvents.listen((event) {
      if (event['orderId'] == widget.orderId || event['_id'] == widget.orderId) {
        setState(() {
          if (_trackingData != null) {
            _trackingData = {..._trackingData!, ...event};
          } else {
            _trackingData = event;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _wsSub?.cancel();
    _etaTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshEta() async {
    final status = _trackingData?['status'] as String? ?? '';
    // Stop polling once delivered or cancelled
    if (status == 'delivered' || status == 'cancelled') {
      _etaTimer?.cancel();
      return;
    }
    try {
      final etaRes = await getIt<TrackingService>().getEta(widget.orderId);
      if (etaRes.isSuccessful && etaRes.body != null && mounted) {
        final body = etaRes.body!;
        setState(() {
          _etaData = (body['data'] as Map<String, dynamic>?) ?? body;
        });
      }
    } catch (_) {
      // silently ignore ETA refresh errors
    }
  }

  Future<void> _loadTracking() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        getIt<TrackingService>().getTracking(widget.orderId),
        getIt<TrackingService>().getEta(widget.orderId),
      ]);
      final trackingRes = results[0];
      final etaRes = results[1];
      setState(() {
        if (trackingRes.isSuccessful && trackingRes.body != null) {
          final body = trackingRes.body!;
          _trackingData = (body['data'] as Map<String, dynamic>?) ?? body;
        }
        if (etaRes.isSuccessful && etaRes.body != null) {
          final body = etaRes.body!;
          _etaData = (body['data'] as Map<String, dynamic>?) ?? body;
        }
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
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
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(AppConstants.defaultLng, AppConstants.defaultLat)),
              zoom: 14.0,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: CircleAvatar(
              backgroundColor: theme.cardTheme.color,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.pop();
                },
              ),
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
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(32),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorPanel(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_error ?? 'common.error'.tr(), style: TextStyle(color: theme.colorScheme.error)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadTracking, child: Text('common.retry'.tr())),
        ],
      ),
    );
  }

  Widget _buildTrackingPanel(ThemeData theme) {
    final driver = _trackingData?['driver'] as Map<String, dynamic>?;
    final driverName = driver?['name'] as String? ?? 'tracking.driver'.tr();
    final driverPhoto = driver?['photo'] as String?;
    final vehicle = driver?['vehicle'] as String? ?? '';

    final etaMinutes = _etaData?['etaMinutes'] as int?;
    final etaTime = _etaData?['eta'] as String?;

    final etaDisplay = etaTime != null
        ? etaTime
        : etaMinutes != null
            ? 'tracking.eta_minutes'.tr(args: [etaMinutes.toString()])
            : '--:--';

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5))
        ],
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
                decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
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
                      Text('tracking.eta'.tr(), style: theme.textTheme.bodySmall),
                      Text(
                        etaDisplay,
                        style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                  if (etaMinutes != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('tracking.eta_minutes'.tr(args: [etaMinutes.toString()]), style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurfaceVariant)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildStepper(theme),
            const SizedBox(height: 24),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: driverPhoto != null
                        ? NetworkImage(driverPhoto)
                        : const NetworkImage('https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=200&auto=format&fit=crop'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(driverName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        if (vehicle.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.two_wheeler, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(vehicle, style: theme.textTheme.bodySmall),
                            ],
                          ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    child: IconButton(
                      icon: Icon(Icons.call, color: theme.colorScheme.primary),
                      onPressed: () => HapticFeedback.selectionClick(),
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < labels.length; i++)
                Text(labels[i], style: TextStyle(fontSize: 10, color: _currentStep >= i ? theme.colorScheme.primary : Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, ThemeData theme) {
    final isCompleted = _currentStep >= step;
    final isActive = _currentStep == step;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isCompleted ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: isActive ? Border.all(color: theme.colorScheme.primaryContainer, width: 4) : null,
      ),
      child: isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
    );
  }

  Widget _buildStepLine(int step, ThemeData theme) {
    return Expanded(
      child: Container(
        height: 4,
        color: _currentStep > step ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
