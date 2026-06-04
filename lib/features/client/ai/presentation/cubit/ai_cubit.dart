import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/ai_repository.dart';
import '../../data/models/ai_model.dart';
import 'ai_state.dart';

@injectable
class AiCubit extends Cubit<AiState> {
  final AiRepository _repository;
  final List<AiMessageModel> _messages = [];

  AiCubit(this._repository) : super(const AiState.initial());

  void initChat(String locale) {
    if (_messages.isEmpty) {
      _messages.add(
        AiMessageModel(
          role: 'model',
          content: locale == 'fr'
              ? "Bonjour ! Je suis ClicEat AI, votre assistant culinaire. Que désirez-vous manger aujourd'hui ?"
              : "Hello! I am ClicEat AI, your food assistant. What would you like to eat today?",
        ),
      );
    }
    emit(AiState.idle(messages: List.from(_messages)));
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(AiMessageModel(role: 'user', content: text));
    emit(const AiState.typing());

    // Send only up to last 10 messages for context
    final history = _messages.length > 10
        ? _messages.sublist(_messages.length - 10)
        : _messages;

    final res = await _repository.sendMessage(text, history);

    res.fold((err) => emit(AiState.error(err.message)), (reply) {
      _messages.add(AiMessageModel(role: 'model', content: reply));
      emit(AiState.idle(messages: List.from(_messages)));
    });
  }
}
