import 'core/config/flavor_config.dart';
import 'main_common.dart';

/// Point d'entrée du flavor PRODUCTION.
///
/// Build : flutter build apk --flavor prod -t lib/main_prod.dart
void main() {
  FlavorConfig.initialize(
    flavor: Flavor.prod,
    apiBaseUrl: const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.cliceat.cm/api/v1',
    ),
    wsUrl: const String.fromEnvironment(
      'WS_URL',
      defaultValue: 'wss://api.cliceat.cm',
    ),
    mapboxToken: const String.fromEnvironment(
      'MAPBOX_ACCESS_TOKEN',
      defaultValue: '',
    ),
  );
  mainCommon();
}
