import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/services/websocket_service.dart';
import '../../data/datasources/driver_service.dart';

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

  // GPS location timer
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _loadEarnings();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
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

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );
        getIt<DriverService>().updateLocation({
          'lat': position.latitude,
          'lng': position.longitude,
        });
        getIt<WebSocketService>().emitLocationUpdate(position.latitude, position.longitude);
      } catch (e) {
        _logger.w('GPS update failed: $e');
      }
    });
  }

  void _stopLocationUpdates() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
            _buildRecentDeliveries(theme),
          ],
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
      height: 150,
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
              size: 48,
              color: isOnline ? theme.colorScheme.primary : theme.disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              isOnline ? 'delivery.status_waiting'.tr() : 'delivery.status_offline'.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
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
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRecentDeliveries(ThemeData theme) {
    final recentOrders = (_earningsData?['recentOrders'] as List<dynamic>?) ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('delivery.recent_deliveries'.tr(), style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        if (recentOrders.isEmpty && !_earningsLoading)
          // Fallback placeholder when no real data yet
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 0,
            itemBuilder: (_, __) => const SizedBox(),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentOrders.length,
            itemBuilder: (context, index) {
              final order = recentOrders[index] as Map<String, dynamic>;
              final orderId = order['_id']?.toString() ?? order['id']?.toString() ?? '#';
              final address = order['deliveryAddress']?['address'] as String? ?? '';
              final amount = order['driverEarnings']?.toString() ?? order['amount']?.toString() ?? '';
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
                title: Text('Commande #${orderId.length > 6 ? orderId.substring(orderId.length - 6) : orderId}'),
                subtitle: Text(address),
                trailing: Text(
                  '+$amount FCFA',
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
      ],
    );
  }
}
