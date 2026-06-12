import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/app_error.dart';
import '../../../../../core/network/services/ai_service.dart';
import '../local/ai_dao.dart';
import '../models/ai_model.dart';

@injectable
class AiRepository {
  final AiService _service;
  final AiLocalDao _localDao;

  AiRepository(this._service, this._localDao);

  Future<List<AiConversationModel>> getLocalConversations() async {
    final rows = await _localDao.getConversations();
    return rows
        .map(
          (r) => AiConversationModel(
            id: r.id,
            serverId: r.serverId,
            title: r.title,
            lastMessageAt: r.lastMessageAt,
            isSynced: r.isSynced,
          ),
        )
        .toList();
  }

  Future<AiConversationModel?> getLocalConversation(String id) async {
    final row = await _localDao.getConversation(id);
    if (row == null) return null;
    return AiConversationModel(
      id: row.id,
      serverId: row.serverId,
      title: row.title,
      lastMessageAt: row.lastMessageAt,
      isSynced: row.isSynced,
    );
  }

  Future<List<AiMessageModel>> getLocalMessages(String conversationId) async {
    final rows = await _localDao.getMessages(conversationId);
    return rows
        .map(
          (r) => AiMessageModel(
            role: r.role,
            content: r.content,
            tokenCount: r.tokenCount,
            createdAt: r.createdAt,
          ),
        )
        .toList();
  }

  Future<String> createLocalConversation(String title) =>
      _localDao.createConversation(title);

  Future<void> archiveLocalConversation(String id) =>
      _localDao.archiveConversation(id);

  Future<Either<AppError, AiMessageModel>> sendMessage({
    required String localConversationId,
    required String message,
    required List<AiMessageModel> history,
    String? serverConversationId,
  }) async {
    await _localDao.insertMessage(
      conversationId: localConversationId,
      role: 'user',
      content: message,
    );

    try {
      final response = await _service.sendMessage({
        'message': message,
        'conversationId': serverConversationId,
        'history': history.map((m) => m.toJson()).toList(),
      });

      if (!response.isSuccessful || response.body == null) {
        return Left(AppError.fromResponse(response.body, 'ai.error_chat'));
      }

      final data = response.body!['data'] as Map<String, dynamic>;
      final reply = data['reply'] as String;
      final newServerId = data['conversationId'] as String?;
      final tokenCount = data['tokenCount'] as int?;

      await _localDao.insertMessage(
        conversationId: localConversationId,
        role: 'model',
        content: reply,
        tokenCount: tokenCount,
      );

      if (newServerId != null && serverConversationId == null) {
        await _localDao.updateConversation(
          localConversationId,
          serverId: newServerId,
          isSynced: true,
        );
      }

      return Right(
        AiMessageModel(role: 'model', content: reply, tokenCount: tokenCount),
      );
    } catch (e, s) {
      debugPrint('[ai_repository.dart] sendMessage error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, List<AiSuggestionModel>>> getSuggestions(
    String city,
  ) async {
    try {
      final res = await _service.getSuggestions(city: city);
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as List;
        return Right(
          data
              .map((e) => AiSuggestionModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }
      return Left(AppError.fromResponse(res.body, 'ai.error_suggestions'));
    } catch (e, s) {
      debugPrint('[ai_repository.dart] getSuggestions error: $e\n$s');
      return Left(AppError.network());
    }
  }

  // ── Photo Order ────────────────────────────────────────────────────────────

  Future<Either<AppError, Map<String, dynamic>>> analyzePhotoOrder({
    required List<int> imageBytes,
    required String filename,
    required String restaurantId,
  }) async {
    try {
      final res = await _service.analyzePhotoOrder(
        imageBytes,
        filename,
        restaurantId,
      );
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>?;
        return Right(data ?? res.body!);
      }
      return Left(AppError.fromResponse(res.body, 'ai.error_photo_order'));
    } catch (e, s) {
      debugPrint('[ai_repository.dart] analyzePhotoOrder error: $e\n$s');
      return Left(AppError.network());
    }
  }

  // ── Quality Check ──────────────────────────────────────────────────────────

  Future<Either<AppError, Map<String, dynamic>>> checkQuality({
    required List<int> imageBytes,
    required String filename,
    String? orderId,
  }) async {
    try {
      final res = await _service.checkQuality(imageBytes, filename, orderId);
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>?;
        return Right(data ?? res.body!);
      }
      return Left(AppError.fromResponse(res.body, 'ai.error_quality'));
    } catch (e, s) {
      debugPrint('[ai_repository.dart] checkQuality error: $e\n$s');
      return Left(AppError.network());
    }
  }

  // ── Gastro Guide ───────────────────────────────────────────────────────────

  Future<Either<AppError, String>> askGastroGuide({
    required String question,
    required List<Map<String, dynamic>> history,
  }) async {
    try {
      final res = await _service.askGastroGuide({
        'question': question,
        'history': history,
      });
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'];
        final reply =
            (data is Map ? data['reply'] : res.body!['reply']) as String?;
        return Right(reply ?? '');
      }
      return Left(AppError.fromResponse(res.body, 'ai.error_gastro'));
    } catch (e, s) {
      debugPrint('[ai_repository.dart] askGastroGuide error: $e\n$s');
      return Left(AppError.network());
    }
  }
}
