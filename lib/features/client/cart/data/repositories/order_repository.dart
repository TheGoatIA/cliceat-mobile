import 'dart:convert';
import 'dart:io';
import 'package:cliceat_app/shared/models/address_model.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cliceat_app/core/data/local/daos/order_dao.dart';
import 'package:cliceat_app/core/data/local/database.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/config/env_config.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/features/client/cart/data/models/order_model.dart';
import 'package:cliceat_app/features/client/cart/data/models/tracking_model.dart';
import 'package:cliceat_app/features/client/cart/data/datasources/order_service.dart';
import 'package:cliceat_app/features/client/cart/data/datasources/payment_service.dart';
import 'package:cliceat_app/features/client/wallet/data/datasources/wallet_service.dart';
import 'package:cliceat_app/core/network/services/tracking_service.dart';
import 'package:cliceat_app/core/data/base_repository.dart';

/// Statuts de paiement valides renvoyés par NotchPay / backend ClicEat.
/// Toute valeur absente de cet ensemble est rejetée comme non-succès.
const _kPaymentSuccessStatuses = {'completed', 'success', 'approved', 'paid'};

/// Manages orders, reordering, and invoices.
@lazySingleton
class OrderRepository extends BaseRepository {
  final OrderService _orderService;
  final PaymentService _paymentService;
  final WalletService _walletService;
  final TrackingService _trackingService;
  final OrderDao _orderDao;
  final Logger _logger;

  OrderRepository(
    this._orderService,
    this._paymentService,
    this._walletService,
    this._trackingService,
    this._orderDao,
    this._logger,
  );

  // ─── Create ───────────────────────────────────────────────────────────────

  Future<Either<AppError, OrderModel>> createOrder(
    Map<String, dynamic> payload,
  ) async {
    try {
      final res = await _orderService.createOrder(payload);
      if (!res.isSuccessful) {
        return Left(AppError.fromResponse(
          res.body,
          'order.error_create',
          statusCode: res.statusCode,
        ));
      }

      if (res.body == null) {
        return Left(const AppError(
          message: 'common.error_empty_response',
          type: AppErrorType.server,
        ));
      }

      final data = res.body!['data'] as Map<String, dynamic>? ?? res.body!;
      final orderData = data['order'] as Map<String, dynamic>? ?? data;
      var order = OrderModel.fromJson(orderData);

      final method = payload['paymentMethod'] as String?;
      if (method != null && method != 'cash') {
        if (method == 'wallet') {
          final payRes = await _walletService.payOrder({'orderId': order.id});
          if (!payRes.isSuccessful) {
            return Left(AppError.fromResponse(
              payRes.body,
              'payment.failed',
              statusCode: payRes.statusCode,
            ));
          }
          order = OrderModel(
            id: order.id,
            restaurantId: order.restaurantId,
            restaurantName: order.restaurantName,
            restaurantLogo: order.restaurantLogo,
            items: order.items,
            total: order.total,
            deliveryFee: order.deliveryFee,
            status: 'pending',
            paymentUrl: null,
            paymentMethod: order.paymentMethod,
            deliveryAddress: order.deliveryAddress,
            notes: order.notes,
            createdAt: order.createdAt,
            rating: order.rating,
            invoiceUrl: order.invoiceUrl,
          );
        } else if (method == 'orange_money' || method == 'mtn_momo' || method == 'wave') {
          final initRes = await _paymentService.initializePayment({
            'orderId': order.id,
            'method': method,
            'returnUrl': 'cliceat://payment/success',
            'cancelUrl': 'cliceat://payment/cancel',
          });
          if (!initRes.isSuccessful) {
            return Left(AppError.fromResponse(
              initRes.body,
              'payment.failed',
              statusCode: initRes.statusCode,
            ));
          }
          final initData = initRes.body!['data'] as Map<String, dynamic>? ?? initRes.body!;
          final paymentUrl = initData['paymentUrl'] as String?;
          order = OrderModel(
            id: order.id,
            restaurantId: order.restaurantId,
            restaurantName: order.restaurantName,
            restaurantLogo: order.restaurantLogo,
            items: order.items,
            total: order.total,
            deliveryFee: order.deliveryFee,
            status: order.status,
            paymentUrl: paymentUrl,
            paymentMethod: order.paymentMethod,
            deliveryAddress: order.deliveryAddress,
            notes: order.notes,
            createdAt: order.createdAt,
            rating: order.rating,
            invoiceUrl: order.invoiceUrl,
          );
        }
      }

      return Right(order);
    } catch (e) {
      return Left(AppError.network(e.toString()));
    }
  }

  // ─── Load list ────────────────────────────────────────────────────────────

  Future<Either<AppError, List<OrderModel>>> getOrders({
    int page = 1,
    int limit = 20,
  }) async {
    final result = await safeCall<List<OrderModel>>(() async {
      final res = await _orderService.getOrders(page: page, limit: limit);
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'];
        List<dynamic> raw = [];
        if (data is Map<String, dynamic>) {
          raw = (data['items'] as List<dynamic>?) ??
              (data['orders'] as List<dynamic>?) ??
              [];
        } else if (data is List) {
          raw = data;
        }
        final orders = raw
            .whereType<Map<String, dynamic>>()
            .map(OrderModel.fromJson)
            .toList();
        return res.copyWith<List<OrderModel>>(body: orders);
      }
      return res.copyWith<List<OrderModel>>(body: null);
    }, fallbackMessage: 'order.error_load');

    return result.fold(
      (error) async {
        if (page == 1) {
          final cached = await _loadCachedOrders();
          if (cached.isNotEmpty) return Right(cached);
        }
        return Left(error);
      },
      (orders) async {
        if (page == 1) await _cacheOrders(orders);
        return Right(orders);
      },
    );
  }

  Future<Either<AppError, OrderModel>> getOrderById(String id) async {
    return safeCall<OrderModel>(() async {
      final res = await _orderService.getOrderById(id);
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>? ?? res.body!;
        final orderData = data['order'] as Map<String, dynamic>? ?? data;
        return res.copyWith<OrderModel>(body: OrderModel.fromJson(orderData));
      }
      return res.copyWith<OrderModel>(body: null);
    }, fallbackMessage: 'order.error_load');
  }

  // ─── Cancel ───────────────────────────────────────────────────────────────

  Future<Either<AppError, void>> cancelOrder(String id, [String? reason]) async {
    try {
      final res = await _orderService.cancelOrder(id, {
        'reason': reason ?? 'Annulation par le client',
      });
      if (res.isSuccessful) {
        await _removeFromCache(id);
        return const Right(null);
      }
      return Left(
        AppError.fromResponse(
          res.body,
          'order.error_cancel',
          statusCode: res.statusCode,
        ),
      );
    } catch (_) {
      return Left(AppError.network());
    }
  }

  // ─── Rate / Reorder ───────────────────────────────────────────────────────

  /// Crée un nouveau order à partir d'un order existant.
  ///
  /// L'endpoint `/orders/:id/reorder` n'existe pas côté backend.
  /// On récupère la commande originale et on crée un nouvel order avec
  /// les mêmes items, restaurant et adresse de livraison.
  Future<Either<AppError, OrderModel>> reorder(String id) async {
    try {
      // 1. Récupérer la commande originale
      final existingRes = await _orderService.getOrderById(id);
      if (!existingRes.isSuccessful || existingRes.body == null) {
        return Left(
          AppError.fromResponse(
            existingRes.body,
            'order.error_load',
            statusCode: existingRes.statusCode,
          ),
        );
      }
      final data =
          existingRes.body!['data'] as Map<String, dynamic>? ??
          existingRes.body!;
      final existingData = data['order'] as Map<String, dynamic>? ?? data;
      final existing = OrderModel.fromJson(existingData);

      // 2. Construire le payload du nouvel order
      final payload = <String, dynamic>{
        'restaurantId': existing.restaurantId,
        'items': existing.items
            .map((i) => {'menuItemId': i.itemId, 'quantity': i.quantity})
            .toList(),
        if (existing.deliveryAddress != null)
          'deliveryAddress': existing.deliveryAddress!.toJson(),
        'paymentMethod': existing.paymentMethod ?? 'cash',
      };

      // 3. Créer la nouvelle commande
      final res = await _orderService.createOrder(payload);
      if (res.isSuccessful && res.body != null) {
        final newData = res.body!['data'] as Map<String, dynamic>? ?? res.body!;
        final newOrderData =
            newData['order'] as Map<String, dynamic>? ?? newData;
        return Right(OrderModel.fromJson(newOrderData));
      }
      return Left(
        AppError.fromResponse(
          res.body,
          'order.error_create',
          statusCode: res.statusCode,
        ),
      );
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> rateOrder(
    String id,
    int rating,
    String? comment,
  ) async {
    try {
      final res = await _orderService.rateOrder(id, {
        'rating': rating,
        'comment': comment,
      });
      if (res.isSuccessful) return const Right(null);
      return Left(
        AppError.fromResponse(
          res.body,
          'order.error_rate',
          statusCode: res.statusCode,
        ),
      );
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
        final data = res.body!['data'] as Map<String, dynamic>? ?? res.body!;

        final rawStatus =
            data['status']?.toString() ?? data['paymentStatus']?.toString();

        // Statut absent dans la réponse → erreur explicite
        if (rawStatus == null || rawStatus.isEmpty) {
          _logger.e(
            '[Payment] orderId=$orderId — statut de paiement absent dans la réponse. '
            'Body: ${jsonEncode(res.body)}',
          );
          return Left(
            const AppError(
              message: 'payment.failed',
              type: AppErrorType.server,
            ),
          );
        }

        final normalised = rawStatus.trim().toLowerCase();
        final isSuccess = _kPaymentSuccessStatuses.contains(normalised);

        if (!isSuccess) {
          _logger.w(
            '[Payment] orderId=$orderId — statut non reconnu: "$normalised". '
            'Statuts acceptés: $_kPaymentSuccessStatuses',
          );
        } else {
          _logger.i(
            '[Payment] orderId=$orderId — succès. Statut: "$normalised"',
          );
        }

        return Right(isSuccess);
      }
      return Left(
        AppError.fromResponse(
          res.body,
          'payment.failed',
          statusCode: res.statusCode,
        ),
      );
    } catch (_) {
      return Left(AppError.network());
    }
  }

  // ─── Tracking ─────────────────────────────────────────────────────────────

  Future<Either<AppError, TrackingModel>> getTracking(String orderId) async {
    try {
      final res = await _trackingService.getTracking(orderId);
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>? ?? res.body!;
        return Right(TrackingModel.fromJson(data));
      }
      return Left(
        AppError.fromResponse(
          res.body,
          'order.error_tracking',
          statusCode: res.statusCode,
        ),
      );
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, TrackingModel>> getEta(String orderId) async {
    try {
      final res = await _trackingService.getEta(orderId);
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>? ?? res.body!;
        return Right(TrackingModel.fromJson(data));
      }
      return Left(
        AppError.fromResponse(
          res.body,
          'order.error_tracking',
          statusCode: res.statusCode,
        ),
      );
    } catch (_) {
      return Left(AppError.network());
    }
  }

  // ─── Local cache ──────────────────────────────────────────────────────────

  // ─── Local cache ──────────────────────────────────────────────────────────

  Future<void> _cacheOrders(List<OrderModel> orders) async {
    try {
      final companions = orders.map(_toCompanion).toList();
      await _orderDao.upsertAll(companions);
    } catch (e) {
      _logger.e('[OrderRepo] Error caching orders: $e');
    }
  }

  Future<List<OrderModel>> _loadCachedOrders() async {
    try {
      final rows = await _orderDao.getAll();
      return rows.map(_fromRow).toList();
    } catch (e) {
      _logger.e('[OrderRepo] Error loading cached orders: $e');
      return [];
    }
  }

  Future<void> _removeFromCache(String id) async {
    try {
      await _orderDao.deleteOrder(id);
    } catch (_) {}
  }

  Future<void> clearCache() async {
    await _orderDao.clearAll();
  }

  // ─── Mappings ─────────────────────────────────────────────────────────────

  OrdersTableCompanion _toCompanion(OrderModel o) {
    return OrdersTableCompanion.insert(
      id: o.id,
      restaurantId: Value(o.restaurantId),
      restaurantName: Value(o.restaurantName),
      itemsJson: jsonEncode(o.items.map((i) => i.toJson()).toList()),
      total: o.total,
      deliveryFee: Value(o.deliveryFee),
      status: o.status,
      paymentMethod: Value(o.paymentMethod),
      deliveryAddressJson: Value(
        o.deliveryAddress != null
            ? jsonEncode(o.deliveryAddress!.toJson())
            : null,
      ),
      notes: Value(o.notes),
      createdAt: Value(o.createdAt),
      rating: Value(o.rating),
    );
  }

  OrderModel _fromRow(OrdersTableData r) {
    List<OrderItemModel> items = [];
    try {
      final List<dynamic> decoded = jsonDecode(r.itemsJson);
      items = decoded
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {}

    AddressModel? addr;
    if (r.deliveryAddressJson != null) {
      try {
        addr = AddressModel.fromJson(jsonDecode(r.deliveryAddressJson!));
      } catch (_) {}
    }

    return OrderModel(
      id: r.id,
      restaurantId: r.restaurantId,
      restaurantName: r.restaurantName,
      restaurantLogo: null,
      items: items,
      total: r.total,
      deliveryFee: r.deliveryFee,
      status: r.status,
      paymentMethod: r.paymentMethod,
      deliveryAddress: addr,
      notes: r.notes,
      createdAt: r.createdAt,
      rating: r.rating,
    );
  }

  // ─── Invoice ──────────────────────────────────────────────────────────────

  Future<Either<AppError, String>> downloadInvoice(String orderId) async {
    try {
      final secureStorage = getIt<FlutterSecureStorage>();
      final token = await secureStorage.read(key: 'jwt_token');

      final url = Uri.parse(
        '${EnvConfig.apiBaseUrl}/orders/$orderId/invoice/download',
      );
      final response = await http.get(
        url,
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/facture_cliceat_$orderId.pdf');
        await file.writeAsBytes(response.bodyBytes);
        return Right(file.path);
      }
      return const Left(
        AppError(
          message: 'order.error_download_invoice',
          type: AppErrorType.server,
        ),
      );
    } catch (_) {
      return const Left(
        AppError(message: 'common.error_network', type: AppErrorType.network),
      );
    }
  }
}
