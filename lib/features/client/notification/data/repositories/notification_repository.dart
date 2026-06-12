import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/core/network/services/user_service.dart';
import '../models/notification_model.dart';

@lazySingleton
class NotificationRepository {
  final UserService _service;

  NotificationRepository(this._service);

  Future<Either<AppError, List<NotificationModel>>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final res = await _service.getNotifications(page, limit);
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        final rawData = body['data'] as Map<String, dynamic>? ?? {};
        final list = rawData['items'] as List<dynamic>? ?? [];
        final notifications = list
            .whereType<Map<String, dynamic>>()
            .map(NotificationModel.fromJson)
            .toList();
        return Right(notifications);
      }
      return Left(
        AppError.fromResponse(
          res.body,
          'common.error',
          statusCode: res.statusCode,
        ),
      );
    } catch (e, s) {
      debugPrint(
        '[notification_repository.dart] getNotifications error: $e\n$s',
      );
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> markAsRead(String id) async {
    try {
      final res = await _service.markNotificationRead(id);
      if (res.isSuccessful) {
        return const Right(null);
      }
      return Left(
        AppError.fromResponse(
          res.body,
          'common.error',
          statusCode: res.statusCode,
        ),
      );
    } catch (e, s) {
      debugPrint('[notification_repository.dart] markAsRead error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> deleteNotification(String id) async {
    try {
      final res = await _service.deleteNotification(id);
      if (res.isSuccessful) {
        return const Right(null);
      }
      return Left(
        AppError.fromResponse(
          res.body,
          'common.error',
          statusCode: res.statusCode,
        ),
      );
    } catch (e, s) {
      debugPrint(
        '[notification_repository.dart] deleteNotification error: $e\n$s',
      );
      return Left(AppError.network());
    }
  }
}
