import 'package:cliceat_app/core/network/models/platform_config_model.dart';
import 'package:cliceat_app/core/network/services/platform_service.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';

@lazySingleton
class PlatformRepository {
  final PlatformService _service;

  PlatformRepository(this._service);

  Future<Either<AppError, PlatformConfigModel>> getConfig() async {
    try {
      final response = await _service.getConfig();
      if (response.isSuccessful && response.body != null) {
        final data = response.body!['data'] as Map<String, dynamic>;
        return Right(PlatformConfigModel.fromJson(data));
      }
      return Left(AppError.fromResponse(response.body, 'config.error_load'));
    } catch (e) {
      return Left(AppError.network());
    }
  }
}
