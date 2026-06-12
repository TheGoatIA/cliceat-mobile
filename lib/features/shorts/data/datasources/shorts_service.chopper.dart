// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'shorts_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ShortsService extends ShortsService {
  _$ShortsService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ShortsService;

  @override
  Future<Response<Map<String, dynamic>>> getFeed({String? city, int page = 1}) {
    final Uri $url = Uri.parse('/shorts/feed');
    final Map<String, dynamic> $params = <String, dynamic>{
      'city': city,
      'page': page,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> uploadShort(
    String orderId,
    List<int> videoBytes,
    String filename,
    int rating,
    String? caption,
  ) {
    final Uri $url = Uri.parse('/shorts/upload');
    final List<PartValue> $parts = <PartValue>[
      PartValue<String>('orderId', orderId),
      PartValue<String>('filename', filename),
      PartValue<int>('rating', rating),
      PartValue<String?>('caption', caption),
      PartValueFile<List<int>>('video', videoBytes),
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

  @override
  Future<Response<Map<String, dynamic>>> likeShort(String id) {
    final Uri $url = Uri.parse('/shorts/${id}/like');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> incrementView(String id) {
    final Uri $url = Uri.parse('/shorts/${id}/view');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
