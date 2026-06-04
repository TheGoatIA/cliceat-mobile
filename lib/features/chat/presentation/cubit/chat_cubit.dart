import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/models/chat_model.dart';
import 'chat_state.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/services/websocket_service.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;
  StreamSubscription? _wsSubscription;

  ChatCubit(this._repository) : super(const ChatState.initial()) {
    // Listen to WS for real-time messages
    // Note: Assuming websocket service exposes a stream for chat events
  }

  void initGlobalChatListeners() {
    _wsSubscription?.cancel();
    _wsSubscription = getIt<WebSocketService>().chatEvents.listen((event) {
      _handleNewMessageFromWs(event);
    });
  }

  void _handleNewMessageFromWs(Map<String, dynamic> event) {
    if (event['type'] == 'new_message') {
      final msgJson = event['message'] as Map<String, dynamic>;
      final newMessage = MessageModel.fromJson(msgJson);

      state.maybeWhen(
        messagesLoaded: (conversation, messages) {
          if (conversation.id == newMessage.conversationId) {
            final updated = List<MessageModel>.from(messages)
              ..insert(0, newMessage);
            emit(
              ChatState.messagesLoaded(
                conversation: conversation,
                messages: updated,
              ),
            );
          } else {
            // Un message est reçu mais on n'est pas sur la même conversation. On actualise les conversations
            loadConversations();
          }
        },
        conversationsLoaded: (conversations, unreadCount) {
          // Si on est sur la liste des chats, on recharge
          loadConversations();
        },
        orElse: () {},
      );
    }
  }

  @override
  Future<void> close() {
    _wsSubscription?.cancel();
    return super.close();
  }

  Future<void> loadConversations() async {
    emit(const ChatState.loading());
    final res = await _repository.getConversations();
    final unreadRes = await _repository.getUnreadCount();

    int unread = 0;
    unreadRes.fold((_) {}, (c) => unread = c);

    res.fold(
      (err) => emit(ChatState.error(err.message)),
      (conversations) => emit(
        ChatState.conversationsLoaded(
          conversations: _sortConversations(conversations),
          unreadCount: unread,
        ),
      ),
    );
  }

  Future<void> loadMessages(ConversationModel conversation) async {
    emit(const ChatState.loading());
    final res = await _repository.getMessages(conversation.id);

    // Mark as read asynchronously
    if (conversation.unreadCount > 0) {
      _repository.markAsRead(conversation.id);
    }

    res.fold(
      (err) => emit(ChatState.error(err.message)),
      (messages) => emit(
        ChatState.messagesLoaded(
          conversation: conversation,
          messages: _sortMessages(messages),
        ),
      ),
    );
  }

  Future<Either<AppError, MessageModel>> sendMessage(
    String conversationId,
    String content, {
    File? file,
  }) async {
    // Optimistic UI could be implemented here
    final res = await _repository.sendMessage(
      conversationId: conversationId,
      content: content,
      file: file,
    );

    res.fold((err) {}, (newMessage) {
      state.maybeWhen(
        messagesLoaded: (conversation, messages) {
          final updated = List<MessageModel>.from(messages)
            ..insert(0, newMessage);
          emit(
            ChatState.messagesLoaded(
              conversation: conversation,
              messages: updated,
            ),
          );
        },
        orElse: () {},
      );
    });
    return res;
  }

  Future<void> createSupportConversation() async {
    emit(const ChatState.loading());
    final res = await _repository.createOrGetConversation(type: 'support');
    res.fold(
      (err) => emit(ChatState.error(err.message)),
      (conversation) => loadMessages(conversation),
    );
  }

  List<ConversationModel> _sortConversations(List<ConversationModel> list) {
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  List<MessageModel> _sortMessages(List<MessageModel> list) {
    // Sort descending (newest first for reversed list view)
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }
}
