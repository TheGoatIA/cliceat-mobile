import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/ai_model.dart';
import '../../data/repositories/ai_repository.dart';

part 'ai_state.dart';
part 'ai_cubit.freezed.dart';

@injectable
class AiCubit extends Cubit<AiState> {
  final AiRepository _repository;

  AiCubit(this._repository) : super(const AiState.loading());

  /// Charge la conversation existante ou en crée une nouvelle automatiquement.
  Future<void> loadOrCreateConversation() async {
    emit(const AiState.loading());
    final conversations = await _repository.getLocalConversations();
    final String conversationId;
    if (conversations.isNotEmpty) {
      conversationId = conversations.first.id;
    } else {
      conversationId = await _repository.createLocalConversation(
        'Ma conversation',
      );
    }
    final messages = await _repository.getLocalMessages(conversationId);
    emit(
      AiState.chat(
        conversationId: conversationId,
        messages: messages,
        isTyping: false,
      ),
    );
  }

  Future<void> sendMessage(String text) async {
    final currentState = state;
    if (currentState is! _Chat) return;
    if (text.trim().isEmpty) return;

    final updatedMessages = [
      ...currentState.messages,
      AiMessageModel(role: 'user', content: text, createdAt: DateTime.now()),
    ];

    emit(
      AiState.chat(
        conversationId: currentState.conversationId,
        messages: updatedMessages,
        isTyping: true,
        suggestions: currentState.suggestions,
      ),
    );

    final history = updatedMessages.length > 10
        ? updatedMessages.sublist(updatedMessages.length - 10)
        : updatedMessages;

    final conv = await _repository.getLocalConversation(
      currentState.conversationId,
    );

    final result = await _repository.sendMessage(
      localConversationId: currentState.conversationId,
      message: text,
      history: history,
      serverConversationId: conv?.serverId,
    );

    result.fold(
      (error) {
        emit(
          AiState.chat(
            conversationId: currentState.conversationId,
            messages: updatedMessages,
            isTyping: false,
            offlineError: true,
            suggestions: currentState.suggestions,
          ),
        );
      },
      (modelMessage) {
        emit(
          AiState.chat(
            conversationId: currentState.conversationId,
            messages: [...updatedMessages, modelMessage],
            isTyping: false,
            suggestions: currentState.suggestions,
          ),
        );
      },
    );
  }

  Future<void> loadSuggestions(String city) async {
    final result = await _repository.getSuggestions(city);
    result.fold((_) {}, (suggestions) {
      final current = state;
      if (current is _Chat) {
        emit(current.copyWith(suggestions: suggestions));
      }
    });
  }
}
