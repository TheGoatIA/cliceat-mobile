import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/services/chat_service.dart';
import '../../../../core/network/socket_service.dart';

// Events
abstract class ChatEvent {}

class LoadConversations extends ChatEvent {}

class LoadMessages extends ChatEvent {
  final String conversationId;
  LoadMessages(this.conversationId);
}

class SendMessage extends ChatEvent {
  final String conversationId;
  final String content;
  SendMessage(this.conversationId, this.content);
}

class MessageReceived extends ChatEvent {
  final Map<String, dynamic> message;
  MessageReceived(this.message);
}

class MarkRead extends ChatEvent {
  final String conversationId;
  MarkRead(this.conversationId);
}

// State
class ChatState {
  final List<dynamic> conversations;
  final List<dynamic> messages;
  final String? activeConversationId;
  final bool isLoading;
  final bool isSending;
  final String? error;
  final int unreadCount;

  const ChatState({
    this.conversations = const [],
    this.messages = const [],
    this.activeConversationId,
    this.isLoading = false,
    this.isSending = false,
    this.error,
    this.unreadCount = 0,
  });

  ChatState copyWith({
    List<dynamic>? conversations,
    List<dynamic>? messages,
    String? activeConversationId,
    bool? isLoading,
    bool? isSending,
    String? error,
    int? unreadCount,
  }) =>
      ChatState(
        conversations: conversations ?? this.conversations,
        messages: messages ?? this.messages,
        activeConversationId:
            activeConversationId ?? this.activeConversationId,
        isLoading: isLoading ?? this.isLoading,
        isSending: isSending ?? this.isSending,
        error: error,
        unreadCount: unreadCount ?? this.unreadCount,
      );
}

// BLoC
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService;
  final SocketService _socketService;

  ChatBloc(this._chatService, this._socketService)
      : super(const ChatState()) {
    on<LoadConversations>(_onLoadConversations);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<MessageReceived>(_onMessageReceived);
    on<MarkRead>(_onMarkRead);

    // Listen for incoming socket messages
    _socketService.onNewMessage((data) => add(MessageReceived(data)));
  }

  Future<void> _onLoadConversations(
      LoadConversations event, Emitter<ChatState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final resp = await _chatService.getConversations();
      final unreadResp = await _chatService.getUnreadCount();
      if (resp.isSuccessful) {
        final data = resp.body as Map<String, dynamic>;
        final convos = (data['data'] as List?) ?? [];
        final unread = unreadResp.isSuccessful
            ? ((unreadResp.body as Map?)?['count'] as int? ?? 0)
            : 0;
        emit(state.copyWith(
            isLoading: false,
            conversations: convos,
            unreadCount: unread));
      } else {
        emit(state.copyWith(
            isLoading: false,
            error: 'Impossible de charger les conversations'));
      }
    } catch (_) {
      emit(state.copyWith(
          isLoading: false, error: 'Erreur réseau'));
    }
  }

  Future<void> _onLoadMessages(
      LoadMessages event, Emitter<ChatState> emit) async {
    emit(state.copyWith(
        isLoading: true, activeConversationId: event.conversationId));
    _socketService.joinConversation(event.conversationId);
    try {
      final resp =
          await _chatService.getMessages(event.conversationId);
      if (resp.isSuccessful) {
        final data = resp.body as Map<String, dynamic>;
        final msgs = (data['data'] as List?) ?? [];
        emit(state.copyWith(isLoading: false, messages: msgs));
        add(MarkRead(event.conversationId));
      } else {
        emit(state.copyWith(
            isLoading: false,
            error: 'Impossible de charger les messages'));
      }
    } catch (_) {
      emit(state.copyWith(
          isLoading: false, error: 'Erreur réseau'));
    }
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    if (event.content.trim().isEmpty) return;
    emit(state.copyWith(isSending: true));
    try {
      final resp = await _chatService.sendMessage(
          event.conversationId, {'content': event.content.trim()});
      if (resp.isSuccessful) {
        final data = resp.body as Map<String, dynamic>;
        final msg = data['data'] as Map<String, dynamic>?;
        if (msg != null) {
          final msgs = List<dynamic>.from(state.messages)..add(msg);
          emit(state.copyWith(isSending: false, messages: msgs));
        } else {
          emit(state.copyWith(isSending: false));
        }
      } else {
        emit(state.copyWith(
            isSending: false, error: 'Erreur d\'envoi du message'));
      }
    } catch (_) {
      emit(state.copyWith(
          isSending: false, error: 'Erreur réseau'));
    }
  }

  void _onMessageReceived(
      MessageReceived event, Emitter<ChatState> emit) {
    final convId = event.message['conversation'] as String?;
    if (convId == state.activeConversationId) {
      final msgs = List<dynamic>.from(state.messages)
        ..add(event.message);
      emit(state.copyWith(messages: msgs));
    } else {
      emit(state.copyWith(unreadCount: state.unreadCount + 1));
    }
  }

  Future<void> _onMarkRead(
      MarkRead event, Emitter<ChatState> emit) async {
    try {
      await _chatService.markAsRead(event.conversationId);
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _socketService.offChatEvents();
    if (state.activeConversationId != null) {
      _socketService.leaveConversation(state.activeConversationId!);
    }
    return super.close();
  }
}
