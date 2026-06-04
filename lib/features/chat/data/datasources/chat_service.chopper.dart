// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'chat_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ChatService extends ChatService {
  _$ChatService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ChatService;

  @override
  Future<Response<Map<String, dynamic>>> createConversation(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/chat/conversations');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getConversations({
    int page = 1,
    int limit = 20,
    String? status,
  }) {
    final Uri $url = Uri.parse('/chat/conversations');
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
      'limit': limit,
      'status': status,
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
  Future<Response<Map<String, dynamic>>> getMessages(
    String conversationId, {
    int page = 1,
    int limit = 50,
  }) {
    final Uri $url = Uri.parse(
      '/chat/conversations/${conversationId}/messages',
    );
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
      'limit': limit,
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
  Future<Response<Map<String, dynamic>>> sendMessage(
    String conversationId,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse(
      '/chat/conversations/${conversationId}/messages',
    );
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> sendMessageMultipart(
    String conversationId,
    String content,
    String filePath,
  ) {
    final Uri $url = Uri.parse(
      '/chat/conversations/${conversationId}/messages',
    );
    final List<PartValue> $parts = <PartValue>[
      PartValue<String>('content', content),
      PartValueFile<String>('file', filePath),
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
  Future<Response<Map<String, dynamic>>> markAsRead(String conversationId) {
    final Uri $url = Uri.parse('/chat/conversations/${conversationId}/read');
    final Request $request = Request('PATCH', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> closeConversation(
    String conversationId,
  ) {
    final Uri $url = Uri.parse('/chat/conversations/${conversationId}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getUnreadCount() {
    final Uri $url = Uri.parse('/chat/unread');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}
