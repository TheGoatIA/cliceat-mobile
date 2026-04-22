import 'package:cliceat_app/features/delivery/dashboard/data/models/mission_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';

class ActiveNavigationPage extends StatefulWidget {
  final MissionModel mission;
  const ActiveNavigationPage({super.key, required this.mission});

  @override
  State<ActiveNavigationPage> createState() => _ActiveNavigationPageState();
}

class _ActiveNavigationPageState extends State<ActiveNavigationPage> {
  MapboxMap? mapboxMap;
  final String _currentInstruction = 'Tournez à droite sur Rue Sylvie';
  final String _distanceToTurn = '150 m';
  final String _totalEta = '12 min';
  final String _totalDistance = '2.5 km';

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  @override
  Widget build(BuildContext context) {
    final isRestaurantPhase = widget.mission.status == 'accepted';

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey("navigationMap"),
            onMapCreated: _onMapCreated,
            styleUri: MapboxStyles.MAPBOX_STREETS,
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(9.7679, 4.0511)),
              zoom: 17.0,
              pitch: 60.0,
              bearing: 45.0,
            ),
          ),
          _buildTopPanel(),
          _buildBottomPanel(isRestaurantPhase),
          Positioned(
            right: 16,
            bottom: 180,
            child: FloatingActionButton(
              heroTag: 'recenter_nav',
              backgroundColor: Colors.white,
              onPressed: () {},
              child: const Icon(Icons.gps_fixed, color: AppTheme.primaryRed),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopPanel() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 24,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(24)),
              boxShadow: AppTheme.shadowMd,
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.redSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.turn_right,
                      size: 36, color: AppTheme.primaryRed),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _distanceToTurn,
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.ink,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        _currentInstruction,
                        style: GoogleFonts.inter(
                            fontSize: 14, color: AppTheme.inkSoft),
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

  Widget _buildBottomPanel(bool isRestaurantPhase) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
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
                            '$_totalEta • $_totalDistance',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.ink,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            isRestaurantPhase
                                ? 'Destination: ${widget.mission.restaurantName}'
                                : 'Destination: ${widget.mission.clientName}',
                            style: GoogleFonts.inter(
                                fontSize: 13, color: AppTheme.muted),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _confirmExitNavigation();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.redSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.close,
                              color: AppTheme.primaryRed, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRestaurantPhase
                            ? AppTheme.primaryRed
                            : AppTheme.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (isRestaurantPhase) {
                          context.push('/delivery/confirm-pickup',
                              extra: widget.mission);
                        } else {
                          context.push('/delivery/dropoff',
                              extra: widget.mission);
                        }
                      },
                      child: Text(
                        isRestaurantPhase
                            ? 'delivery.arrived_at_restaurant'.tr()
                            : 'delivery.arrived_at_client'.tr(),
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmExitNavigation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'delivery.quit_navigation'.tr(),
          style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700, fontSize: 18, color: AppTheme.ink),
        ),
        content: Text(
          'delivery.quit_warning'.tr(),
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.inkSoft),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text('common.cancel'.tr(),
                style: GoogleFonts.inter(color: AppTheme.muted)),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              context.pop();
            },
            child: Text(
              'delivery.quit'.tr(),
              style: GoogleFonts.inter(
                  color: AppTheme.primaryRed, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
