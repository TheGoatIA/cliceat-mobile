import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logger/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/services/websocket_service.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/repositories/driver_repository.dart';
import '../../data/models/earnings_model.dart';
import '../../data/models/mission_model.dart';
import '../bloc/mission_bloc.dart';
import '../../../../../shared/widgets/stat_card.dart';
import '../../../../../core/services/analytics_service.dart';

class HomeDeliveryPage extends StatefulWidget {
  const HomeDeliveryPage({super.key});

  @override
  State<HomeDeliveryPage> createState() => _HomeDeliveryPageState();
}

class _HomeDeliveryPageState extends State<HomeDeliveryPage>
    with SingleTickerProviderStateMixin {
  bool _isOnline = false;
  bool _isTogglingStatus = false;
  final Logger _logger = Logger();

  EarningsModel? _earnings;
  bool _earningsLoading = true;

  StreamSubscription<Position>? _locationSubscription;
  late final MissionBloc _missionBloc;
  StreamSubscription<Map<String, dynamic>>? _wsSubscription;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _missionBloc = getIt<MissionBloc>()
      ..add(MissionEvent.loadActiveMissions());

    _wsSubscription = getIt<WebSocketService>().missionEvents.listen((data) {
      _missionBloc.add(MissionEvent.loadActiveMissions());
      if (mounted && _isOnline) {
        try {
          final mission = MissionModel.fromJson(data);
          context.push('/delivery/incoming', extra: mission);
        } catch (e) {
          _logger.e('Error parsing mission from websocket: $e');
        }
      }
    });

    _loadEarnings();
  }

  @override
  void dispose() {
    _pulseController.dispose();
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

  /// Toggle le statut online/offline et le synchronise avec le backend.
  Future<void> _toggleOnlineStatus(bool newValue) async {
    if (_isTogglingStatus) return;
    HapticFeedback.mediumImpact();

    setState(() => _isTogglingStatus = true);

    final result =
        await getIt<DriverRepository>().updateOnlineStatus(newValue);

    if (!mounted) return;
    result.fold(
      (err) {
        _logger.e('Failed to update online status: ${err.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('delivery.status_update_failed'.tr()),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        setState(() => _isTogglingStatus = false);
      },
      (_) {
        setState(() {
          _isOnline = newValue;
          _isTogglingStatus = false;
        });

        // Démarrer/arrêter la géolocalisation selon le statut
        if (_isOnline) {
          _startLocationTracking();
        } else {
          _stopLocationTracking();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isOnline
                  ? 'delivery.now_online'.tr()
                  : 'delivery.now_offline'.tr(),
            ),
            backgroundColor:
                _isOnline ? AppTheme.successColor : AppTheme.statusDefault,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Analytics
        if (_isOnline) {
          getIt<AnalyticsService>().logDriverOnline(true);
        } else {
          getIt<AnalyticsService>().logDriverOnline(false);
        }
      },
    );
  }

  void _startLocationTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 30,
      ),
    ).listen((pos) {
      getIt<DriverRepository>().updateLocation(pos.latitude, pos.longitude);
    });
  }

  void _stopLocationTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(theme, isDark),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildOnlineToggle(theme),
                  const SizedBox(height: 20),
                  _buildStatusCard(theme),
                  const SizedBox(height: 24),
                  _buildTodayStats(theme),
                  const SizedBox(height: 24),
                  _buildRecentMissions(theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme, bool isDark) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      backgroundColor: AppTheme.bg,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryRed,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.delivery_dining,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            'delivery.dashboard_title'.tr(),
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppTheme.ink,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
      actions: [
        StreamBuilder<Object>(
          stream: getIt<WebSocketService>().statusStream,
          builder: (_, _) => Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: getIt<WebSocketService>().isConnected
                  ? AppTheme.successColor.withValues(alpha: 0.1)
                  : AppTheme.statusDefault.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: getIt<WebSocketService>().isConnected
                        ? AppTheme.successColor
                        : AppTheme.statusDefault,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  getIt<WebSocketService>().isConnected ? 'WS' : 'Off',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: getIt<WebSocketService>().isConnected
                        ? AppTheme.successColor
                        : AppTheme.statusDefault,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
      ],
    );
  }

  Widget _buildOnlineToggle(ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: _isOnline
            ? LinearGradient(
                colors: [
                  AppTheme.successColor.withValues(alpha: 0.15),
                  AppTheme.successColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: _isOnline ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isOnline
              ? AppTheme.successColor.withValues(alpha: 0.4)
              : AppTheme.lineSoft,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _isOnline
                ? AppTheme.successColor.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Animated status indicator
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (_, child) => Transform.scale(
              scale: _isOnline ? _pulseAnimation.value : 1.0,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _isOnline
                      ? AppTheme.successColor.withValues(alpha: 0.15)
                      : AppTheme.bgWarm,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isOnline ? Icons.wifi_tethering : Icons.wifi_tethering_off,
                  color: _isOnline
                      ? AppTheme.successColor
                      : AppTheme.muted,
                  size: 26,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'delivery.status_label'.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.muted,
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    key: ValueKey(_isOnline),
                    _isOnline
                        ? 'delivery.online'.tr()
                        : 'delivery.offline'.tr(),
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _isOnline
                          ? AppTheme.green
                          : AppTheme.muted,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isTogglingStatus)
            const SizedBox(
              width: 40,
              height: 24,
              child: Center(
                child:
                    CircularProgressIndicator(strokeWidth: 2.5),
              ),
            )
          else
            Transform.scale(
              scale: 1.1,
              child: Switch(
                value: _isOnline,
                activeTrackColor:
                    AppTheme.successColor.withValues(alpha: 0.4),
                activeThumbColor: AppTheme.successColor,
                inactiveTrackColor: AppTheme.bgWarm,
                onChanged: _toggleOnlineStatus,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: 110,
      decoration: BoxDecoration(
        gradient: _isOnline
            ? const LinearGradient(
                colors: [AppTheme.primaryRed, AppTheme.redDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: _isOnline ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: _isOnline
            ? [
                BoxShadow(
                  color: AppTheme.primaryRed.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ]
            : null,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isOnline ? Icons.radar : Icons.power_settings_new,
              size: 40,
              color: _isOnline ? Colors.white : AppTheme.muted,
            ),
            const SizedBox(height: 8),
            Text(
              _isOnline
                  ? 'delivery.waiting_mission'.tr()
                  : 'delivery.go_online_hint'.tr(),
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _isOnline ? Colors.white : AppTheme.muted,
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
            icon: Icons.account_balance_wallet_outlined,
            color: AppTheme.honey,
            isLoading: _earningsLoading,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'delivery.deliveries_today'.tr(),
            value: _earningsLoading
                ? '...'
                : '${_earnings?.todayDeliveries ?? 0}',
            icon: Icons.delivery_dining_outlined,
            color: AppTheme.primaryRed,
            isLoading: _earningsLoading,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentMissions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'delivery.recent_deliveries'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<MissionBloc, MissionState>(
          bloc: _missionBloc,
          builder: (context, state) {
            return state.maybeWhen(
              loaded: (missionsData) {
                final missions = missionsData
                    .map((m) => MissionModel.fromJson(m))
                    .where((m) => m.status == 'delivered')
                    .toList();

                if (missions.isEmpty) {
                  return _buildEmptyMissions(theme);
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: missions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _buildMissionCard(missions[index], theme),
                );
              },
              orElse: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyMissions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: AppTheme.muted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'delivery.no_recent_deliveries'.tr(),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.muted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(MissionModel mission, ThemeData theme) {
    final shortId = mission.id.length > 6
        ? mission.id.substring(mission.id.length - 6)
        : mission.id;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.successColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: AppTheme.successColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'delivery.order_short_id'.tr(args: [shortId]),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'delivery.delivered_to'.tr(
                      args: [mission.clientName ?? 'Client']),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${mission.earnings.toStringAsFixed(0)} FCFA',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.green,
            ),
          ),
        ],
      ),
    );
  }
}
