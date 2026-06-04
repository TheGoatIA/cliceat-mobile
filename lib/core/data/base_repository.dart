import 'package:chopper/chopper.dart' as chopper;
import 'package:dartz/dartz.dart';
import '../errors/app_error.dart';

/// Base class for all repositories to provide common utilities.
abstract class BaseRepository {
  /// Wraps an API call with standard error mapping (403, 404, 500, etc.)
  Future<Either<AppError, T>> safeCall<T>(
    Future<chopper.Response<T>> Function() call, {
    String? fallbackMessage,
  }) async {
    try {
      final response = await call();

      if (response.isSuccessful) {
        if (response.body != null) {
          return Right(response.body as T);
        }
        return Left(
          AppError.fromResponse(
            response.body,
            fallbackMessage ?? 'common.error_empty_response',
            statusCode: response.statusCode,
          ),
        );
      }

      // Map HTTP status codes to AppError
      switch (response.statusCode) {
        case 401:
          return Left(AppError.auth());
        case 403:
          return Left(
            AppError.fromResponse(
              response.body,
              'common.error_forbidden',
              statusCode: 403,
            ),
          );
        case 404:
          String? errorMsg;
          if (response.body != null && response.body is Map) {
            errorMsg = (response.body as Map)['message']?.toString();
          }
          return Left(AppError.notFound(errorMsg));
        case 500:
          return Left(
            AppError.fromResponse(
              response.body,
              'common.error_server',
              statusCode: 500,
            ),
          );
        default:
          return Left(
            AppError.fromResponse(
              response.body,
              fallbackMessage ?? 'common.error',
              statusCode: response.statusCode,
            ),
          );
      }
    } catch (e) {
      return Left(AppError.network(e.toString()));
    }
  }
}
