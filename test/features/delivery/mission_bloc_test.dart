import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/models/mission_model.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/repositories/driver_repository.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/services/analytics_service.dart';
import 'package:cliceat_app/features/delivery/dashboard/presentation/bloc/mission_bloc.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockDriverRepository extends Mock implements DriverRepository {}
class MockAnalyticsService extends Mock implements AnalyticsService {}

// ─── Helpers ─────────────────────────────────────────────────────────────────

MissionModel _fakeMission({String id = 'mission1'}) => MissionModel(
      id: id,
      status: 'pending',
      restaurantLat: 4.0511,
      restaurantLng: 9.7679,
      restaurantName: 'Test Resto',
      clientName: 'Client Test',
      earnings: 3500,
    );

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late MockDriverRepository mockRepo;
  late MockAnalyticsService mockAnalytics;

  setUp(() {
    mockRepo = MockDriverRepository();
    mockAnalytics = MockAnalyticsService();

    if (getIt.isRegistered<AnalyticsService>()) {
      getIt.unregister<AnalyticsService>();
    }
    getIt.registerSingleton<AnalyticsService>(mockAnalytics);

    when(() => mockAnalytics.logMissionAccepted(any())).thenAnswer((_) async {});
    when(() => mockAnalytics.logDeliveryCompleted(any())).thenAnswer((_) async {});
  });

  tearDown(() {
    getIt.unregister<AnalyticsService>();
  });

  MissionBloc buildBloc() => MissionBloc(mockRepo);

  // ─── LoadActiveMissions ───────────────────────────────────────────────────

  group('LoadActiveMissions', () {
    blocTest<MissionBloc, MissionState>(
      'émet loaded avec la liste de missions',
      setUp: () {
        when(() => mockRepo.getActiveMissions())
            .thenAnswer((_) async => Right([_fakeMission()]));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const MissionEvent.loadActiveMissions()),
      expect: () => [
        const MissionState.loading(),
        isA<MissionState>().having(
          (s) => s.maybeWhen(
            loaded: (missions) => missions.length,
            orElse: () => null,
          ),
          'count',
          1,
        ),
      ],
    );

    blocTest<MissionBloc, MissionState>(
      'émet loaded avec liste vide si aucune mission',
      setUp: () {
        when(() => mockRepo.getActiveMissions())
            .thenAnswer((_) async => const Right([]));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const MissionEvent.loadActiveMissions()),
      expect: () => [
        const MissionState.loading(),
        isA<MissionState>().having(
          (s) => s.maybeWhen(
            loaded: (missions) => missions.length,
            orElse: () => null,
          ),
          'count',
          0,
        ),
      ],
    );

    blocTest<MissionBloc, MissionState>(
      'émet error si le dépôt retourne une erreur',
      setUp: () {
        when(() => mockRepo.getActiveMissions())
            .thenAnswer((_) async =>
                Left(const AppError(message: 'mission.error_load')));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const MissionEvent.loadActiveMissions()),
      expect: () => [
        const MissionState.loading(),
        const MissionState.error('mission.error_load'),
      ],
    );
  });

  // ─── AcceptMission ────────────────────────────────────────────────────────

  group('AcceptMission', () {
    blocTest<MissionBloc, MissionState>(
      'émet actionSuccess + recharge les missions après acceptation',
      setUp: () {
        when(() => mockRepo.acceptMission('mission1'))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepo.getActiveMissions())
            .thenAnswer((_) async => Right([_fakeMission()]));
      },
      build: buildBloc,
      act: (bloc) =>
          bloc.add(const MissionEvent.acceptMission('mission1')),
      expect: () => [
        const MissionState.loading(),
        const MissionState.actionSuccess('mission.accepted'),
        const MissionState.loading(),
        isA<MissionState>().having(
          (s) => s.maybeWhen(loaded: (_) => true, orElse: () => false),
          'isLoaded',
          true,
        ),
      ],
      verify: (_) {
        verify(() => mockAnalytics.logMissionAccepted('mission1')).called(1);
      },
    );

    blocTest<MissionBloc, MissionState>(
      'émet error si acceptation échoue',
      setUp: () {
        when(() => mockRepo.acceptMission('mission1'))
            .thenAnswer((_) async =>
                Left(const AppError(message: 'mission.error_accept')));
      },
      build: buildBloc,
      act: (bloc) =>
          bloc.add(const MissionEvent.acceptMission('mission1')),
      expect: () => [
        const MissionState.loading(),
        const MissionState.error('mission.error_accept'),
      ],
    );
  });

  // ─── RejectMission ────────────────────────────────────────────────────────

  group('RejectMission', () {
    blocTest<MissionBloc, MissionState>(
      'émet actionSuccess + recharge les missions après rejet',
      setUp: () {
        when(() => mockRepo.rejectMission('mission1'))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepo.getActiveMissions())
            .thenAnswer((_) async => const Right([]));
      },
      build: buildBloc,
      act: (bloc) =>
          bloc.add(const MissionEvent.rejectMission('mission1')),
      expect: () => [
        const MissionState.loading(),
        const MissionState.actionSuccess('mission.rejected'),
        const MissionState.loading(),
        isA<MissionState>().having(
          (s) => s.maybeWhen(loaded: (_) => true, orElse: () => false),
          'isLoaded',
          true,
        ),
      ],
    );
  });

  // ─── UpdateStatus ─────────────────────────────────────────────────────────

  group('UpdateStatus', () {
    blocTest<MissionBloc, MissionState>(
      "statut 'picked_up' → actionSuccess + recharge",
      setUp: () {
        when(() => mockRepo.confirmPickup('mission1'))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepo.getActiveMissions())
            .thenAnswer((_) async => const Right([]));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
          const MissionEvent.updateStatus('mission1', 'picked_up')),
      expect: () => [
        const MissionState.loading(),
        const MissionState.actionSuccess('mission.status_updated'),
        const MissionState.loading(),
        isA<MissionState>().having(
          (s) => s.maybeWhen(loaded: (_) => true, orElse: () => false),
          'isLoaded',
          true,
        ),
      ],
    );

    blocTest<MissionBloc, MissionState>(
      "statut 'delivered' → actionSuccess + log analytics + recharge",
      setUp: () {
        when(() => mockRepo.confirmDelivery('mission1'))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepo.getActiveMissions())
            .thenAnswer((_) async => const Right([]));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
          const MissionEvent.updateStatus('mission1', 'delivered')),
      expect: () => [
        const MissionState.loading(),
        const MissionState.actionSuccess('mission.status_updated'),
        const MissionState.loading(),
        isA<MissionState>().having(
          (s) => s.maybeWhen(loaded: (_) => true, orElse: () => false),
          'isLoaded',
          true,
        ),
      ],
      verify: (_) {
        verify(() =>
                mockAnalytics.logDeliveryCompleted('mission1'))
            .called(1);
      },
    );

    blocTest<MissionBloc, MissionState>(
      "statut inconnu → error sans chargement",
      build: buildBloc,
      act: (bloc) => bloc.add(
          const MissionEvent.updateStatus('mission1', 'unknown_status')),
      expect: () => [
        const MissionState.loading(),
        const MissionState.error('mission.error_unknown_status'),
      ],
    );
  });
}
