import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' show MultipartFile;
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/features/client/dispute/data/datasources/dispute_service.dart';

@lazySingleton
class DisputeRepository {
  final DisputeService _disputeService;

  DisputeRepository(this._disputeService);

  Future<Either<AppError, void>> createDispute({
    required String orderId,
    required String reason,
    required String description,
    List<File>? images,
  }) async {
    try {
      List<MultipartFile>? multipartImages;
      if (images != null && images.isNotEmpty) {
        multipartImages = await Future.wait(
          images.map((f) => MultipartFile.fromPath('images', f.path)),
        );
      }

      final res = await _disputeService.createDispute(
        orderId: orderId,
        reason: reason,
        description: description,
        images: multipartImages,
      );

      if (res.isSuccessful) return const Right(null);
      return Left(AppError.fromResponse(res.body, 'dispute.create_error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, List<Map<String, dynamic>>>> getMyDisputes() async {
    try {
      final res = await _disputeService.getMyDisputes();
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as List<dynamic>? ?? [];
        return Right(data.cast<Map<String, dynamic>>());
      }
      return Left(AppError.fromResponse(res.body, 'dispute.history_error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }
}
