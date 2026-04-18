import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cliceat_app/core/data/local/daos/pending_actions_dao.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/chat/data/repositories/chat_repository.dart';
import 'package:cliceat_app/features/client/review/data/repositories/review_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class SyncManagerService {
  final PendingActionsDao _pendingActionsDao;
  final Logger _logger;
  
  StreamSubscription? _connectivitySubscription;
  bool _isProcessing = false;

  SyncManagerService(this._pendingActionsDao, this._logger);

  void initialize() {
    _logger.i('SyncManagerService initialized');
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        _logger.i('Back online, starting sync...');
        processQueue();
      }
    });
    
    // Process queue on startup in case we are already online
    processQueue();
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }

  Future<void> processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final actions = await _pendingActionsDao.getAllPending();
      if (actions.isEmpty) {
        _isProcessing = false;
        return;
      }

      _logger.i('Processing ${actions.length} pending actions');

      for (final action in actions) {
        final success = await _dispatchAction(action.type, action.payload);
        if (success) {
          await _pendingActionsDao.deletePending(action.id);
          _logger.i('Action ${action.id} (${action.type}) synced successfully');
        } else {
          await _pendingActionsDao.incrementRetry(action.id);
          _logger.w('Action ${action.id} (${action.type}) failed to sync, will retry later');
          // If a sync fails, maybe we lost connection again? Stop processing for now.
          break;
        }
      }
    } catch (e) {
      _logger.e('Error processing sync queue: $e');
    } finally {
      _isProcessing = false;
    }
  }

  Future<bool> _dispatchAction(String type, String payloadStr) async {
    final Map<String, dynamic> payload = jsonDecode(payloadStr);

    try {
      if (type == 'send_chat') {
        final conversationId = payload['conversationId'];
        final content = payload['content'];
        
        final repo = getIt<ChatRepository>();
        final result = await repo.sendMessage(
          conversationId: conversationId,
          content: content,
        );
        
        return result.isRight();
      } else if (type == 'create_review') {
        final repo = getIt<ReviewRepository>();
        final result = await repo.createReview(
          orderId: payload['orderId'],
          restaurantId: payload['restaurantId'],
          restaurantRating: payload['restaurantRating'],
          deliveryRating: payload['deliveryRating'],
          comment: payload['comment'],
        );
        return result.isRight();
      }
      
      _logger.w('Unknown action type: $type');
      return true; // Mark as true so it gets deleted
    } catch (e) {
      _logger.e('Error dispatching action $type: $e');
      return false;
    }
  }
}
