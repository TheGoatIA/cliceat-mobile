import 'package:cliceat_app/features/delivery/dashboard/data/models/mission_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/services.dart';

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
    final theme = Theme.of(context);
    final isRestaurantPhase = widget.mission.status == 'accepted';

    return Scaffold(
      body: Stack(
        children: [
          // The Map
          MapWidget(
            key: const ValueKey("navigationMap"),
            onMapCreated: _onMapCreated,
            styleUri: theme.brightness == Brightness.dark
                ? MapboxStyles.DARK
                : MapboxStyles.MAPBOX_STREETS,
            cameraOptions: CameraOptions(
               center: Point(coordinates: Position(9.7679, 4.0511)), // Douala
               zoom: 17.0,
               pitch: 60.0,
               bearing: 45.0,
            ),
          ),
          
          _buildTopPanel(theme),
          _buildBottomPanel(theme, isRestaurantPhase),
          
          Positioned(
            right: 16,
            bottom: 180,
            child: FloatingActionButton(
               heroTag: 'recenter_nav',
               backgroundColor: theme.cardTheme.color,
               onPressed: () {},
               child: Icon(Icons.gps_fixed, color: theme.colorScheme.primary),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopPanel(ThemeData theme) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 24, left: 16, right: 16,
            ),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              boxShadow: [
                 BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Icon(Icons.turn_right, size: 40, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_distanceToTurn, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(_currentInstruction, style: theme.textTheme.titleMedium),
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

  Widget _buildBottomPanel(ThemeData theme, bool isRestaurantPhase) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            padding: const EdgeInsets.all(24),
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
                children: [
                  Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('$_totalEta • $_totalDistance', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                           Text(isRestaurantPhase ? 'Destination: ${widget.mission.restaurantName}' : 'Destination: ${widget.mission.clientName}', 
                             style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                         ],
                       ),
                       IconButton(
                         icon: const Icon(Icons.close),
                         style: IconButton.styleFrom(
                           backgroundColor: theme.colorScheme.error.withValues(alpha: 0.1), 
                           foregroundColor: theme.colorScheme.error
                         ),
                         onPressed: () {
                           HapticFeedback.lightImpact();
                           _confirmExitNavigation();
                         },
                       ),
                     ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: isRestaurantPhase ? Colors.blue : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                         HapticFeedback.mediumImpact();
                         if (isRestaurantPhase) {
                           context.push('/delivery/confirm-pickup', extra: widget.mission);
                         } else {
                           context.push('/delivery/dropoff', extra: widget.mission);
                         }
                      },
                      child: Text(
                        isRestaurantPhase ? 'delivery.arrived_at_restaurant'.tr() : 'delivery.arrived_at_client'.tr(), 
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        title: Text('delivery.quit_navigation'.tr()),
        content: Text('delivery.quit_warning'.tr()),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text('common.cancel'.tr())),
          TextButton(
             onPressed: () {
               context.pop(); // close dialog
               context.pop(); // Leave navigation
             },
             child: Text('delivery.quit'.tr(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      )
    );
  }
}
