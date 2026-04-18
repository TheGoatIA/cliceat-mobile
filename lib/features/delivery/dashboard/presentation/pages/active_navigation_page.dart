import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/services.dart';

class ActiveNavigationPage extends StatefulWidget {
  const ActiveNavigationPage({super.key});

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
    // In a real scenario, this would initialize Mapbox Navigation SDK
    // and start listening to route progress events.
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    // Load custom ClicEat driving style
    // mapboxMap.loadStyleURI('mapbox://styles/yourusername/custom_driving_style');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The Map
          MapWidget(
            key: const ValueKey("navigationMap"),
            onMapCreated: _onMapCreated,
            styleUri: Theme.of(context).brightness == Brightness.dark
                ? MapboxStyles.DARK
                : MapboxStyles.MAPBOX_STREETS,
            cameraOptions: CameraOptions(
               center: Point(coordinates: Position(9.7679, 4.0511)), // Douala
               zoom: 17.0, // High zoom for turn by turn
               pitch: 60.0, // Tilted perspective
               bearing: 45.0, // Direction
            ),
          ),
          
          // Top Navigation Instruction Panel
          Positioned(
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
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                    boxShadow: [
                       BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: Icon(Icons.turn_right, size: 40, color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_distanceToTurn, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Text(_currentInstruction, style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Action Panel
          Positioned(
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
                    color: Theme.of(context).cardTheme.color,
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
                                 Text('Heure d\'arrivée: 14:45', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                               ],
                             ),
                             Row(
                               children: [
                                 IconButton(
                                   icon: const Icon(Icons.close),
                                   style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.1), foregroundColor: Theme.of(context).colorScheme.error),
                                   onPressed: () {
                                     HapticFeedback.lightImpact();
                                     _confirmExitNavigation();
                                   },
                                 ),
                               ],
                             )
                           ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                               HapticFeedback.mediumImpact();
                               context.go('/delivery/confirm-pickup');
                            },
                            child: const Text('Je suis arrivé au Restaurant', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Re-center button
          Positioned(
            right: 16,
            bottom: 180,
            child: FloatingActionButton(
               heroTag: 'recenter_nav',
               backgroundColor: Theme.of(context).cardTheme.color,
               onPressed: () {},
               child: Icon(Icons.gps_fixed, color: Theme.of(context).colorScheme.primary),
            ),
          )
        ],
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
          TextButton(onPressed: () => context.pop(), child: Text('commons.cancel'.tr())),
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
