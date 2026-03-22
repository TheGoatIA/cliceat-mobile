// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'driver_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$DriverService extends DriverService {
  _$DriverService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = DriverService;

  @override
  Future<Response<Map<String, dynamic>>> getMyEarnings() {
<<<<<<< HEAD
    final Uri $url = Uri.parse('/delivery/me/earnings');
=======
    final Uri $url = Uri.parse('/drivers/me/earnings');
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> updateStatus(
    Map<String, dynamic> statusData,
  ) {
<<<<<<< HEAD
    final Uri $url = Uri.parse('/delivery/me/status');
=======
    final Uri $url = Uri.parse('/drivers/me/status');
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    final $body = statusData;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
<<<<<<< HEAD

  @override
  Future<Response<Map<String, dynamic>>> updateLocation(
    Map<String, dynamic> locationData,
  ) {
    final Uri $url = Uri.parse('/delivery/me/location');
    final $body = locationData;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
=======
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
}
