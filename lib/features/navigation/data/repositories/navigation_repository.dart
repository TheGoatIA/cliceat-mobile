import '../../../../core/network/services/navigation_service.dart';
import '../models/osrm_route_model.dart';

class NavigationRepository {
  final NavigationService _service;

  NavigationRepository(this._service);

  Future<NavigationRouteResponse> computeRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String? orderId,
  }) async {
    final response = await _service.computeRoute({
      'originLat': originLat,
      'originLng': originLng,
      'destLat': destLat,
      'destLng': destLng,
      if (orderId != null) 'orderId': orderId,
    });
    if (!response.isSuccessful) {
      throw Exception('Failed to compute route: ${response.statusCode}');
    }
    final body = response.body as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    return NavigationRouteResponse.fromJson(data);
  }

  Future<NavigationRouteResponse> reroute({
    required double currentLat,
    required double currentLng,
    required double destLat,
    required double destLng,
    required String orderId,
  }) async {
    final response = await _service.reroute({
      'currentLat': currentLat,
      'currentLng': currentLng,
      'destLat': destLat,
      'destLng': destLng,
      'orderId': orderId,
    });
    if (!response.isSuccessful) {
      throw Exception('Reroute failed: ${response.statusCode}');
    }
    final body = response.body as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    return NavigationRouteResponse.fromJson(data);
  }
}
