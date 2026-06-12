// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'restaurant_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$RestaurantService extends RestaurantService {
  _$RestaurantService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = RestaurantService;

  @override
  Future<Response<dynamic>> getRestaurants(
    String city,
    double? radius,
    double? lat,
    double? lng,
    int? page,
    int? limit,
  ) {
    final Uri $url = Uri.parse('/restaurants');
    final Map<String, dynamic> $params = <String, dynamic>{
      'city': city,
      'radius': radius,
      'lat': lat,
      'lng': lng,
      'page': page,
      'limit': limit,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getFeaturedRestaurants(String? city) {
    final Uri $url = Uri.parse('/restaurants/featured');
    final Map<String, dynamic> $params = <String, dynamic>{'city': city};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> searchRestaurants(
    String query,
    int? page,
    int? limit,
  ) {
    final Uri $url = Uri.parse('/restaurants/search');
    final Map<String, dynamic> $params = <String, dynamic>{
      'q': query,
      'page': page,
      'limit': limit,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getRestaurantDetails(String id) {
    final Uri $url = Uri.parse('/restaurants/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getRestaurantMenu(String id) {
    final Uri $url = Uri.parse('/restaurants/${id}/menu');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> toggleFavorite(String id) {
    final Uri $url = Uri.parse('/restaurants/${id}/favorite');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
