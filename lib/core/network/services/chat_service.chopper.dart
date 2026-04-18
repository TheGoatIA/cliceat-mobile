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
  Future<Response<dynamic>> createConversation(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/chat/conversations');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getConversations() {
    final Uri $url = Uri.parse('/chat/conversations');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getMessages(String conversationId) {
    final Uri $url =
        Uri.parse('/chat/conversations/$conversationId/messages');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendMessage(
    String conversationId,
    Map<String, dynamic> body,
  ) {
    final Uri $url =
        Uri.parse('/chat/conversations/$conversationId/messages');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> markAsRead(String conversationId) {
    final Uri $url =
        Uri.parse('/chat/conversations/$conversationId/read');
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getUnreadCount() {
    final Uri $url = Uri.parse('/chat/unread');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
