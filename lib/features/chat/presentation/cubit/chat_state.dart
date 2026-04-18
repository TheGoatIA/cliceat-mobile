import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/chat_model.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = _Initial;
  const factory ChatState.loading() = _Loading;
  
  const factory ChatState.conversationsLoaded({
    required List<ConversationModel> conversations,
    required int unreadCount,
  }) = _ConversationsLoaded;
  
  const factory ChatState.messagesLoaded({
    required ConversationModel conversation,
    required List<MessageModel> messages,
  }) = _MessagesLoaded;
  
  const factory ChatState.error(String message) = _Error;
}
