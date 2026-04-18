// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'promotion_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PromotionService extends PromotionService {
  _$PromotionService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PromotionService;

  @override
  Future<Response<Map<String, dynamic>>> getActivePromotions() {
    final Uri $url = Uri.parse('/promotions/active');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getRestaurantPromotions(
    String restaurantId,
  ) {
    final Uri $url = Uri.parse('/promotions/restaurant/${restaurantId}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
