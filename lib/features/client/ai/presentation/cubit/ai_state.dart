part of 'ai_cubit.dart';

@freezed
class AiState with _$AiState {
  const factory AiState.loading() = _Loading;

  const factory AiState.chat({
    required String conversationId,
    required List<AiMessageModel> messages,
    required bool isTyping,
    @Default(false) bool offlineError,
    @Default([]) List<AiSuggestionModel> suggestions,
  }) = _Chat;

  const factory AiState.error(String message) = _Error;
}
