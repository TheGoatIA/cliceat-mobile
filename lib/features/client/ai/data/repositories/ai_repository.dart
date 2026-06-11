import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/core/network/services/ai_service.dart';
import '../models/ai_model.dart';

@injectable
class AiRepository {
  final AiService _service;

  AiRepository(this._service);

  Future<Either<AppError, String>> sendMessage(
    String message,
    List<AiMessageModel> history,
  ) async {
    try {
      final res = await _service.sendMessage({
        'message': message,
        'history': history.map((e) => e.toJson()).toList(),
      });
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>;
        return Right(data['reply']?.toString() ?? '');
      }
      return Left(AppError.fromResponse(res.body, 'ai.error_chat'));
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
}
