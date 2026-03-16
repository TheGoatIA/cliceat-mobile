import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/services.dart';

class ClientTrackingPage extends StatefulWidget {
  final String orderId;
  const ClientTrackingPage({super.key, required this.orderId});

  @override
  State<ClientTrackingPage> createState() => _ClientTrackingPageState();
}

class _ClientTrackingPageState extends State<ClientTrackingPage> {
  MapboxMap? mapboxMap;
  final int _currentStep = 1; // 0=Received, 1=Preparing, 2=On the way, 3=Delivered

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    // Load custom ClicEat style for the client
    // Here we would also add a marker for the driver and animate its position
    // based on real-time WebSocket or Firebase Realtime Database updates.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // The Map Layer
          MapWidget(
            key: const ValueKey("clientTrackingMap"),
            onMapCreated: _onMapCreated,
            cameraOptions: CameraOptions(
               center: Point(coordinates: Position(9.7679, 4.0511)), // Douala
               zoom: 14.0,
            ),
          ),

          // Return Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: CircleAvatar(
              backgroundColor: theme.cardTheme.color,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.pop();
                },
              ),
            ),
          ),

          // Status Panel at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: _buildTrackingPanel(theme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingPanel(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5))
        ]
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle for sliding (visual only for now)
            Center(
               child: Container(
                 margin: const EdgeInsets.only(top: 12, bottom: 16),
                 width: 40,
                 height: 4,
                 decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
               ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Arrivée estimée', style: theme.textTheme.bodySmall),
                      Text('14:45', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Dans 15 min', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurfaceVariant)),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            _buildStepper(theme),
            const SizedBox(height: 24),
            const Divider(),
            
            // Driver info
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage('https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=200&auto=format&fit=crop'),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                           color: Colors.white,
                           shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star, color: Colors.amber, size: 20),
                      )
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jean-Paul Livreur', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Row(
                           children: [
                             const Icon(Icons.two_wheeler, size: 16, color: Colors.grey),
                             const SizedBox(width: 4),
                             Text('Yamaha noire - LT 142 AZ', style: theme.textTheme.bodySmall),
                           ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                       CircleAvatar(
                         backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                         child: IconButton(
                           icon: Icon(Icons.call, color: theme.colorScheme.primary),
                           onPressed: () {
                             HapticFeedback.selectionClick();
                           },
                         ),
                       ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStepper(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              _buildStepCircle(0, theme),
              _buildStepLine(0, theme),
              _buildStepCircle(1, theme),
              _buildStepLine(1, theme),
              _buildStepCircle(2, theme),
              _buildStepLine(2, theme),
              _buildStepCircle(3, theme),
            ],
          ),
          const SizedBox(height: 8),
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text('Approuvé', style: TextStyle(fontSize: 10, color: _currentStep >= 0 ? theme.colorScheme.primary : Colors.grey)),
               Text('Préparation', style: TextStyle(fontSize: 10, color: _currentStep >= 1 ? theme.colorScheme.primary : Colors.grey)),
               Text('En route', style: TextStyle(fontSize: 10, color: _currentStep >= 2 ? theme.colorScheme.primary : Colors.grey)),
               Text('Livré', style: TextStyle(fontSize: 10, color: _currentStep >= 3 ? theme.colorScheme.primary : Colors.grey)),
             ],
          )
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, ThemeData theme) {
    bool isCompleted = _currentStep >= step;
    bool isActive = _currentStep == step;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isCompleted ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: isActive ? Border.all(color: theme.colorScheme.primaryContainer, width: 4) : null,
      ),
      child: isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
    );
  }

  Widget _buildStepLine(int step, ThemeData theme) {
    bool isCompleted = _currentStep > step;
    return Expanded(
      child: Container(
        height: 4,
        color: isCompleted ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
