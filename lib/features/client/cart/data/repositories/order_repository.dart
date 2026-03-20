import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/features/client/cart/data/models/order_model.dart';
import 'package:cliceat_app/features/client/cart/data/models/tracking_model.dart';
import 'package:cliceat_app/features/client/cart/data/datasources/order_service.dart';
import 'package:cliceat_app/features/client/cart/data/datasources/payment_service.dart';
import 'package:cliceat_app/core/network/services/tracking_service.dart';

/// Statuts de paiement valides renvoyés par NotchPay / backend ClicEat.
/// Toute valeur absente de cet ensemble est rejetée comme non-succès.
const _kPaymentSuccessStatuses = {'completed', 'success', 'approved', 'paid'};

/// Abstracts order operations and provides local caching via SharedPreferences.
class OrderRepository {
  final OrderService _orderService;
  final PaymentService _paymentService;
  final TrackingService _trackingService;
  final Logger _logger = Logger();

  static const _cacheKey = 'cached_orders';

  OrderRepository(
    this._orderService,
    this._paymentService,
    this._trackingService,
  );

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

  Future<Either<AppError, List<OrderModel>>> getOrders({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final res = await _orderService.getOrders(page: page, limit: limit);
      if (res.isSuccessful && res.body != null) {
        final raw = res.body!['data'] as List<dynamic>? ?? [];
        final orders = raw
            .whereType<Map<String, dynamic>>()
            .map(OrderModel.fromJson)
            .toList();
        if (page == 1) await _cacheOrders(orders);
        return Right(orders);
      }
      // Fallback to cache on server error (first page only)
      if (page == 1) {
        final cached = await _loadCachedOrders();
        if (cached.isNotEmpty) return Right(cached);
      }
      return Left(AppError.fromResponse(
          res.body, 'order.error_load',
          statusCode: res.statusCode));
    } catch (_) {
      if (page == 1) {
        final cached = await _loadCachedOrders();
        if (cached.isNotEmpty) return Right(cached);
      }
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

  Future<Either<AppError, OrderModel>> reorder(String id) async {
    try {
      final res = await _orderService.reorderOrder(id);
      if (res.isSuccessful && res.body != null) {
        final data =
            res.body!['data'] as Map<String, dynamic>? ?? res.body!;
        return Right(OrderModel.fromJson(data));
      }
      return Left(AppError.fromResponse(
          res.body, 'order.error_create',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> rateOrder(
      String id, int rating, String? comment) async {
    try {
      final res = await _orderService.rateOrder(id, {
        'rating': rating,
        'comment': comment,
      });
      if (res.isSuccessful) return const Right(null);
      return Left(AppError.fromResponse(
          res.body, 'order.error_rate',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  // ─── Payment ──────────────────────────────────────────────────────────────

  /// Vérifie le paiement avec une whitelist stricte.
  ///
  /// ⚠️ SÉCURITÉ : Un statut absent, vide ou inconnu retourne une erreur
  /// explicite — JAMAIS un succès silencieux.
  Future<Either<AppError, bool>> verifyPayment(String orderId) async {
    try {
      final res = await _paymentService.verifyPayment(orderId);
      if (res.isSuccessful && res.body != null) {
        final data =
            res.body!['data'] as Map<String, dynamic>? ?? res.body!;

        final rawStatus = data['status']?.toString() ??
            data['paymentStatus']?.toString();

        // Statut absent dans la réponse → erreur explicite
        if (rawStatus == null || rawStatus.isEmpty) {
          _logger.e(
            '[Payment] orderId=$orderId — statut de paiement absent dans la réponse. '
            'Body: ${jsonEncode(res.body)}',
          );
          return Left(const AppError(
            message: 'payment.failed',
            type: AppErrorType.server,
          ));
        }

        final normalised = rawStatus.trim().toLowerCase();
        final isSuccess = _kPaymentSuccessStatuses.contains(normalised);

        if (!isSuccess) {
          _logger.w(
            '[Payment] orderId=$orderId — statut non reconnu: "$normalised". '
            'Statuts acceptés: $_kPaymentSuccessStatuses',
          );
        } else {
          _logger.i('[Payment] orderId=$orderId — succès. Statut: "$normalised"');
        }

        return Right(isSuccess);
      }
      return Left(AppError.fromResponse(
          res.body, 'payment.failed',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  // ─── Tracking ─────────────────────────────────────────────────────────────

  Future<Either<AppError, TrackingModel>> getTracking(String orderId) async {
    try {
      final res = await _trackingService.getTracking(orderId);
      if (res.isSuccessful && res.body != null) {
        final data =
            res.body!['data'] as Map<String, dynamic>? ?? res.body!;
        return Right(TrackingModel.fromJson(data));
      }
      return Left(AppError.fromResponse(
          res.body, 'order.error_tracking',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, TrackingModel>> getEta(String orderId) async {
    try {
      final res = await _trackingService.getEta(orderId);
      if (res.isSuccessful && res.body != null) {
        final data =
            res.body!['data'] as Map<String, dynamic>? ?? res.body!;
        return Right(TrackingModel.fromJson(data));
      }
      return Left(AppError.fromResponse(
          res.body, 'order.error_tracking',
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
