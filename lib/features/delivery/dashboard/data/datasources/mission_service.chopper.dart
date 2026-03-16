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
  Future<Response<Map<String, dynamic>>> getActiveMissions() {
    final Uri $url = Uri.parse('/missions');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> acceptMission(String id) {
    final Uri $url = Uri.parse('/missions/${id}/accept');
    final Request $request = Request('PATCH', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> rejectMission(String id) {
    final Uri $url = Uri.parse('/missions/${id}/reject');
    final Request $request = Request('PATCH', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
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
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> reportMission(
    String id,
    Map<String, dynamic> reportData,
  ) {
    final Uri $url = Uri.parse('/missions/${id}/report');
    final $body = reportData;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
