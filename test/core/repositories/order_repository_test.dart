import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as base;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/core/repositories/order_repository.dart';
import 'package:cliceat_app/features/client/cart/data/datasources/order_service.dart';
import 'package:cliceat_app/features/client/cart/data/datasources/payment_service.dart';
import 'package:cliceat_app/core/network/services/tracking_service.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockOrderService extends Mock implements OrderService {}

class MockPaymentService extends Mock implements PaymentService {}

class MockTrackingService extends Mock implements TrackingService {}

// ─── Helpers ─────────────────────────────────────────────────────────────────

/// Construit une réponse Chopper simulée avec le body donné.
Response<Map<String, dynamic>> _ok(Map<String, dynamic> body) =>
    Response(base.Response(body.toString(), 200), body);

Response<Map<String, dynamic>> _err(int status) =>
    Response(base.Response('error', status), null);

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late MockOrderService mockOrderService;
  late MockPaymentService mockPaymentService;
  late MockTrackingService mockTrackingService;
  late OrderRepository repo;

  setUp(() {
    mockOrderService = MockOrderService();
    mockPaymentService = MockPaymentService();
    mockTrackingService = MockTrackingService();
    repo = OrderRepository(
      mockOrderService,
      mockPaymentService,
      mockTrackingService,
    );
  });

  // ─── verifyPayment — whitelist stricte ────────────────────────────────────

  group('verifyPayment — whitelist stricte', () {
    /// Vérifie qu'un statut reconnu retourne Right(true).
    Future<void> expectSuccess(String status) async {
      when(() => mockPaymentService.verifyPayment('order1')).thenAnswer(
        (_) async => _ok({
          'data': {'status': status},
        }),
      );

      final result = await repo.verifyPayment('order1');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Attendu Right, obtenu Left'),
        (ok) => expect(ok, true),
      );
    }

    /// Vérifie qu'un statut invalide retourne Left(AppError).
    Future<void> expectFailure(Map<String, dynamic> body) async {
      when(
        () => mockPaymentService.verifyPayment('order1'),
      ).thenAnswer((_) async => _ok(body));

      final result = await repo.verifyPayment('order1');

      expect(result.isLeft(), true);
      result.fold((err) {
        expect(err.message, 'payment.failed');
        expect(err.type, AppErrorType.server);
      }, (_) => fail('Attendu Left, obtenu Right'));
    }

    test("statut 'completed' → Right(true) ✅", () async {
      await expectSuccess('completed');
    });

    test("statut 'paid' → Right(true) ✅", () async {
      await expectSuccess('paid');
    });

    test("statut 'success' → Right(true) ✅", () async {
      await expectSuccess('success');
    });

    test("statut 'approved' → Right(true) ✅", () async {
      await expectSuccess('approved');
    });

    test("statut '' (vide) → AppError payment.failed ❌", () async {
      await expectFailure({
        'data': {'status': ''},
      });
    });

    test('statut null → AppError payment.failed ❌', () async {
      await expectFailure({'data': <String, dynamic>{}});
    });

    test(
      "statut 'pending' → Right(false) — pas une erreur mais pas un succès",
      () async {
        when(() => mockPaymentService.verifyPayment('order1')).thenAnswer(
          (_) async => _ok({
            'data': {'status': 'pending'},
          }),
        );

        final result = await repo.verifyPayment('order1');

        // 'pending' n'est pas dans la whitelist → isSuccess = false
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Attendu Right pour statut connu non-succès'),
          (ok) => expect(ok, false),
        );
      },
    );

    test("statut 'fraudulent_unknown' → Right(false) ❌", () async {
      when(() => mockPaymentService.verifyPayment('order1')).thenAnswer(
        (_) async => _ok({
          'data': {'status': 'fraudulent_unknown'},
        }),
      );

      final result = await repo.verifyPayment('order1');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Attendu Right pour statut inconnu'),
        (ok) => expect(ok, false),
      );
    });

    test('réponse HTTP en erreur → Left(AppError)', () async {
      when(
        () => mockPaymentService.verifyPayment('order1'),
      ).thenAnswer((_) async => _err(500));

      final result = await repo.verifyPayment('order1');

      expect(result.isLeft(), true);
    });

    test('exception réseau → Left(AppError.network)', () async {
      when(
        () => mockPaymentService.verifyPayment('order1'),
      ).thenThrow(Exception('Network error'));

      final result = await repo.verifyPayment('order1');

      expect(result.isLeft(), true);
      result.fold(
        (err) => expect(err.type, AppErrorType.network),
        (_) => fail('Attendu Left'),
      );
    });
  });

  // ─── cancelOrder ──────────────────────────────────────────────────────────

  group('cancelOrder', () {
    test('annulation réussie → Right(null)', () async {
      when(() => mockOrderService.cancelOrder('order1')).thenAnswer(
        (_) async => Response(base.Response('', 200), <String, dynamic>{}),
      );

      final result = await repo.cancelOrder('order1');
      expect(result.isRight(), true);
    });

    test('erreur serveur → Left(AppError)', () async {
      when(
        () => mockOrderService.cancelOrder('order1'),
      ).thenAnswer((_) async => _err(403));

      final result = await repo.cancelOrder('order1');
      expect(result.isLeft(), true);
    });
  });
}
