// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'mission_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$MissionService extends MissionService {
  _$MissionService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = MissionService;

  @override
<<<<<<< HEAD
  Future<Response<Map<String, dynamic>>> getMyOrders() {
    final Uri $url = Uri.parse('/delivery/me/orders');
=======
  Future<Response<Map<String, dynamic>>> getActiveMissions() {
    final Uri $url = Uri.parse('/missions');
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> acceptMission(String id) {
<<<<<<< HEAD
    final Uri $url = Uri.parse('/delivery/orders/${id}/accept');
=======
    final Uri $url = Uri.parse('/missions/${id}/accept');
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    final Request $request = Request('PATCH', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> rejectMission(String id) {
<<<<<<< HEAD
    final Uri $url = Uri.parse('/delivery/orders/${id}/reject');
=======
    final Uri $url = Uri.parse('/missions/${id}/reject');
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    final Request $request = Request('PATCH', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
<<<<<<< HEAD
  Future<Response<Map<String, dynamic>>> confirmPickup(String id) {
    final Uri $url = Uri.parse('/delivery/orders/${id}/pickup');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> confirmDelivery(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/delivery/orders/${id}/delivered');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
=======
  Future<Response<Map<String, dynamic>>> updateMissionStatus(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/missions/${id}/status');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> reportMission(
    String id,
    Map<String, dynamic> reportData,
  ) {
<<<<<<< HEAD
    final Uri $url = Uri.parse('/delivery/orders/${id}/report');
=======
    final Uri $url = Uri.parse('/missions/${id}/report');
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    final $body = reportData;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
