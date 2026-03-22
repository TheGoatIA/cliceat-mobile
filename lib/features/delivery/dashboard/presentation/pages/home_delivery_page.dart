import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/services/websocket_service.dart';
import '../../data/repositories/driver_repository.dart';
import '../../data/models/earnings_model.dart';
import '../bloc/mission_bloc.dart';
import '../../../../../shared/widgets/stat_card.dart';

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



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('delivery.dashboard_title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              Text('Statut', style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isOnline ? 'delivery.online'.tr() : 'delivery.offline'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isOnline ? Colors.green : Colors.grey,
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
            activeThumbColor: theme.colorScheme.primary,
            onChanged: (value) {
              setState(() {
                isOnline = value;
              });
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
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.grey.shade100,
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
              size: 48,
              color: isOnline ? theme.colorScheme.primary : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              isOnline
                  ? 'delivery.waiting_mission'.tr()
                  : 'Vous êtes hors ligne',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isOnline ? theme.colorScheme.primary : Colors.grey,
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




  Widget _buildRecentDeliveries(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dernières livraisons', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle, color: Colors.green),
              ),
              title: const Text('Commande #10842'),
              subtitle: const Text('Livré à 14:30 • Akwa'),
              trailing: Text(
                '+1500 FCFA',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
