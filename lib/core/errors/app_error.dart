import 'dart:convert';

import 'package:flutter/foundation.dart';

/// Typed application error returned by all repositories.
enum AppErrorType { network, auth, notFound, validation, server, unknown }

class AppError {
  final String message;
  final int? statusCode;
  final AppErrorType type;

  const AppError({
    required this.message,
    this.statusCode,
    this.type = AppErrorType.unknown,
  });

  factory AppError.network([String? msg]) => AppError(
    message: msg ?? 'common.network_error',
    type: AppErrorType.network,
  );

  factory AppError.auth([String? msg]) => AppError(
    message: msg ?? 'auth.error_invalid_credentials',
    type: AppErrorType.auth,
  );

  factory AppError.notFound([String? msg]) => AppError(
    message: msg ?? 'common.error',
    type: AppErrorType.notFound,
    statusCode: 404,
  );

  /// Extracts the `message` field from an API error body, or uses [fallback].
  factory AppError.fromResponse(
    dynamic body,
    String fallback, {
    int? statusCode,
  }) {
    String msg = fallback;
    dynamic decoded;

    if (body != null) {
      if (body is Map) {
        decoded = body;
      } else if (body is String) {
        try {
          decoded = jsonDecode(body);
        } catch (e, s) {
          debugPrint('[app_error.dart] error: $e\n$s');
        }
      }
    }

    if (decoded is Map) {
      if (decoded['details'] is List &&
          (decoded['details'] as List).isNotEmpty) {
        final firstDetail = (decoded['details'] as List).first;
        if (firstDetail is Map && firstDetail['message'] != null) {
          msg = firstDetail['message'].toString();
        } else {
          msg =
              decoded['message']?.toString() ??
              decoded['error']?.toString() ??
              fallback;
        }
      } else {
        msg =
            decoded['message']?.toString() ??
            decoded['error']?.toString() ??
            fallback;
      }
    }

    return AppError(
      message: msg,
      statusCode: statusCode,
      type: statusCode == 401
          ? AppErrorType.auth
          : statusCode == 404
          ? AppErrorType.notFound
          : AppErrorType.server,
    );
  }

  @override
  String toString() =>
      'AppError(type: $type, message: $message, status: $statusCode)';
}
