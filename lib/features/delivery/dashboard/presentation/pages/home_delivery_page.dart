import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logger/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _hasPromptedResume = false;

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

    _missionBloc = getIt<MissionBloc>()..add(MissionEvent.loadActiveMissions());

    _wsSubscription = getIt<WebSocketService>().missionEvents.listen((data) {
      _missionBloc.add(MissionEvent.loadActiveMissions());
      _loadEarnings();
    });

    _loadEarnings();
    _loadInitialStatus();
  }

  Future<void> _loadInitialStatus() async {
    final result = await getIt<DriverRepository>().getProfile();
    if (!mounted) return;
    result.fold(
      (err) => _logger.e('Failed to load initial status: ${err.message}'),
      (profile) {
        setState(() {
          _isOnline = profile['isOnline'] as bool? ?? false;
        });
        if (_isOnline) {
          _startLocationTracking();
        }
      },
    );
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

    final result = await getIt<DriverRepository>().updateOnlineStatus(newValue);

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
            backgroundColor: _isOnline
                ? AppTheme.successColor
                : AppTheme.statusDefault,
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

    // Envoyer la position actuelle immédiatement dès la mise en ligne,
    // sans attendre un déplacement de 30m. Sinon le backend n'a jamais
    // les coordonnées du livreur et le dispatch échoue ("no drivers available").
    Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        )
        .then((pos) {
          getIt<DriverRepository>().updateLocation(pos.latitude, pos.longitude);
          _logger.i(
            '[GPS] Position initiale envoyée: ${pos.latitude}, ${pos.longitude}',
          );
        })
        .catchError((e) {
          _logger.e('[GPS] Erreur position initiale: $e');
        });

    // Puis continuer le suivi en continu
    _locationSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, // Réduit à 10m pour meilleure réactivité
          ),
        ).listen((pos) {
          getIt<DriverRepository>().updateLocation(pos.latitude, pos.longitude);
        });
  }

  void _stopLocationTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  void _promptResumeDelivery(MissionModel mission) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppTheme.primaryRed,
              size: 28,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Livraison en cours',
                style: GoogleFonts.bricolageGrotesque(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppTheme.ink,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Vous avez une commande en cours de livraison (#${mission.id.substring(mission.id.length - 6).toUpperCase()}). '
          'Souhaitez-vous reprendre la navigation immédiatement ?',
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.inkSoft),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Plus tard',
              style: GoogleFonts.inter(
                color: AppTheme.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final Future<dynamic> nav = context.push(
                '/delivery/active-navigation',
                extra: mission,
              );
              nav.then((_) {
                if (!mounted) return;
                _missionBloc.add(MissionEvent.loadActiveMissions());
                _loadEarnings();
                _hasPromptedResume = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(
              'Reprendre',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<MissionBloc, MissionState>(
      bloc: _missionBloc,
      listener: (context, state) {
        state.maybeWhen(
          loaded: (missionsData) {
            final allMissions = missionsData
                .map((m) => MissionModel.fromJson(m))
                .toList();

            final activeMissions = allMissions
                .where(
                  (m) =>
                      m.status != 'delivered' &&
                      m.status != 'cancelled' &&
                      m.status != 'anomaly',
                )
                .toList();

            if (activeMissions.isNotEmpty && !_hasPromptedResume) {
              _hasPromptedResume = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _promptResumeDelivery(activeMissions.first);
              });
            }
          },
          actionSuccess: (_) {
            _loadEarnings();
            _missionBloc.add(MissionEvent.loadActiveMissions());
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: context.colors.bg,
        body: RefreshIndicator(
          color: AppTheme.primaryRed,
          backgroundColor: Colors.white,
          onRefresh: () async {
            HapticFeedback.mediumImpact();
            await Future.wait([_loadEarnings(), _loadInitialStatus()]);
            _missionBloc.add(MissionEvent.loadActiveMissions());
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                      const SizedBox(height: 16),
                      _buildWalletTile(),
                      const SizedBox(height: 24),
                      _buildMissionsSection(theme),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme, bool isDark) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      backgroundColor: context.colors.bg,
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
            child: const Icon(
              Icons.delivery_dining,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'delivery.dashboard_title'.tr(),
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: context.colors.ink,
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
          onPressed: () {
            context.push('/delivery/notifications');
          },
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
        color: _isOnline ? null : context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isOnline
              ? AppTheme.successColor.withValues(alpha: 0.4)
              : context.colors.lineSoft,
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
                  color: _isOnline ? AppTheme.successColor : AppTheme.muted,
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
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.muted),
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
                      color: _isOnline ? AppTheme.green : AppTheme.muted,
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
              child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
            )
          else
            Transform.scale(
              scale: 1.1,
              child: Switch(
                value: _isOnline,
                activeTrackColor: AppTheme.successColor.withValues(alpha: 0.4),
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
                ),
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

  Widget _buildWalletTile() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        context.push('/delivery/wallet');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.lineSoft),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                color: AppTheme.green,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'delivery.wallet_title'.tr(),
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: context.colors.ink,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.mutedLight,
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

  String _getStatusLabel(String status) {
    switch (status) {
      case 'accepted':
      case 'confirmed':
        return 'order.status_confirmed'.tr();
      case 'preparing':
        return 'order.status_preparing'.tr();
      case 'ready':
        return 'order.status_ready'.tr();
      case 'picked_up':
        return 'order.status_picked_up'.tr();
      case 'en_route':
        return 'order.status_en_route'.tr();
      default:
        return status;
    }
  }

  Widget _buildActiveMissionCard(MissionModel mission, ThemeData theme) {
    final shortId = mission.id.length > 6
        ? mission.id.substring(mission.id.length - 6)
        : mission.id;

    final isEnRoute =
        mission.status == 'picked_up' || mission.status == 'en_route';
    final statusColor = isEnRoute ? AppTheme.primaryRed : AppTheme.honey;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getStatusLabel(mission.status),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'delivery.order_short_id'.tr(args: [shortId]),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: context.colors.ink,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppTheme.lineSoft),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.storefront_outlined,
                      color: AppTheme.muted,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mission.restaurantName ?? 'Restaurant',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: context.colors.ink,
                            ),
                          ),
                          Text(
                            mission.restaurantAddress ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.muted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 9, top: 4, bottom: 4),
                    width: 2,
                    height: 16,
                    color: AppTheme.lineSoft,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppTheme.muted,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mission.clientName ?? 'Client',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: context.colors.ink,
                            ),
                          ),
                          Text(
                            mission.deliveryAddress?.address ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.muted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (mission.clientPhone != null &&
                        mission.clientPhone!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.phone_in_talk_rounded,
                          color: AppTheme.green,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () async {
                          final phone = mission.clientPhone;
                          if (phone == null || phone.isEmpty) return;
                          HapticFeedback.mediumImpact();
                          final cleaned = phone.replaceAll(RegExp(r'\s+'), '');
                          final uri = Uri.parse('tel:$cleaned');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'delivery.estimated_gain'.tr(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.muted,
                      ),
                    ),
                    Text(
                      '${mission.earnings.toStringAsFixed(0)} FCFA',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.green,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    final Future<dynamic> nav = context.push(
                      '/delivery/active-navigation',
                      extra: mission,
                    );
                    nav.then((_) {
                      if (!mounted) return;
                      _missionBloc.add(MissionEvent.loadActiveMissions());
                      _loadEarnings();
                      _hasPromptedResume = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'delivery.navigate'.tr(),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionsSection(ThemeData theme) {
    return BlocBuilder<MissionBloc, MissionState>(
      bloc: _missionBloc,
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (missionsData) {
            final allMissions = missionsData
                .map((m) => MissionModel.fromJson(m))
                .toList();

            final activeMissions = allMissions
                .where(
                  (m) =>
                      m.status != 'delivered' &&
                      m.status != 'cancelled' &&
                      m.status != 'anomaly',
                )
                .toList();

            final recentMissions = allMissions
                .where((m) => m.status == 'delivered')
                .take(5)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (activeMissions.isNotEmpty) ...[
                  Text(
                    'delivery.active_missions'.tr(),
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.ink,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...activeMissions.map(
                    (m) => _buildActiveMissionCard(m, theme),
                  ),
                  const SizedBox(height: 24),
                ],
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
                if (recentMissions.isEmpty)
                  _buildEmptyMissions(theme)
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentMissions.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) =>
                        _buildMissionCard(recentMissions[index], theme),
                  ),
              ],
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
    );
  }

  Widget _buildEmptyMissions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.lineSoft),
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
            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
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
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.lineSoft),
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
                    color: context.colors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'delivery.delivered_to'.tr(
                    args: [mission.clientName ?? 'Client'],
                  ),
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.muted),
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
