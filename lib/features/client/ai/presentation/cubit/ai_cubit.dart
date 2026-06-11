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

  AiCubit(this._repository) : super(const AiState.initial(conversations: []));

  Future<void> loadConversations() async {
    final conversations = await _repository.getLocalConversations();
    emit(AiState.conversationList(conversations: conversations));
  }

  Future<void> openConversation(String conversationId) async {
    final messages = await _repository.getLocalMessages(conversationId);
    emit(AiState.chat(
      conversationId: conversationId,
      messages: messages,
      isTyping: false,
    ));
  }

  Future<void> newConversation() async {
    final id = await _repository.createLocalConversation('Nouvelle conversation');
    emit(AiState.chat(
      conversationId: id,
      messages: const [],
      isTyping: false,
    ));
  }

  Future<void> archiveConversation(String conversationId) async {
    await _repository.archiveLocalConversation(conversationId);
    await loadConversations();
  }

  Future<void> sendMessage(String text) async {
    final currentState = state;
    if (currentState is! _Chat) return;
    if (text.trim().isEmpty) return;

    final updatedMessages = [
      ...currentState.messages,
      AiMessageModel(role: 'user', content: text, createdAt: DateTime.now()),
    ];

    emit(AiState.chat(
      conversationId: currentState.conversationId,
      messages: updatedMessages,
      isTyping: true,
    ));

    final history = updatedMessages.length > 10
        ? updatedMessages.sublist(updatedMessages.length - 10)
        : updatedMessages;

    final conv = await _repository.getLocalConversation(currentState.conversationId);

    final result = await _repository.sendMessage(
      localConversationId: currentState.conversationId,
      message: text,
      history: history,
      serverConversationId: conv?.serverId,
    );

    result.fold(
      (error) {
        emit(AiState.chat(
          conversationId: currentState.conversationId,
          messages: updatedMessages,
          isTyping: false,
          offlineError: true,
        ));
      },
      (modelMessage) {
        final finalMessages = [...updatedMessages, modelMessage];
        emit(AiState.chat(
          conversationId: currentState.conversationId,
          messages: finalMessages,
          isTyping: false,
        ));
      },
    );
  }

  Future<void> loadSuggestions(String city) async {
    final result = await _repository.getSuggestions(city);
    result.fold(
      (_) {},
      (suggestions) {
        final current = state;
        if (current is _Chat) {
          emit(current.copyWith(suggestions: suggestions));
        }
      },
    );
  }
}
