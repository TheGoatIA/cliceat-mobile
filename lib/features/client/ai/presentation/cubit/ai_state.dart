part of 'ai_cubit.dart';

@freezed
class AiState with _$AiState {
  const factory AiState.initial({
    required List<AiConversationModel> conversations,
  }) = _Initial;

  const factory AiState.conversationList({
    required List<AiConversationModel> conversations,
  }) = _ConversationList;

  const factory AiState.chat({
    required String conversationId,
    required List<AiMessageModel> messages,
    required bool isTyping,
    @Default(false) bool offlineError,
    @Default([]) List<AiSuggestionModel> suggestions,
  }) = _Chat;

  const factory AiState.error(String message) = _Error;
}
