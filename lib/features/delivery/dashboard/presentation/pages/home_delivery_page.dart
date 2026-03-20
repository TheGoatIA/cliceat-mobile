import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/di/injection.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/models/earnings_model.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/repositories/driver_repository.dart';
import '../../../../../core/services/websocket_service.dart';
import '../../../../../shared/widgets/stat_card.dart';
import '../bloc/mission_bloc.dart';

// Platform-specific GPS settings
final _androidLocationSettings = AndroidSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 15,
  forceLocationManager: false,
  intervalDuration: const Duration(seconds: 5),
  foregroundNotificationConfig: const ForegroundNotificationConfig(
    notificationText: 'ClicEat : suivi de position en cours',
    notificationTitle: 'ClicEat Livreur',
    enableWakeLock: true,
  ),
);

final _appleLocationSettings = AppleSettings(
  accuracy: LocationAccuracy.high,
  activityType: ActivityType.automotiveNavigation,
  distanceFilter: 15,
  pauseLocationUpdatesAutomatically: false,
  showBackgroundLocationIndicator: true,
);

class HomeDeliveryPage extends StatefulWidget {
  const HomeDeliveryPage({super.key});

  @override
  State<HomeDeliveryPage> createState() => _HomeDeliveryPageState();
}

class _HomeDeliveryPageState extends State<HomeDeliveryPage> {
  bool isOnline = false;
  final Logger _logger = Logger();

  EarningsModel? _earnings;
  bool _earningsLoading = true;

  StreamSubscription<Position>? _locationSubscription;
  late final MissionBloc _missionBloc;
  StreamSubscription<Map<String, dynamic>>? _wsSubscription;

  @override
  void initState() {
    super.initState();
    _missionBloc = getIt<MissionBloc>()
      ..add(const MissionEvent.loadActiveMissions());
    _wsSubscription = getIt<WebSocketService>().missionEvents.listen((_) {
      _missionBloc.add(const MissionEvent.loadActiveMissions());
    });
    _loadEarnings();
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _missionBloc.close();
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadEarnings() async {
    setState(() => _earningsLoading = true);
    final result = await getIt<DriverRepository>().getEarnings();
    if (!mounted) return;
    result.fold(
      (err) {
        _logger.e('Failed to load earnings: ${err.message}');
        setState(() => _earningsLoading = false);
      },
      (earnings) => setState(() {
        _earnings = earnings;
        _earningsLoading = false;
      }),
    );
  }

  Future<void> _startLocationUpdates() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _logger.w('Location permission denied');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('delivery.location_permission_required'.tr())),
        );
      }
      return;
    }

    final LocationSettings settings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      settings = _androidLocationSettings;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      settings = _appleLocationSettings;
    } else {
      settings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15,
      );
    }

    _locationSubscription =
        Geolocator.getPositionStream(locationSettings: settings).listen((
          position,
        ) {
          getIt<DriverRepository>().updateLocation(
            position.latitude,
            position.longitude,
          );
          getIt<WebSocketService>().emitLocationUpdate(
            position.latitude,
            position.longitude,
          );
        }, onError: (e) => _logger.w('GPS stream error: $e'));
  }

  void _stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _missionBloc,
      child: BlocListener<MissionBloc, MissionState>(
        listener: (context, state) {
          state.maybeWhen(
            actionSuccess: (message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message.tr())));
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message.tr()),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
            },
            orElse: () {},
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('delivery.dashboard_title'.tr()),
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildOnlineToggle(theme),
                const SizedBox(height: 16),
                _buildStatusCard(theme),
                const SizedBox(height: 16),
                _buildTodayStats(theme),
                const SizedBox(height: 16),
                Expanded(child: _buildMissionsAndRecent(theme)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineToggle(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('delivery.status'.tr(), style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isOnline
                          ? AppTheme.statusOnline
                          : theme.disabledColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isOnline ? 'delivery.online'.tr() : 'delivery.offline'.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isOnline
                          ? AppTheme.statusOnline
                          : theme.disabledColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: isOnline,
            activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.5),
            onChanged: (value) async {
              setState(() => isOnline = value);
              final result = await getIt<DriverRepository>().updateOnlineStatus(
                value,
              );
              if (!mounted) return;
              result.fold(
                (err) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('common.network_error'.tr())),
                  );
                  setState(() => isOnline = !value);
                },
                (_) {
                  if (value) {
                    _startLocationUpdates();
                  } else {
                    _stopLocationUpdates();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 110,
      decoration: BoxDecoration(
        color: isOnline
            ? theme.colorScheme.primary.withValues(alpha: 0.08)
            : theme.disabledColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOnline
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOnline ? Icons.radar : Icons.power_settings_new,
              size: 34,
              color: isOnline ? theme.colorScheme.primary : theme.disabledColor,
            ),
            const SizedBox(height: 8),
            Text(
              isOnline
                  ? 'delivery.status_waiting'.tr()
                  : 'delivery.status_offline'.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: isOnline
                    ? theme.colorScheme.primary
                    : theme.disabledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStats(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'delivery.todays_earnings'.tr(),
            value: _earningsLoading
                ? '...'
                : '${(_earnings?.today ?? 0).toStringAsFixed(0)} FCFA',
            icon: Icons.account_balance_wallet,
            color: theme.colorScheme.secondary,
            isLoading: _earningsLoading,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'delivery.deliveries'.tr(),
            value: _earningsLoading
                ? '...'
                : '${_earnings?.todayDeliveries ?? 0}',
            icon: Icons.delivery_dining,
            color: theme.colorScheme.primary,
            isLoading: _earningsLoading,
          ),
        ),
      ],
    );
  }

  Widget _buildMissionsAndRecent(ThemeData theme) {
    return BlocBuilder<MissionBloc, MissionState>(
      builder: (context, state) {
        final missions = state.maybeWhen(
          loaded: (m) => m,
          orElse: () => <Map<String, dynamic>>[],
        );
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        final pendingMissions = missions.where((m) {
          final status = m['status'] as String? ?? '';
          return status == 'pending' || status == 'assigned';
        }).toList();

        final recentOrders = (_earnings?.dailyBreakdown ?? []).isEmpty
            ? <Map<String, dynamic>>[]
            : <Map<String, dynamic>>[];

        return ListView(
          children: [
            if (pendingMissions.isNotEmpty) ...[
              Text(
                'delivery.active_missions'.tr(),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...pendingMissions.map(
                (m) => _buildMissionCard(context, m, theme),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              'delivery.recent_deliveries'.tr(),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (recentOrders.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'delivery.no_history'.tr(),
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            else
              ...recentOrders.map((o) => _buildRecentOrderTile(o, theme)),
          ],
        );
      },
    );
  }

  // ─── Navigation (turn-by-turn via external maps app) ──────────────────────

  Future<void> _navigateTo(double lat, double lng, String label) async {
    final encoded = Uri.encodeComponent(label);
    // Try Google Maps first, then fallback to geo: URI
    final gmapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );
    final geoUri = Uri.parse('geo:$lat,$lng?q=$lat,$lng($encoded)');
    if (await canLaunchUrl(gmapsUri)) {
      await launchUrl(gmapsUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    }
  }

  // ─── Photo proof of delivery ──────────────────────────────────────────────

  Future<String?> _pickDeliveryPhoto() async {
    final picker = ImagePicker();
    final choice = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text('delivery.photo_proof_take'.tr()),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text('delivery.photo_proof_gallery'.tr()),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (choice == null) return null;
    final file = await picker.pickImage(source: choice, imageQuality: 70);
    return file?.path;
  }

  // ─── Cash confirmation code ───────────────────────────────────────────────

  Future<String?> _askCashCode() async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('delivery.cash_code_title'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('delivery.cash_code_message'.tr()),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'delivery.cash_code_hint'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text('delivery.cash_code_confirm'.tr()),
          ),
        ],
      ),
    );
  }

  // ─── Confirm delivery flow (photo + optional cash code) ──────────────────

  Future<void> _confirmDelivery(
    BuildContext blocContext,
    String missionId,
    Map<String, dynamic> mission,
  ) async {
    // Step 1: Photo proof
    final photoPath = await _pickDeliveryPhoto();
    if (!mounted) return;
    if (photoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('delivery.photo_proof_missing'.tr())),
      );
      return;
    }

    // Step 2: Cash code (only for cash payment)
    final paymentMethod = mission['paymentMethod'] as String? ?? '';
    Map<String, dynamic> metadata = {};
    try {
      final bytes = await File(photoPath).readAsBytes();
      metadata['photoBase64'] = base64Encode(bytes);
    } catch (_) {
      metadata['photoPath'] = photoPath;
    }

    if (paymentMethod == 'cash') {
      if (!mounted) return;
      final code = await _askCashCode();
      if (!mounted) return;
      if (code == null || code.isEmpty) return;
      metadata['cashCode'] = code;
    }

    // Step 3: Dispatch
    if (!blocContext.mounted) return;
    blocContext.read<MissionBloc>().add(
      MissionEvent.updateStatus(missionId, 'delivered', metadata: metadata),
    );
  }

  Widget _buildRecentOrderTile(Map<String, dynamic> order, ThemeData theme) {
    final orderId = order['_id']?.toString() ?? order['id']?.toString() ?? '#';
    final address = order['deliveryAddress']?['address'] as String? ?? '';
    final amount =
        order['driverEarnings']?.toString() ??
        order['amount']?.toString() ??
        '';
    final shortId = orderId.length > 6
        ? orderId.substring(orderId.length - 6)
        : orderId;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.check_circle_outline,
          color: AppTheme.statusDelivered,
        ),
      ),
      title: Text('#$shortId'),
      subtitle: Text(address),
      trailing: Text(
        '+$amount FCFA',
        style: theme.textTheme.titleSmall?.copyWith(
          color: AppTheme.statusDelivered,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNavigateButton(Map<String, dynamic> mission, String status) {
    // Navigate to restaurant when accepted, to client when in_transit
    final restaurant = mission['restaurant'] as Map<String, dynamic>?;
    final deliveryAddress = mission['deliveryAddress'] as Map<String, dynamic>?;

    double? lat;
    double? lng;
    String label = '';

    if (status == 'accepted' && restaurant != null) {
      final loc = restaurant['location'] as Map<String, dynamic>?;
      lat = (loc?['lat'] ?? loc?['latitude'])?.toDouble();
      lng = (loc?['lng'] ?? loc?['longitude'])?.toDouble();
      label = restaurant['name'] as String? ?? '';
    } else if (status == 'in_transit' && deliveryAddress != null) {
      lat = (deliveryAddress['lat'] ?? deliveryAddress['latitude'])?.toDouble();
      lng = (deliveryAddress['lng'] ?? deliveryAddress['longitude'])
          ?.toDouble();
      label = deliveryAddress['address'] as String? ?? '';
    }

    if (lat == null || lng == null) return const SizedBox.shrink();

    final navLat = lat;
    final navLng = lng;
    final navLabel = label;
    final navKey = status == 'accepted'
        ? 'delivery.navigate_to_restaurant'
        : 'delivery.navigate_to_client';

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _navigateTo(navLat, navLng, navLabel),
        icon: const Icon(Icons.navigation_outlined),
        label: Text(navKey.tr()),
      ),
    );
  }

  Widget _buildMissionCard(
    BuildContext context,
    Map<String, dynamic> mission,
    ThemeData theme,
  ) {
    final missionId =
        mission['_id']?.toString() ?? mission['id']?.toString() ?? '';
    final restaurantName =
        (mission['restaurant'] as Map<String, dynamic>?)?['name'] as String? ??
        '';
    final address =
        (mission['deliveryAddress'] as Map<String, dynamic>?)?['address']
            as String? ??
        '';
    final amount =
        mission['driverEarnings']?.toString() ??
        mission['totalAmount']?.toString() ??
        '--';
    final status = mission['status'] as String? ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.delivery_dining, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    restaurantName.isNotEmpty
                        ? restaurantName
                        : 'delivery.status_waiting'.tr(),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '+$amount FCFA',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            if (address.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(address, style: theme.textTheme.bodySmall),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            if (status == 'pending' || status == 'assigned')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.read<MissionBloc>().add(
                        MissionEvent.rejectMission(missionId),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        side: BorderSide(color: theme.colorScheme.error),
                      ),
                      child: Text('delivery.reject_mission'.tr()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.read<MissionBloc>().add(
                        MissionEvent.acceptMission(missionId),
                      ),
                      child: Text('delivery.accept_mission'.tr()),
                    ),
                  ),
                ],
              )
            else if (status == 'accepted' || status == 'in_transit') ...[
              // Navigation button
              _buildNavigateButton(mission, status),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (status == 'accepted')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.read<MissionBloc>().add(
                          MissionEvent.updateStatus(missionId, 'picked_up'),
                        ),
                        icon: const Icon(Icons.local_shipping_outlined),
                        label: Text('delivery.confirm_pickup'.tr()),
                      ),
                    )
                  else
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _confirmDelivery(context, missionId, mission),
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text('delivery.confirm_delivery'.tr()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.statusDelivered,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
