import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/banner/data/repositories/banner_repository.dart';
import 'package:cliceat_app/features/client/home/data/repositories/restaurant_repository.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class PrecacheService {
  final Logger _logger;

  PrecacheService(this._logger);

  /// Charge les images critiques en cache au démarrage pour une expérience offline fluide.
  Future<void> startPrecaching() async {
    _logger.i('Starting assets precaching...');
    
    try {
      // 1. Pré-charger les bannières
      final bannerRepo = getIt<BannerRepository>();
      final bannersResult = await bannerRepo.getBanners();
      bannersResult.fold(
        (_) => _logger.w('Failed to fetch banners for precache'),
        (banners) {
          for (final b in banners) {
            _cacheImage(b.imageUrl);
          }
        },
      );

      // 2. Pré-charger les logos des restaurants recommandés
      final restRepo = getIt<RestaurantRepository>();
      final restsResult = await restRepo.getFeaturedRestaurants();
      restsResult.fold(
        (_) => _logger.w('Failed to fetch restaurants for precache'),
        (restaurants) {
          for (final r in restaurants) {
            if (r.logoUrl != null) _cacheImage(r.logoUrl!);
            if (r.coverImage != null) _cacheImage(r.coverImage!);
          }
        },
      );
      
      _logger.i('Precaching finished');
    } catch (e) {
      _logger.e('Error during precaching: $e');
    }
  }

  Future<void> _cacheImage(String url) async {
    if (url.isEmpty || !url.startsWith('http')) return;

    try {
      await DefaultCacheManager().getSingleFile(url);
    } catch (e) {
      _logger.w('Failed to cache image: $url - $e');
    }
  }
}
