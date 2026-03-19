import 'core/config/flavor_config.dart';
import 'main_common.dart';

/// Point d'entrée du flavor DEV.
///
/// Build : flutter run --flavor dev -t lib/main_dev.dart
void main() {
  FlavorConfig.initialize(
    flavor: Flavor.dev,
    apiBaseUrl: 'https://dev-api.cliceat.cm/api/v1',
    wsUrl: 'wss://dev-api.cliceat.cm',
    mapboxToken: const String.fromEnvironment(
      'MAPBOX_ACCESS_TOKEN',
      defaultValue: '',
    ),
  );
  mainCommon();
}
