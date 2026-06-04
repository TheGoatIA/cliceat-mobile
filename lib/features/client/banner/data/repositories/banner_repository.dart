import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/core/network/services/platform_service.dart';
import '../models/banner_model.dart';

@injectable
class BannerRepository {
  final PlatformService _service;
  BannerRepository(this._service);

  Future<Either<AppError, List<BannerModel>>> getBanners() async {
    try {
      final res = await _service.getConfig();
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>;
        // Assume backend sends banners in config or mock it if empty
        final rawBanners = jsonToList(data['banners']);

        if (rawBanners.isEmpty) {
          // Fallback mocked banners for UI demonstration until backend is filled
          return Right([
            const BannerModel(
              id: '1',
              imageUrl:
                  'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=2070',
              title: 'Promo 1',
            ),
            const BannerModel(
              id: '2',
              imageUrl:
                  'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=2070',
              title: 'Promo 2',
            ),
          ]);
        }

        return Right(
          rawBanners
              .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }
      return Left(AppError.fromResponse(res.body, 'banner.error_load'));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  List<dynamic> jsonToList(dynamic json) {
    if (json is List) return json;
    return [];
  }
}
