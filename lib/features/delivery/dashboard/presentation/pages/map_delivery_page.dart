import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:cliceat_app/core/services/location_service.dart';
import 'package:cliceat_app/core/di/injection.dart';

class MapDeliveryPage extends StatefulWidget {
  const MapDeliveryPage({super.key});

  @override
  State<MapDeliveryPage> createState() => _MapDeliveryPageState();
}

class _MapDeliveryPageState extends State<MapDeliveryPage> {
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
    // Activate location puck specifically for delivery (navigation style)
    mapboxMap.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingMaxRadius: 50.0,
      ),
    );
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
    mapboxMap.attribution.updateSettings(AttributionSettings(enabled: false));
    mapboxMap.logo.updateSettings(LogoSettings(enabled: false));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: MapWidget(
        key: const ValueKey("mapDeliveryWidget"),
        styleUri: MapboxStyles.MAPBOX_STREETS,
        cameraOptions: CameraOptions(
          center: currentPosition != null
              ? Point(
                  coordinates: Position(
                    currentPosition!.longitude,
                    currentPosition!.latitude,
                  ),
                )
              : Point(coordinates: Position(9.7093, 4.0511)),
          zoom: 16.0, // Closer zoom for delivery
          pitch: 45.0, // Tilted perspective
        ),
        onMapCreated: _onMapCreated,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentPosition != null && mapboxMap != null) {
            mapboxMap?.setCamera(
              CameraOptions(
                center: Point(
                  coordinates: Position(
                    currentPosition!.longitude,
                    currentPosition!.latitude,
                  ),
                ),
                zoom: 16.0,
                pitch: 45.0,
              ),
            );
          }
        },
        child: const Icon(Icons.navigation),
      ),
    );
  }
}
