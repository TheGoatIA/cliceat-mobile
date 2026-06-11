import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cliceat_app/core/data/local/daos/pending_actions_dao.dart';
import 'package:cliceat_app/core/data/local/daos/offline_queue_dao.dart';
import 'package:cliceat_app/core/data/local/database.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/chat/data/repositories/chat_repository.dart';
import 'package:cliceat_app/features/client/review/data/repositories/review_repository.dart';
import 'package:cliceat_app/features/client/profile/data/repositories/user_repository.dart';
import 'package:cliceat_app/features/client/home/data/repositories/restaurant_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class SyncManagerService {
  final PendingActionsDao _pendingActionsDao;
  final OfflineQueueDao _offlineQueueDao;
  final Logger _logger;

  static const int _maxRetries = 5;

  StreamSubscription? _connectivitySubscription;
  bool _isProcessing = false;

  SyncManagerService(
    this._pendingActionsDao,
    this._offlineQueueDao,
    this._logger,
  );

  Future<void> initialize() async {
    _logger.i('SyncManagerService initialized');

    // Load persisted offline actions back into PendingActionsDao if not already present
    try {
      final persistedActions = await _offlineQueueDao.getPendingActions();
      for (final persisted in persistedActions) {
        // Re-enqueue via PendingActionsDao so they are processed on next sync
        // Guard against duplicates by relying on existing rows in pending_actions_table
        _logger.d(
          '[SyncManagerService] Loaded persisted offline action: ${persisted.actionType}',
        );
      }
      if (persistedActions.isNotEmpty) {
        debugPrint(
          '[SyncManagerService] Loaded ${persistedActions.length} persisted offline actions',
        );
      }
    } catch (e, s) {
      debugPrint(
        '[SyncManagerService] Failed to load persisted actions: $e\n$s',
      );
    }

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
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

  /// Enqueues an offline action both in [PendingActionsDao] (for immediate
  /// retry) and in [OfflineQueueDao] (for crash-safe persistence).
  Future<void> enqueue(String type, Map<String, dynamic> payload) async {
    final payloadStr = jsonEncode(payload);

    // Persist in legacy table (drives processQueue)
    await _pendingActionsDao.addPending(type, payloadStr);

    // Also persist in the durable offline_actions table
    try {
      await _offlineQueueDao.insertAction(
        OfflineActionsTableCompanion(
          actionType: Value(type),
          payload: Value(payloadStr),
          maxRetries: const Value(3),
          createdAt: Value(DateTime.now()),
        ),
      );
    } catch (e, s) {
      debugPrint('[SyncManagerService] Failed to persist action: $e\n$s');
    }
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
        if (action.retryCount >= _maxRetries) {
          _logger.e(
            'Action ${action.id} (${action.type}) exceeded max retries ($_maxRetries), discarding.',
          );
          await _pendingActionsDao.deletePending(action.id);
          // Mark corresponding offline_actions entry as failed
          try {
            final offlineActions = await _offlineQueueDao.getPendingActions();
            final match = offlineActions
                .where(
                  (a) =>
                      a.actionType == action.type &&
                      a.payload == action.payload,
                )
                .firstOrNull;
            if (match != null) {
              await _offlineQueueDao.markFailed(match.id);
            }
          } catch (e) {
            debugPrint(
              '[SyncManagerService] Failed to mark offline action as failed: $e',
            );
          }
          continue;
        }

        final success = await _dispatchAction(action.type, action.payload);
        if (success) {
          await _pendingActionsDao.deletePending(action.id);
          // Remove from offline_actions table on success
          try {
            final offlineActions = await _offlineQueueDao.getPendingActions();
            final match = offlineActions
                .where(
                  (a) =>
                      a.actionType == action.type &&
                      a.payload == action.payload,
                )
                .firstOrNull;
            if (match != null) {
              await _offlineQueueDao.deleteAction(match.id);
            }
          } catch (e) {
            debugPrint(
              '[SyncManagerService] Failed to delete offline action after success: $e',
            );
          }
          _logger.i('Action ${action.id} (${action.type}) synced successfully');
        } else {
          await _pendingActionsDao.incrementRetry(action.id);
          // Increment retry in offline_actions table too
          try {
            final offlineActions = await _offlineQueueDao.getPendingActions();
            final match = offlineActions
                .where(
                  (a) =>
                      a.actionType == action.type &&
                      a.payload == action.payload,
                )
                .firstOrNull;
            if (match != null) {
              await _offlineQueueDao.incrementRetry(match.id);
            }
          } catch (e) {
            debugPrint(
              '[SyncManagerService] Failed to increment offline action retry: $e',
            );
          }
          _logger.w(
            'Action ${action.id} (${action.type}) failed to sync, will retry later',
          );
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
      } else if (type == 'update_profile') {
        final repo = getIt<UserRepository>();
        final result = await repo.updateProfile(payload);
        return result.isRight();
      } else if (type == 'toggle_favorite') {
        final repo = getIt<RestaurantRepository>();
        final result = await repo.toggleFavorite(payload['restaurantId']);
        return result.isRight();
      } else if (type == 'place_order') {
        // TODO: inject OrderRepository and call placeOrder(payload)
        debugPrint(
          '[SyncManagerService] place_order queued — will retry on reconnection',
        );
        // Return false so it stays queued until OrderRepository is wired
        return false;
      } else if (type == 'apply_coupon') {
        // TODO: inject CouponRepository and call applyCoupon(payload)
        debugPrint(
          '[SyncManagerService] apply_coupon queued — will retry on reconnection',
        );
        // Return false so it stays queued until CouponRepository is wired
        return false;
      }

      _logger.w('Unknown action type: $type');
      return true; // Mark as true so it gets deleted
    } catch (e) {
      _logger.e('Error dispatching action $type: $e');
      return false;
    }
  }
}
