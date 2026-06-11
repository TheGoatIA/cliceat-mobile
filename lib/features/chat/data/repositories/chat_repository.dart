import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/features/chat/data/datasources/chat_service.dart';
import 'package:cliceat_app/features/chat/data/models/chat_model.dart';
import 'package:drift/drift.dart' as drift;
import 'dart:convert';
import 'package:cliceat_app/core/data/local/daos/chat_dao.dart';
import 'package:cliceat_app/core/data/local/daos/pending_actions_dao.dart';
import 'package:cliceat_app/core/data/local/database.dart';

@injectable
class ChatRepository {
  final ChatService _chatService;
  final ChatDao _chatDao;
  final PendingActionsDao _pendingActionsDao;

  ChatRepository(this._chatService, this._chatDao, this._pendingActionsDao);

  Future<Either<AppError, ConversationModel>> createOrGetConversation({
    required String type,
    String? restaurantId,
    String? orderId,
  }) async {
    try {
      final res = await _chatService.createConversation(
        {'type': type, 'restaurantId': restaurantId, 'orderId': orderId}
          ..removeWhere((k, v) => v == null),
      );
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>;
        return Right(ConversationModel.fromJson(data));
      }
      return Left(AppError.fromResponse(res.body, 'chat.error_create'));
    } catch (e, s) {
      debugPrint('[chat_repository.dart] createOrGetConversation error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, List<ConversationModel>>> getConversations({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    try {
      final res = await _chatService.getConversations(
        page: page,
        limit: limit,
        status: status,
      );
      if (res.isSuccessful && res.body != null) {
        final raw = res.body!['data'] ?? res.body!['items'] ?? [];
        final data = raw as List;
        final list = data
            .map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
            .toList();

        // Save to cache
        await _chatDao.upsertConversations(
          list
              .map(
                (c) => ConversationsTableCompanion.insert(
                  id: c.id,
                  type: c.type,
                  participantName: drift.Value(c.participantName),
                  participantAvatar: drift.Value(c.participantAvatar),
                  lastMessageContent: drift.Value(c.lastMessage?.content),
                  lastMessageAt: drift.Value(c.lastMessage?.createdAt),
                  unreadCount: drift.Value(c.unreadCount),
                  updatedAt: drift.Value(c.updatedAt),
                ),
              )
              .toList(),
        );

        return Right(list);
      }
      // Cache fallback
      final cached = await _chatDao.getConversations();
      if (cached.isNotEmpty) return Right(_fromConversationRows(cached));

      return Left(AppError.fromResponse(res.body, 'chat.error_load'));
    } catch (e, s) {
      debugPrint('[chat_repository.dart] getConversations error: $e\n$s');
      final cached = await _chatDao.getConversations();
      if (cached.isNotEmpty) return Right(_fromConversationRows(cached));
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, List<MessageModel>>> getMessages(
    String conversationId, {
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final res = await _chatService.getMessages(
        conversationId,
        page: page,
        limit: limit,
      );
      if (res.isSuccessful && res.body != null) {
        final raw = res.body!['data'] ?? res.body!['items'] ?? [];
        final data = raw as List;
        final list = data
            .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
            .toList();

        // Save to cache
        await _chatDao.upsertMessages(
          list
              .map(
                (m) => MessagesTableCompanion.insert(
                  id: m.id,
                  conversationId: conversationId,
                  senderId: m.senderId,
                  senderRole: m.senderRole,
                  content: m.content,
                  fileUrl: drift.Value(m.fileUrl),
                  messageType: drift.Value(m.type),
                  isRead: drift.Value(m.isRead),
                  createdAt: drift.Value(m.createdAt),
                  status: const drift.Value('sent'),
                ),
              )
              .toList(),
        );

        return Right(list);
      }
      // Cache fallback
      final cached = await _chatDao.getMessages(conversationId);
      if (cached.isNotEmpty) return Right(_fromMessageRows(cached));

      return Left(AppError.fromResponse(res.body, 'chat.error_load_messages'));
    } catch (e, s) {
      debugPrint('[chat_repository.dart] getMessages error: $e\n$s');
      final cached = await _chatDao.getMessages(conversationId);
      if (cached.isNotEmpty) return Right(_fromMessageRows(cached));
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, MessageModel>> sendMessage({
    required String conversationId,
    required String content,
    File? file,
  }) async {
    try {
      final res = file != null
          ? await _chatService.sendMessageMultipart(
              conversationId,
              content,
              file.path,
            )
          : await _chatService.sendMessage(conversationId, {
              'content': content,
            });

      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>;
        final model = MessageModel.fromJson(data);

        // Update cache
        await _chatDao.upsertMessages([
          MessagesTableCompanion.insert(
            id: model.id,
            conversationId: conversationId,
            senderId: model.senderId,
            senderRole: model.senderRole,
            content: model.content,
            fileUrl: drift.Value(model.fileUrl),
            messageType: drift.Value(model.type),
            isRead: drift.Value(model.isRead),
            createdAt: drift.Value(model.createdAt),
            status: const drift.Value('sent'),
          ),
        ]);

        return Right(model);
      }
      return Left(AppError.fromResponse(res.body, 'chat.error_send'));
    } catch (e, s) {
      debugPrint('[chat_repository.dart] sendMessage error: $e\n$s');
      // Offline mode: queue the message
      if (file == null) {
        // We only queue text messages for now to avoid local file management complexity
        final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        final message = MessageModel(
          id: tempId,
          conversationId: conversationId,
          senderId: 'me', // Dummy, will be updated by server
          senderRole: 'client',
          content: content,
          type: 'text',
          createdAt: DateTime.now(),
        );

        await _chatDao.upsertMessages([
          MessagesTableCompanion.insert(
            id: tempId,
            conversationId: conversationId,
            senderId: 'me',
            senderRole: 'client',
            content: content,
            createdAt: drift.Value(message.createdAt),
            status: const drift.Value('pending'),
          ),
        ]);

        await _pendingActionsDao.addPending(
          'send_chat',
          jsonEncode({'conversationId': conversationId, 'content': content}),
        );

        return Right(message);
      }
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> markAsRead(String conversationId) async {
    try {
      final res = await _chatService.markAsRead(conversationId);
      if (res.isSuccessful) return const Right(null);
      return Left(AppError.fromResponse(res.body, 'chat.error_update'));
    } catch (e, s) {
      debugPrint('[chat_repository.dart] markAsRead error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, int>> getUnreadCount() async {
    try {
      final res = await _chatService.getUnreadCount();
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>;
        return Right((data['unreadCount'] as num?)?.toInt() ?? 0);
      }
      return Left(AppError.fromResponse(res.body, 'chat.error_load'));
    } catch (e, s) {
      debugPrint('[chat_repository.dart] getUnreadCount error: $e\n$s');
      return const Right(0);
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  List<ConversationModel> _fromConversationRows(
    List<ConversationsTableData> rows,
  ) {
    return rows
        .map(
          (r) => ConversationModel(
            id: r.id,
            type: r.type,
            participantName: r.participantName,
            participantAvatar: r.participantAvatar,
            unreadCount: r.unreadCount,
            updatedAt: r.updatedAt,
            lastMessage: r.lastMessageContent != null
                ? MessageModel(
                    id: '',
                    conversationId: r.id,
                    senderId: '',
                    senderRole: '',
                    content: r.lastMessageContent!,
                    type: 'text',
                    createdAt: r.lastMessageAt ?? DateTime.now(),
                  )
                : null,
          ),
        )
        .toList();
  }

  List<MessageModel> _fromMessageRows(List<MessagesTableData> rows) {
    return rows
        .map(
          (r) => MessageModel(
            id: r.id,
            conversationId: r.conversationId,
            senderId: r.senderId,
            senderRole: r.senderRole,
            content: r.content,
            fileUrl: r.fileUrl,
            type: r.messageType,
            isRead: r.isRead,
            createdAt: r.createdAt,
          ),
        )
        .toList();
  }
}
