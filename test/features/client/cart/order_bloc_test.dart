import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/core/models/order_model.dart';
import 'package:cliceat_app/core/repositories/order_repository.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/services/analytics_service.dart';
import 'package:cliceat_app/features/client/cart/presentation/bloc/order_bloc.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockOrderRepository extends Mock implements OrderRepository {}
class MockAnalyticsService extends Mock implements AnalyticsService {}

// ─── Helpers ─────────────────────────────────────────────────────────────────

OrderModel _fakeOrder() => OrderModel(
      id: 'order_abc123',
      status: 'pending',
      total: 5000,
      deliveryFee: 1000,
      items: [],
      paymentUrl: 'https://pay.notchpay.co/pay/test',
    );

void main() {
  late MockOrderRepository mockRepo;
  late MockAnalyticsService mockAnalytics;

  setUp(() {
    mockRepo = MockOrderRepository();
    mockAnalytics = MockAnalyticsService();

    if (getIt.isRegistered<AnalyticsService>()) {
      getIt.unregister<AnalyticsService>();
    }
    getIt.registerSingleton<AnalyticsService>(mockAnalytics);

    when(() => mockAnalytics.logPurchase(
          orderId: any(named: 'orderId'),
          total: any(named: 'total'),
          deliveryFee: any(named: 'deliveryFee'),
        )).thenReturn(null);
    when(() => mockAnalytics.logOrderCancelled(any())).thenReturn(null);
  });

  tearDown(() {
    getIt.unregister<AnalyticsService>();
  });

  OrderBloc _buildBloc() => OrderBloc(mockRepo);

  // ─── CreateOrder ──────────────────────────────────────────────────────────

  group('CreateOrder', () {
    const payload = {'restaurantId': 'resto1', 'items': []};

    blocTest<OrderBloc, OrderState>(
      'émet OrderCreated après création réussie',
      setUp: () {
        when(() => mockRepo.createOrder(any()))
            .thenAnswer((_) async => Right(_fakeOrder()));
      },
      build: _buildBloc,
      act: (bloc) => bloc.add(const OrderEvent.createOrder(payload)),
      expect: () => [
        const OrderState.loading(),
        isA<OrderState>().having(
          (s) => s.maybeWhen(
            created: (id, _) => id,
            orElse: () => null,
          ),
          'orderId',
          'order_abc123',
        ),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'émet error sans réseau',
      setUp: () {
        when(() => mockRepo.createOrder(any()))
            .thenAnswer((_) async => Left(AppError.network()));
      },
      build: _buildBloc,
      act: (bloc) => bloc.add(const OrderEvent.createOrder(payload)),
      expect: () => [
        const OrderState.loading(),
        isA<OrderState>().having(
          (s) => s.maybeWhen(
            error: (msg) => msg,
            orElse: () => null,
          ),
          'message',
          'common.network_error',
        ),
      ],
    );
  });

  // ─── LoadOrders ───────────────────────────────────────────────────────────

  group('LoadOrders', () {
    blocTest<OrderBloc, OrderState>(
      'émet ordersLoaded avec liste',
      setUp: () {
        when(() => mockRepo.getOrders())
            .thenAnswer((_) async => Right([_fakeOrder()]));
      },
      build: _buildBloc,
      act: (bloc) => bloc.add(const OrderEvent.loadOrders()),
      expect: () => [
        const OrderState.loading(),
        isA<OrderState>().having(
          (s) => s.maybeWhen(
            ordersLoaded: (orders) => orders.length,
            orElse: () => null,
          ),
          'count',
          1,
        ),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'émet error si chargement échoue',
      setUp: () {
        when(() => mockRepo.getOrders())
            .thenAnswer((_) async =>
                Left(const AppError(message: 'order.error_load')));
      },
      build: _buildBloc,
      act: (bloc) => bloc.add(const OrderEvent.loadOrders()),
      expect: () => [
        const OrderState.loading(),
        const OrderState.error('order.error_load'),
      ],
    );
  });

  // ─── CancelOrder ─────────────────────────────────────────────────────────

  group('CancelOrder', () {
    blocTest<OrderBloc, OrderState>(
      'émet cancelled après annulation réussie',
      setUp: () {
        when(() => mockRepo.cancelOrder('order_abc123'))
            .thenAnswer((_) async => const Right(null));
      },
      build: _buildBloc,
      act: (bloc) =>
          bloc.add(const OrderEvent.cancelOrder('order_abc123')),
      expect: () => [
        const OrderState.loading(),
        const OrderState.cancelled(),
      ],
    );
  });
}
