import 'core/config/flavor_config.dart';
import 'main_common.dart';

/// Point d'entrée du flavor STAGING.
///
/// Build : flutter run --flavor staging -t lib/main_staging.dart
void main() {
  FlavorConfig.initialize(
    flavor: Flavor.staging,
    apiBaseUrl: const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://staging-api.cliceat.cm/api/v1',
    ),
    wsUrl: const String.fromEnvironment(
      'WS_URL',
      defaultValue: 'wss://staging-api.cliceat.cm',
    ),
    mapboxToken: const String.fromEnvironment(
      'MAPBOX_ACCESS_TOKEN',
      defaultValue: '',
    ),
  );
  mainCommon();
}
