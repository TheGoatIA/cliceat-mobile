import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' as drift;
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/features/client/home/data/models/restaurant_model.dart';
import 'package:cliceat_app/features/client/home/data/models/menu_item_model.dart';
import 'package:cliceat_app/core/data/local/daos/restaurant_dao.dart';
import 'package:cliceat_app/core/data/local/database.dart';
import 'package:cliceat_app/features/client/home/data/datasources/restaurant_service.dart';

import 'package:cliceat_app/core/data/local/daos/menu_dao.dart';
import 'dart:convert';

/// Abstracts restaurant data access with cache-through strategy.
/// Network-first for listings, falls back to Drift cache on failure.
@lazySingleton
class RestaurantRepository {
  final RestaurantService _service;
  final RestaurantDao _dao;
  final MenuDao _menuDao;

  RestaurantRepository(this._service, this._dao, this._menuDao);

  // ─── Listings ─────────────────────────────────────────────────────────────

  Future<Either<AppError, List<RestaurantModel>>> getRestaurants({
    required String city,
    double? lat,
    double? lng,
    int? page,
    int? limit,
  }) async {
    try {
      final normalizedCity = city.toLowerCase().replaceAll('é', 'e');
      final res = await _service.getRestaurants(
        normalizedCity,
        20000.0,
        lat,
        lng,
        page,
        limit,
      );
      if (res.isSuccessful && res.body != null) {
        final raw = _extractList(res.body);
        final models = raw.map(RestaurantModel.fromJson).toList();
        await _dao.evictStale();
        await _dao.upsertAll(models.map(_toCompanion).toList());
        return Right(models);
      }
      // Cache fallback
      final cached = await _dao.getByCity(city);
      if (cached.isNotEmpty) return Right(_fromRows(cached));
      return Left(
        AppError.fromResponse(
          res.body,
          'common.error',
          statusCode: res.statusCode,
        ),
      );
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
        await _dao.upsertAll(models.map(_toCompanion).toList());
        return Right(models);
      }
      return Left(AppError.fromResponse(res.body, 'common.error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, List<RestaurantModel>>> search(
    String query, {
    int? page,
    int? limit,
  }) async {
    try {
      final res = await _service.searchRestaurants(query, page, limit);
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

        final restaurantJson = data.containsKey('restaurant')
            ? data['restaurant'] as Map<String, dynamic>
            : data;

        final model = RestaurantModel.fromJson(restaurantJson);

        // Save to cache
        await _dao.upsert(_toCompanion(model));
        if (model.menus.isNotEmpty) {
          await _menuDao.replaceItemsForRestaurant(
            id,
            _toMenuCompanions(id, model.menus),
          );
        }

        return Right(model);
      }
      // Try cache
      final cached = await _dao.getById(id);
      if (cached != null) {
        final menuRows = await _menuDao.getByRestaurant(id);
        return Right(_fromRowWithMenus(cached, menuRows));
      }
      return Left(
        AppError.fromResponse(
          res.body,
          'restaurant.error_load',
          statusCode: res.statusCode,
        ),
      );
    } catch (_) {
      final cached = await _dao.getById(id);
      if (cached != null) {
        final menuRows = await _menuDao.getByRestaurant(id);
        return Right(_fromRowWithMenus(cached, menuRows));
      }
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> toggleFavorite(String id) async {
    try {
      final res = await _service.toggleFavorite(id);
      if (res.isSuccessful) return const Right(null);
      return Left(AppError.fromResponse(res.body, 'common.error'));
    } catch (_) {
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
      if (data is Map) {
        final items = data['items'] ?? data['restaurants'];
        if (items is List) {
          return items.whereType<Map<String, dynamic>>().toList();
        }
      }
    }
    return [];
  }

  RestaurantsTableCompanion _toCompanion(RestaurantModel r) {
    return RestaurantsTableCompanion.insert(
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
    );
  }

  List<MenuItemsTableCompanion> _toMenuCompanions(
    String restaurantId,
    List<MenuItemModel> menus,
  ) {
    return menus
        .map(
          (m) => MenuItemsTableCompanion.insert(
            id: m.id,
            restaurantId: restaurantId,
            name: m.nameFr,
            price: m.price,
            description: drift.Value(m.descriptionFr),
            imageUrl: drift.Value(m.image),
            category: drift.Value(m.category),
            isAvailable: drift.Value(m.isAvailable),
            extrasJson: drift.Value(
              jsonEncode(m.variations.map((v) => v.toJson()).toList()),
            ),
          ),
        )
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

  RestaurantModel _fromRowWithMenus(
    RestaurantsTableData r,
    List<MenuItemsTableData> menuRows,
  ) {
    final menus = menuRows.map((m) {
      List<MenuVariationModel> variations = [];
      if (m.extrasJson != null) {
        try {
          final List<dynamic> decoded = jsonDecode(m.extrasJson!);
          variations = decoded
              .map(
                (e) => MenuVariationModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        } catch (_) {}
      }
      return MenuItemModel(
        id: m.id,
        nameFr: m.name,
        nameEn: m.name,
        descriptionFr: m.description,
        descriptionEn: m.description,
        price: m.price,
        image: m.imageUrl,
        category: m.category,
        isAvailable: m.isAvailable,
        variations: variations,
      );
    }).toList();

    return RestaurantModel(
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
      menus: menus,
    );
  }
}
