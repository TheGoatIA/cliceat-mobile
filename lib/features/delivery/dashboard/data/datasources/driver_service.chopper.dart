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
  Future<Response<Map<String, dynamic>>> getProfile() {
    final Uri $url = Uri.parse('/delivery/me');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getMyEarnings() {
    final Uri $url = Uri.parse('/delivery/me/earnings');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> updateStatus(
    Map<String, dynamic> statusData,
  ) {
    final Uri $url = Uri.parse('/delivery/me/status');
    final $body = statusData;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

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

  @override
  Future<Response<Map<String, dynamic>>> registerDriver(
    String name,
    String email,
    String phone,
    String password,
    String city,
    String vehicleType,
    String vehiclePlate,
    String idCardPath,
    String licensePath,
    String photoPath,
  ) {
    final Uri $url = Uri.parse('/delivery/register');
    final List<PartValue> $parts = <PartValue>[
      PartValue<String>('name', name),
      PartValue<String>('email', email),
      PartValue<String>('phone', phone),
      PartValue<String>('password', password),
      PartValue<String>('city', city),
      PartValue<String>('vehicleType', vehicleType),
      PartValue<String>('vehiclePlate', vehiclePlate),
      PartValueFile<String>('idCard', idCardPath),
      PartValueFile<String>('license', licensePath),
      PartValueFile<String>('photo', photoPath),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
