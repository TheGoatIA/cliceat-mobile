// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'banner_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$BannerService extends BannerService {
  _$BannerService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = BannerService;

  @override
  Future<Response<dynamic>> getBanners() {
    final Uri $url = Uri.parse('/banners/');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
