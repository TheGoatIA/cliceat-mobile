// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'ai_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AiService extends AiService {
  _$AiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AiService;

  @override
  Future<Response<Map<String, dynamic>>> sendMessage(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/ai/chat');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getSuggestions({String? city}) {
    final Uri $url = Uri.parse('/ai/suggestions');
    final Map<String, dynamic> $params = <String, dynamic>{'city': city};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
