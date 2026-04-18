import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/models/mission_model.dart';
import 'package:cliceat_app/features/delivery/dashboard/presentation/bloc/mission_bloc.dart';

class MissionIncomingPage extends StatefulWidget {
  final MissionModel mission;
  
  const MissionIncomingPage({super.key, required this.mission});

  @override
  State<MissionIncomingPage> createState() => _MissionIncomingPageState();
}

class _MissionIncomingPageState extends State<MissionIncomingPage> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  int _timeLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Simulate high priority strong vibration
    HapticFeedback.heavyImpact();
    
    _pulseController = AnimationController(
       vsync: this,
       duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
        if (_timeLeft <= 10) {
           HapticFeedback.vibrate(); // Tick sound/vibration
        }
      } else {
        _timer?.cancel();
        _onTimeout();
      }
    });
  }

  void _onTimeout() {
    if (mounted) {
       getIt<MissionBloc>().add(MissionEvent.rejectMission(widget.mission.id));
       context.pop(); // return to dashboard
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('delivery.mission_expired'.tr())),
       );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SafeArea(
            child: Column(
              children: [
                _buildTimerBar(),
                const SizedBox(height: 24),
                _buildRealMap(),
                const SizedBox(height: 24),
                _buildOrderDetails(),
                const Spacer(),
                _buildActionButtons(),
              ],
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
          Text(
            '$_timeLeft s',
             style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _timeLeft / 30,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(_timeLeft > 10 ? Colors.green : Colors.red),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            'delivery.new_mission'.tr().toUpperCase(),
            style: const TextStyle(color: Colors.white70, letterSpacing: 1.5, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  // Displaying an actual map preview instead of a static image
  Widget _buildRealMap() {
    final lat = widget.mission.restaurantLat ?? 4.0511; // Default Douala
    final lng = widget.mission.restaurantLng ?? 9.7093;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            MapWidget(
              key: const ValueKey("incomingMissionMapPreview"),
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(lng, lat)),
                zoom: 15.0,
                pitch: 45.0,
              ),
              onMapCreated: (mapboxMap) {
                // Disable map interactions for this preview card
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
              },
            ),
            // A static pin in the center to represent the restaurant
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Icon(Icons.location_on, color: Colors.orange, size: 40),
              ),
            ),
            // The gradient overlay
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withValues(alpha: 0.0), Colors.black.withValues(alpha: 0.8)],
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                     Text('delivery.waiting'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                     Text('delivery.restaurant_view'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
       margin: const EdgeInsets.symmetric(horizontal: 24),
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(16),
       ),
       child: Column(
         children: [
           Row(
             children: [
               Container(
                 padding: const EdgeInsets.all(10),
                 decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), shape: BoxShape.circle),
                 child: const Icon(Icons.storefront, color: Colors.orange),
               ),
               const SizedBox(width: 16),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(widget.mission.restaurantName ?? 'delivery.unknown_restaurant'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                     Text(widget.mission.restaurantAddress ?? 'delivery.unknown_address'.tr(), style: const TextStyle(color: Colors.grey)),
                   ]
                 )
               )
             ]
           ),
           const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
           Row(
             children: [
               Container(
                 padding: const EdgeInsets.all(10),
                 decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), shape: BoxShape.circle),
                 child: const Icon(Icons.person, color: Colors.green),
               ),
               const SizedBox(width: 16),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text('Client: ${widget.mission.clientName ?? "Anonyme"}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                     Text(widget.mission.deliveryAddress?.address ?? 'delivery.unknown_delivery_address'.tr(), style: const TextStyle(color: Colors.grey)),
                   ]
                 )
               )
             ]
           ),
           const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text('delivery.estimated_gain'.tr(), style: const TextStyle(fontSize: 16, color: Colors.black54)),
               Text('${widget.mission.earnings.toStringAsFixed(0)} FCFA', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.green)),
             ]
           )
         ],
       ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Slide to accept (simulated by a wide button for now, or dismissible)
          Dismissible(
            key: const Key('accept_slider'),
            direction: DismissDirection.startToEnd,
            onDismissed: (_) {
              _timer?.cancel();
              HapticFeedback.heavyImpact();
              getIt<MissionBloc>().add(MissionEvent.acceptMission(widget.mission.id));
              // Navigate to active navigation
              context.pushReplacement('/delivery/active-navigation', extra: widget.mission);
            },
            background: Container(
               decoration: BoxDecoration(
                 color: Colors.green,
                 borderRadius: BorderRadius.circular(30)
               ),
               alignment: Alignment.centerLeft,
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: const Icon(Icons.check, color: Colors.white, size: 32),
            ),
            child: Container(
               width: double.infinity,
               height: 60,
               decoration: BoxDecoration(
                 color: Colors.green.shade600,
                 borderRadius: BorderRadius.circular(30),
                 boxShadow: [
                   BoxShadow(color: Colors.green.withValues(alpha: 0.5), blurRadius: 15, spreadRadius: 2)
                 ]
               ),
               child: Stack(
                 children: [
                   Positioned(
                     left: 5, top: 4, bottom: 4,
                     child: Container(
                       width: 52,
                       decoration: const BoxDecoration(
                         color: Colors.white,
                         shape: BoxShape.circle,
                       ),
                       child: const Icon(Icons.arrow_forward_ios, color: Colors.green),
                     ),
                   ),
                   Center(
                     child: Text(
                       'delivery.swipe_to_accept'.tr(),
                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                     ),
                   )
                 ],
               ),
            ),
          ),
           TextButton(
             onPressed: () {
               HapticFeedback.mediumImpact();
               _timer?.cancel();
               getIt<MissionBloc>().add(MissionEvent.rejectMission(widget.mission.id));
               context.pop();
             },
             child: Text('delivery.reject'.tr(), style: const TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
