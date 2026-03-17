import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../errors/app_error.dart';
import '../models/order_model.dart';
import '../../features/client/cart/data/datasources/order_service.dart';

/// Abstracts order operations and provides local caching via SharedPreferences.
class OrderRepository {
  final OrderService _orderService;

  static const _cacheKey = 'cached_orders';

  OrderRepository(this._orderService);

  // ─── Create ───────────────────────────────────────────────────────────────

  Future<Either<AppError, OrderModel>> createOrder(
      Map<String, dynamic> payload) async {
    try {
      final res = await _orderService.createOrder(payload);
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        final data =
            body['data'] as Map<String, dynamic>? ?? body;
        final order = OrderModel.fromJson(data);
        return Right(order);
      }
      return Left(AppError.fromResponse(
          res.body, 'order.error_create',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  // ─── Load list ────────────────────────────────────────────────────────────

  Future<Either<AppError, List<OrderModel>>> getOrders() async {
    try {
      final res = await _orderService.getOrders();
      if (res.isSuccessful && res.body != null) {
        final raw = res.body!['data'] as List<dynamic>? ?? [];
        final orders = raw
            .whereType<Map<String, dynamic>>()
            .map(OrderModel.fromJson)
            .toList();
        await _cacheOrders(orders);
        return Right(orders);
      }
      // Fallback to cache on server error
      final cached = await _loadCachedOrders();
      if (cached.isNotEmpty) return Right(cached);
      return Left(AppError.fromResponse(
          res.body, 'order.error_load',
          statusCode: res.statusCode));
    } catch (_) {
      final cached = await _loadCachedOrders();
      if (cached.isNotEmpty) return Right(cached);
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, OrderModel>> getOrderById(String id) async {
    try {
      final res = await _orderService.getOrderById(id);
      if (res.isSuccessful && res.body != null) {
        final data =
            res.body!['data'] as Map<String, dynamic>? ?? res.body!;
        return Right(OrderModel.fromJson(data));
      }
      return Left(AppError.fromResponse(
          res.body, 'order.error_load',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  // ─── Cancel ───────────────────────────────────────────────────────────────

  Future<Either<AppError, void>> cancelOrder(String id) async {
    try {
      final res = await _orderService.cancelOrder(id);
      if (res.isSuccessful) {
        await _removeFromCache(id);
        return const Right(null);
      }
      return Left(AppError.fromResponse(
          res.body, 'order.error_cancel',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  // ─── Rate ─────────────────────────────────────────────────────────────────

  Future<Either<AppError, void>> rateOrder(
      String id, int rating, String? comment) async {
    try {
      final res = await _orderService.rateOrder(id, {
        'rating': rating,
        if (comment != null) 'comment': comment,
      });
      if (res.isSuccessful) return const Right(null);
      return Left(AppError.fromResponse(
          res.body, 'order.error_rate',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  // ─── Local cache ──────────────────────────────────────────────────────────

  Future<void> _cacheOrders(List<OrderModel> orders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(orders.map((o) => o.toJson()).toList());
      await prefs.setString(_cacheKey, encoded);
    } catch (_) {}
  }

  Future<List<OrderModel>> _loadCachedOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map<String, dynamic>>()
          .map(OrderModel.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _removeFromCache(String id) async {
    try {
      final orders = await _loadCachedOrders();
      final updated = orders.where((o) => o.id != id).toList();
      await _cacheOrders(updated);
    } catch (_) {}
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
