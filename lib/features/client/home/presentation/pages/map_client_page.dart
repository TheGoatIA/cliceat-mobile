import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:cliceat_app/core/services/location_service.dart';
import 'package:cliceat_app/core/di/injection.dart';

class MapClientPage extends StatefulWidget {
  const MapClientPage({super.key});

  @override
  State<MapClientPage> createState() => _MapClientPageState();
}

class _MapClientPageState extends State<MapClientPage> {
  MapboxMap? mapboxMap;
  geo.Position? currentPosition;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final locationService = getIt<LocationService>();
    final position = await locationService.getCurrentPosition();
    setState(() {
      currentPosition = position;
      isLoading = false;
    });
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    // Activate location puck
    mapboxMap.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: MapWidget(
        key: const ValueKey("mapWidget"),
        cameraOptions: CameraOptions(
          center: currentPosition != null 
              ? Point(coordinates: Position(currentPosition!.longitude, currentPosition!.latitude))
              : Point(coordinates: Position(9.7093, 4.0511)), // Douala par défaut
          zoom: 14.0,
        ),
        onMapCreated: _onMapCreated,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentPosition != null && mapboxMap != null) {
            mapboxMap?.setCamera(
              CameraOptions(
                center: Point(coordinates: Position(currentPosition!.longitude, currentPosition!.latitude)),
                zoom: 16.0,
              )
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
