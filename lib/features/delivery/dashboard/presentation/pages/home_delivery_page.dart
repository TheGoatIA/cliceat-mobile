import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/services/websocket_service.dart';
import '../../data/datasources/driver_service.dart';
import '../bloc/mission_bloc.dart';

// Android-specific background location settings
const _androidLocationSettings = AndroidSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 15,
  forceLocationManager: false,
  intervalDuration: Duration(seconds: 5),
  foregroundNotificationConfig: ForegroundNotificationConfig(
    notificationText: 'ClicEat : suivi de position en cours',
    notificationTitle: 'ClicEat Livreur',
    enableWakeLock: true,
  ),
);

const _appleLocationSettings = AppleSettings(
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

  // Earnings data
  Map<String, dynamic>? _earningsData;
  bool _earningsLoading = true;

  // GPS location stream (background-safe)
  StreamSubscription<Position>? _locationSubscription;

  // Mission BLoC — created here so WebSocket events can dispatch to it
  late final MissionBloc _missionBloc;
  StreamSubscription<Map<String, dynamic>>? _wsSubscription;

  @override
  void initState() {
    super.initState();
    _missionBloc = getIt<MissionBloc>()
      ..add(const MissionEvent.loadActiveMissions());
    // Re-load missions whenever a new one is dispatched via WebSocket
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
    try {
      final res = await getIt<DriverService>().getMyEarnings();
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        setState(() {
          _earningsData = (body['data'] as Map<String, dynamic>?) ?? body;
          _earningsLoading = false;
        });
      } else {
        setState(() => _earningsLoading = false);
      }
    } catch (e) {
      _logger.e('Failed to load earnings: $e');
      setState(() => _earningsLoading = false);
    }
  }

  Future<void> _startLocationUpdates() async {
    // Check / request permissions before starting stream
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _logger.w('Location permission denied — cannot track GPS.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('delivery.location_permission_required'.tr())),
        );
      }
      return;
    }

    // Use platform-specific settings that survive backgrounding
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

    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen(
      (position) {
        try {
          getIt<DriverService>().updateLocation({
            'lat': position.latitude,
            'lng': position.longitude,
          });
          getIt<WebSocketService>()
              .emitLocationUpdate(position.latitude, position.longitude);
        } catch (e) {
          _logger.w('GPS update failed: $e');
        }
      },
      onError: (e) => _logger.w('GPS stream error: $e'),
    );
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message.tr())),
              );
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message.tr()), backgroundColor: theme.colorScheme.error),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildOnlineToggle(theme),
                const SizedBox(height: 24),
                _buildStatusCard(theme),
                const SizedBox(height: 24),
                _buildTodayStats(theme),
                const SizedBox(height: 24),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green : theme.disabledColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isOnline ? 'delivery.online'.tr() : 'delivery.offline'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isOnline ? Colors.green : theme.disabledColor,
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
              try {
                await getIt<DriverService>().updateStatus({'isOnline': value});
                if (value) {
                  _startLocationUpdates();
                } else {
                  _stopLocationUpdates();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('common.network_error'.tr())),
                  );
                  setState(() => isOnline = !value);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: isOnline ? theme.colorScheme.primary.withValues(alpha: 0.1) : theme.disabledColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOnline ? theme.colorScheme.primary.withValues(alpha: 0.3) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOnline ? Icons.radar : Icons.power_settings_new,
              size: 36,
              color: isOnline ? theme.colorScheme.primary : theme.disabledColor,
            ),
            const SizedBox(height: 8),
            Text(
              isOnline ? 'delivery.status_waiting'.tr() : 'delivery.status_offline'.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: isOnline ? theme.colorScheme.primary : theme.disabledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStats(ThemeData theme) {
    final todayEarnings = _earningsData?['today']?.toString() ??
        _earningsData?['todayEarnings']?.toString() ?? '--';
    final deliveryCount = _earningsData?['todayDeliveries']?.toString() ??
        _earningsData?['deliveryCount']?.toString() ?? '--';

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            title: 'delivery.todays_earnings'.tr(),
            value: _earningsLoading ? '...' : '$todayEarnings FCFA',
            icon: Icons.account_balance_wallet,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'delivery.deliveries'.tr(),
            value: _earningsLoading ? '...' : deliveryCount,
            icon: Icons.delivery_dining,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, {required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMissionsAndRecent(ThemeData theme) {
    return BlocBuilder<MissionBloc, MissionState>(
      builder: (context, state) {
        final missions = state.maybeWhen(loaded: (m) => m, orElse: () => <Map<String, dynamic>>[]);
        final pendingMissions = missions.where((m) {
          final status = m['status'] as String? ?? '';
          return status == 'pending' || status == 'assigned';
        }).toList();
        final recentOrders = (_earningsData?['recentOrders'] as List<dynamic>?) ?? [];

        return ListView(
          children: [
            if (pendingMissions.isNotEmpty) ...[
              Text('delivery.status_waiting'.tr(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...pendingMissions.map((mission) => _buildMissionCard(context, mission, theme)),
              const SizedBox(height: 24),
            ],
            Text('delivery.recent_deliveries'.tr(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (state is _Loading)
              const Center(child: CircularProgressIndicator())
            else if (recentOrders.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text('delivery.no_history'.tr(), style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                ),
              )
            else
              ...recentOrders.map((o) {
                final order = o as Map<String, dynamic>;
                final orderId = order['_id']?.toString() ?? order['id']?.toString() ?? '#';
                final address = order['deliveryAddress']?['address'] as String? ?? '';
                final amount = order['driverEarnings']?.toString() ?? order['amount']?.toString() ?? '';
                final shortId = orderId.length > 6 ? orderId.substring(orderId.length - 6) : orderId;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.check_circle, color: Colors.green),
                  ),
                  title: Text('${'order.order_id'.tr()}$shortId'),
                  subtitle: Text(address),
                  trailing: Text(
                    '+$amount FCFA',
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                );
              }),
          ],
        );
      },
    );
  }

  Widget _buildMissionCard(BuildContext context, Map<String, dynamic> mission, ThemeData theme) {
    final missionId = mission['_id']?.toString() ?? mission['id']?.toString() ?? '';
    final restaurantName = (mission['restaurant'] as Map<String, dynamic>?)?['name'] as String? ?? '';
    final address = (mission['deliveryAddress'] as Map<String, dynamic>?)?['address'] as String? ?? '';
    final amount = mission['driverEarnings']?.toString() ?? mission['totalAmount']?.toString() ?? '--';
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
                    restaurantName.isNotEmpty ? restaurantName : 'delivery.status_waiting'.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('+$amount FCFA', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            if (address.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Expanded(child: Text(address, style: theme.textTheme.bodySmall)),
                ],
              ),
            ],
            const SizedBox(height: 12),
            if (status == 'pending' || status == 'assigned')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.read<MissionBloc>().add(MissionEvent.rejectMission(missionId)),
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
                      onPressed: () => context.read<MissionBloc>().add(MissionEvent.acceptMission(missionId)),
                      child: Text('delivery.accept_mission'.tr()),
                    ),
                  ),
                ],
              )
            else if (status == 'accepted' || status == 'in_transit')
              Row(
                children: [
                  if (status == 'accepted')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.read<MissionBloc>().add(MissionEvent.updateStatus(missionId, 'picked_up')),
                        icon: const Icon(Icons.local_shipping_outlined),
                        label: Text('delivery.confirm_pickup'.tr()),
                      ),
                    )
                  else
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.read<MissionBloc>().add(MissionEvent.updateStatus(missionId, 'delivered')),
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text('delivery.confirm_delivery'.tr()),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
