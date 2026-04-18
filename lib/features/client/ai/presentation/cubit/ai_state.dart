import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/ai_model.dart';

part 'ai_state.freezed.dart';

@freezed
class AiState with _$AiState {
  const factory AiState.initial() = _Initial;
  const factory AiState.typing() = _Typing;
  const factory AiState.idle({required List<AiMessageModel> messages}) = _Idle;
  const factory AiState.error(String message) = _Error;
}
