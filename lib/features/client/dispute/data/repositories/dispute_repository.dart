import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' show MultipartFile;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
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
          images.map((f) {
            final ext = f.path.split('.').last.toLowerCase();
            final contentType = switch (ext) {
              'png' => MediaType('image', 'png'),
              'webp' => MediaType('image', 'webp'),
              'gif' => MediaType('image', 'gif'),
              _ => MediaType('image', 'jpeg'),
            };
            return MultipartFile.fromPath(
              'evidence',
              f.path,
              contentType: contentType,
            );
          }),
        );
      }

      final res = await _disputeService.createDispute(
        orderId: orderId,
        reason: reason,
        description: description,
        evidence: multipartImages,
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
        final data = res.body!['data'];
        final list =
            (data is Map ? data['disputes'] : data) as List<dynamic>? ?? [];
        return Right(list.cast<Map<String, dynamic>>());
      }
      return Left(AppError.fromResponse(res.body, 'dispute.history_error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }
}
