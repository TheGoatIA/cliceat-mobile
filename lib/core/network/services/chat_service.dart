import 'package:chopper/chopper.dart';

part 'chat_service.chopper.dart';

@ChopperApi(baseUrl: '/chat')
abstract class ChatService extends ChopperService {
  static ChatService create([ChopperClient? client]) =>
      _$ChatService(client);

  @POST(path: '/conversations')
  Future<Response> createConversation(@Body() Map<String, dynamic> body);

  @GET(path: '/conversations')
  Future<Response> getConversations();

  @GET(path: '/conversations/{id}/messages')
  Future<Response> getMessages(@Path('id') String conversationId);

  @POST(path: '/conversations/{id}/messages')
  Future<Response> sendMessage(
    @Path('id') String conversationId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH(path: '/conversations/{id}/read')
  Future<Response> markAsRead(@Path('id') String conversationId);

  @GET(path: '/unread')
  Future<Response> getUnreadCount();
}
