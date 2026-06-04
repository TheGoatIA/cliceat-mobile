import 'package:chopper/chopper.dart';

part 'chat_service.chopper.dart';

/// Chat endpoints — base: /chat
@ChopperApi(baseUrl: '/chat')
abstract class ChatService extends ChopperService {
  static ChatService create([ChopperClient? client]) => _$ChatService(client);

  /// POST /chat/conversations — Create or get a conversation
  @POST(path: '/conversations')
  Future<Response<Map<String, dynamic>>> createConversation(
    @Body() Map<String, dynamic> body,
  );

  /// GET /chat/conversations — List user conversations
  @GET(path: '/conversations')
  Future<Response<Map<String, dynamic>>> getConversations({
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
    @Query('status') String? status,
  });

  /// GET /chat/conversations/{id}/messages — Get conversation messages
  @GET(path: '/conversations/{id}/messages')
  Future<Response<Map<String, dynamic>>> getMessages(
    @Path('id') String conversationId, {
    @Query('page') int page = 1,
    @Query('limit') int limit = 50,
  });

  /// POST /chat/conversations/{id}/messages — Send a message
  @POST(path: '/conversations/{id}/messages')
  Future<Response<Map<String, dynamic>>> sendMessage(
    @Path('id') String conversationId,
    @Body() Map<String, dynamic> body,
  );

  /// POST /chat/conversations/{id}/messages — Send a message with file (multipart)
  @POST(path: '/conversations/{id}/messages')
  @multipart
  Future<Response<Map<String, dynamic>>> sendMessageMultipart(
    @Path('id') String conversationId,
    @Part('content') String content,
    @PartFile('file') String filePath,
  );

  /// PATCH /chat/conversations/{id}/read — Mark as read
  @PATCH(path: '/conversations/{id}/read')
  Future<Response<Map<String, dynamic>>> markAsRead(
    @Path('id') String conversationId,
  );

  /// DELETE /chat/conversations/{id} — Close conversation
  @DELETE(path: '/conversations/{id}')
  Future<Response<Map<String, dynamic>>> closeConversation(
    @Path('id') String conversationId,
  );

  /// GET /chat/unread — Get total unread count
  @GET(path: '/unread')
  Future<Response<Map<String, dynamic>>> getUnreadCount();
}
