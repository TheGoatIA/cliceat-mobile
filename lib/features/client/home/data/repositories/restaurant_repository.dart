import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' as drift;
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/features/client/home/data/models/restaurant_model.dart';
import 'package:cliceat_app/core/data/local/daos/restaurant_dao.dart';
import 'package:cliceat_app/core/data/local/database.dart';
import 'package:cliceat_app/features/client/home/data/datasources/restaurant_service.dart';

/// Abstracts restaurant data access with cache-through strategy.
/// Network-first for listings, falls back to Drift cache on failure.
@lazySingleton
class RestaurantRepository {
  final RestaurantService _service;
  final RestaurantDao _dao;

  RestaurantRepository(this._service, this._dao);

  // ─── Listings ─────────────────────────────────────────────────────────────

  Future<Either<AppError, List<RestaurantModel>>> getRestaurants({
    required String city,
    double? lat,
    double? lng,
  }) async {
    try {
      final res =
          await _service.getRestaurants(city, lat, lng);
      if (res.isSuccessful && res.body != null) {
        final raw = _extractList(res.body);
        final models = raw.map(RestaurantModel.fromJson).toList();
        await _dao.evictStale();
        await _dao.upsertAll(_toCompanions(models));
        return Right(models);
      }
      // Cache fallback
      final cached = await _dao.getByCity(city);
      if (cached.isNotEmpty) return Right(_fromRows(cached));
      return Left(AppError.fromResponse(
          res.body, 'common.error',
          statusCode: res.statusCode));
    } catch (_) {
      final cached = await _dao.getByCity(city);
      if (cached.isNotEmpty) return Right(_fromRows(cached));
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, List<RestaurantModel>>>
      getFeaturedRestaurants() async {
    try {
      final res = await _service.getFeaturedRestaurants();
      if (res.isSuccessful && res.body != null) {
        final raw = _extractList(res.body);
        final models = raw.map(RestaurantModel.fromJson).toList();
        await _dao.upsertAll(_toCompanions(models));
        return Right(models);
      }
      return Left(AppError.fromResponse(res.body, 'common.error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, List<RestaurantModel>>> search(
      String query) async {
    try {
      final res = await _service.searchRestaurants(query);
      if (res.isSuccessful && res.body != null) {
        final raw = _extractList(res.body);
        return Right(raw.map(RestaurantModel.fromJson).toList());
      }
      return Left(AppError.fromResponse(res.body, 'common.error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  // ─── Detail ───────────────────────────────────────────────────────────────

  Future<Either<AppError, RestaurantModel>> getDetails(String id) async {
    try {
      final res = await _service.getRestaurantDetails(id);
      if (res.isSuccessful && res.body != null) {
        final data = res.body is Map && res.body['data'] != null
            ? res.body['data'] as Map<String, dynamic>
            : res.body as Map<String, dynamic>;
        final model = RestaurantModel.fromJson(data);
        return Right(model);
      }
      // Try cache (without menus)
      final cached = await _dao.getById(id);
      if (cached != null) return Right(_fromRow(cached));
      return Left(AppError.fromResponse(
          res.body, 'restaurant.error_load',
          statusCode: res.statusCode));
    } catch (_) {
      final cached = await _dao.getById(id);
      if (cached != null) return Right(_fromRow(cached));
      return Left(AppError.network());
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  List<Map<String, dynamic>> _extractList(dynamic body) {
    if (body is Map) {
      final data = body['data'];
      if (data is List) {
        return data.whereType<Map<String, dynamic>>().toList();
      }
    }
    return [];
  }

  List<RestaurantsTableCompanion> _toCompanions(
      List<RestaurantModel> models) {
    return models
        .map((r) => RestaurantsTableCompanion.insert(
              id: r.id,
              name: r.name,
              city: r.city ?? 'Douala',
              lat: r.lat,
              lng: r.lng,
              isOpen: drift.Value(r.isOpen),
              deliveryFee: drift.Value(r.deliveryFee),
              description: drift.Value(r.description),
              logoUrl: drift.Value(r.logoUrl),
              coverUrl: drift.Value(r.coverImage),
              rating: drift.Value(r.rating),
              minOrder: drift.Value(r.minOrder ?? 0.0),
              avgDeliveryTime: drift.Value(r.deliveryTimeMinutes),
            ))
        .toList();
  }

  List<RestaurantModel> _fromRows(List<RestaurantsTableData> rows) =>
      rows.map(_fromRow).toList();

  RestaurantModel _fromRow(RestaurantsTableData r) => RestaurantModel(
        id: r.id,
        name: r.name,
        description: r.description,
        city: r.city,
        lat: r.lat,
        lng: r.lng,
        logoUrl: r.logoUrl,
        coverImage: r.coverUrl,
        rating: r.rating,
        isOpen: r.isOpen,
        deliveryFee: r.deliveryFee,
        minOrder: r.minOrder,
        deliveryTimeMinutes: r.avgDeliveryTime,
      );
}
