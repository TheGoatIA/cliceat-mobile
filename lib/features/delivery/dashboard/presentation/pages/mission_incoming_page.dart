import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:logger/logger.dart';

import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/services/websocket_service.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/models/mission_model.dart';
import 'package:cliceat_app/features/delivery/dashboard/presentation/bloc/mission_bloc.dart';

class MissionIncomingPage extends StatefulWidget {
  final MissionModel mission;

  const MissionIncomingPage({super.key, required this.mission});

  @override
  State<MissionIncomingPage> createState() => _MissionIncomingPageState();
}

class _MissionIncomingPageState extends State<MissionIncomingPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  int _timeLeft = 30;
  Timer? _timer;
  StreamSubscription<Map<String, dynamic>>? _missionTakenSub;
  final _logger = Logger();
  bool _accepted = false; // garde contre double-acceptation

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
    _logger.i('[Mission] Popup ouvert pour orderId: ${widget.mission.id}');

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Countdown de 30s
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
        if (_timeLeft <= 10) HapticFeedback.vibrate();
      } else {
        _timer?.cancel();
        _onTimeout();
      }
    });

    // Écouter si un autre driver prend la mission avant nous
    _missionTakenSub = getIt<WebSocketService>().missionTakenEvents.listen((
      data,
    ) {
      final takenOrderId = data['orderId']?.toString();
      if (takenOrderId == widget.mission.id && mounted) {
        _logger.i(
          '[Mission] Mission ${widget.mission.id} prise par un autre driver',
        );
        _timer?.cancel();
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('delivery.mission_taken_by_other'.tr()),
            backgroundColor: AppTheme.honey,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });
  }

  void _onTimeout() {
    if (mounted) {
      context.read<MissionBloc>().add(
        MissionEvent.rejectMission(widget.mission.id),
      );
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('delivery.mission_expired'.tr()),
          backgroundColor: AppTheme.ink,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _missionTakenSub?.cancel();
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MissionBloc, MissionState>(
      listener: (context, state) {
        state.maybeWhen(
          actionSuccess: (message) {
            if (message == 'mission.accepted' && _accepted) {
              context.pushReplacement(
                '/delivery/active-navigation',
                extra: widget.mission,
              );
            }
          },
          error: (errorMsg) {
            if (_accepted) {
              setState(() => _accepted = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMsg.tr()),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: AppTheme.ink,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SafeArea(
              child: Column(
                children: [
                  _buildTimerBar(),
                  const SizedBox(height: 16),
                  _buildRealMap(),
                  const SizedBox(height: 16),
                  _buildOrderDetails(),
                  const Spacer(),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, _) => Transform.scale(
              scale: _timeLeft <= 10
                  ? 0.95 + _pulseController.value * 0.1
                  : 1.0,
              child: Text(
                '$_timeLeft s',
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: _timeLeft <= 10 ? AppTheme.honey : Colors.white,
                  letterSpacing: -2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _timeLeft / 30,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(
                _timeLeft > 10 ? AppTheme.green : AppTheme.honey,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'delivery.new_mission'.tr().toUpperCase(),
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.6),
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealMap() {
    final lat = widget.mission.restaurantLat ?? 4.0511;
    final lng = widget.mission.restaurantLng ?? 9.7093;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 180,
      decoration: BoxDecoration(
        color: AppTheme.inkSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            MapWidget(
              key: const ValueKey("incomingMissionMapPreview"),
              styleUri: MapboxStyles.MAPBOX_STREETS,
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(lng, lat)),
                zoom: 15.0,
                pitch: 45.0,
              ),
              onMapCreated: (mapboxMap) {
                mapboxMap.gestures.updateSettings(
                  GesturesSettings(
                    scrollEnabled: false,
                    pinchToZoomEnabled: false,
                    pitchEnabled: false,
                    rotateEnabled: false,
                    doubleTapToZoomInEnabled: false,
                    doubleTouchToZoomOutEnabled: false,
                  ),
                );
                mapboxMap.scaleBar.updateSettings(
                  ScaleBarSettings(enabled: false),
                );
                mapboxMap.compass.updateSettings(
                  CompassSettings(enabled: false),
                );
                mapboxMap.attribution.updateSettings(
                  AttributionSettings(enabled: false),
                );
                mapboxMap.logo.updateSettings(LogoSettings(enabled: false));
              },
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Icon(
                  Icons.location_on_rounded,
                  color: AppTheme.honey,
                  size: 40,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppTheme.ink.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'delivery.waiting'.tr(),
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'delivery.restaurant_view'.tr(),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.storefront_rounded,
            iconBg: AppTheme.honeySoft,
            iconColor: AppTheme.honey,
            title:
                widget.mission.restaurantName ??
                'delivery.unknown_restaurant'.tr(),
            subtitle:
                widget.mission.restaurantAddress ??
                'delivery.unknown_address'.tr(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Container(height: 1, color: AppTheme.lineSoft),
          ),
          _buildDetailRow(
            icon: Icons.person_rounded,
            iconBg: AppTheme.greenSoft,
            iconColor: AppTheme.green,
            title: 'Client: ${widget.mission.clientName ?? "Anonyme"}',
            subtitle:
                widget.mission.deliveryAddress?.address ??
                'delivery.unknown_delivery_address'.tr(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Container(height: 1, color: AppTheme.lineSoft),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'delivery.estimated_gain'.tr(),
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
              ),
              Text(
                '+${widget.mission.earnings.toStringAsFixed(0)} FCFA',
                style: GoogleFonts.bricolageGrotesque(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: AppTheme.green,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppTheme.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(color: AppTheme.muted, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (_accepted) return; // Guard contre double-tap
              if (widget.mission.id.isEmpty) {
                _logger.e('[Mission] Impossible d\'accepter: ID vide');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('delivery.mission_id_missing'.tr()),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                return;
              }

              setState(() => _accepted = true);
              _timer?.cancel();
              HapticFeedback.heavyImpact();
              _logger.i('[Mission] Acceptation orderId: ${widget.mission.id}');

              context.read<MissionBloc>().add(
                MissionEvent.acceptMission(widget.mission.id),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: _accepted
                    ? AppTheme.green.withValues(alpha: 0.6)
                    : AppTheme.green,
                borderRadius: BorderRadius.circular(30),
                boxShadow: _accepted
                    ? []
                    : [
                        BoxShadow(
                          color: AppTheme.green.withValues(alpha: 0.4),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 5,
                    top: 4,
                    bottom: 4,
                    child: Container(
                      width: 52,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: _accepted
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppTheme.green,
                              ),
                            )
                          : const Icon(
                              Icons.check_rounded,
                              color: AppTheme.green,
                              size: 24,
                            ),
                    ),
                  ),
                  Center(
                    child: Text(
                      _accepted
                          ? 'delivery.accepting'.tr()
                          : 'delivery.accept_mission'.tr(),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              _timer?.cancel();
              context.read<MissionBloc>().add(
                MissionEvent.rejectMission(widget.mission.id),
              );
              context.pop();
            },
            child: Text(
              'delivery.reject'.tr(),
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
