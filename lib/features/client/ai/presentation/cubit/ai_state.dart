part of 'ai_cubit.dart';

@freezed
class AiState with _$AiState {
  const factory AiState.idle() = _Idle;
  const factory AiState.loading() = _Loading;

  const factory AiState.chat({
    required String conversationId,
    required List<AiMessageModel> messages,
    required bool isTyping,
    @Default(false) bool offlineError,
    @Default([]) List<AiSuggestionModel> suggestions,
  }) = _Chat;

  const factory AiState.error(String message) = _Error;

  // ── Photo Order ──────────────────────────────────────────────────────────
  const factory AiState.photoOrderResult({
    required List<Map<String, dynamic>> items,
    required String message,
  }) = _PhotoOrderResult;

  // ── Quality Check ────────────────────────────────────────────────────────
  const factory AiState.qualityResult({
    required Map<String, dynamic> scores,
    required int overall,
    required String feedback,
    required String recommendation,
  }) = _QualityResult;

  // ── Gastro Guide chat ─────────────────────────────────────────────────────
  const factory AiState.gastroChat({
    required List<Map<String, dynamic>> history,
    required bool isTyping,
  }) = _GastroChat;
}
