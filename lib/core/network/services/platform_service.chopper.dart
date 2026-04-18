// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'platform_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PlatformService extends PlatformService {
  _$PlatformService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PlatformService;

  @override
  Future<Response<Map<String, dynamic>>> getConfig() {
    final Uri $url = Uri.parse('/platform/config');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
