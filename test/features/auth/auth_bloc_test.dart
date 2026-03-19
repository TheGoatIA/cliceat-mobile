import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as base;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cliceat_app/core/data/local/database.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/repositories/user_repository.dart';
import 'package:cliceat_app/core/services/analytics_service.dart';
import 'package:cliceat_app/core/services/notification_service.dart';
import 'package:cliceat_app/core/services/websocket_service.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:cliceat_app/features/auth/data/datasources/auth_service.dart';
import 'package:cliceat_app/features/auth/presentation/bloc/auth_bloc.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockAuthService extends Mock implements AuthService {}
class MockSecureStorage extends Mock implements FlutterSecureStorage {}
// class MockAppDatabase extends Mock implements AppDatabase {}
class MockWebSocketService extends Mock implements WebSocketService {}
class MockNotificationService extends Mock implements NotificationService {}
class MockAnalyticsService extends Mock implements AnalyticsService {}
class MockUserRepository extends Mock implements UserRepository {}

// Helper pour construire une réponse Chopper simulée
Response<Map<String, dynamic>> _buildResponse(
  Map<String, dynamic> body, {
  int status = 200,
}) =>
    Response(
      base.Response(
        body.toString(),
        status,
      ),
      body,
    );

// JWT valide non expiré (exp = 2099-01-01)
const _kValidToken =
    'eyJhbGciOiJIUzI1NiJ9'
    '.eyJzdWIiOiJ1c2VyMTIzIiwiZXhwIjo0MDcwOTA4ODAwfQ'
    '.signature';

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late MockAuthService mockAuthService;
  late MockSecureStorage mockStorage;
  late AppDatabase mockDb;
  late MockWebSocketService mockWs;
  late MockNotificationService mockNotif;
  late MockAnalyticsService mockAnalytics;
  late MockUserRepository mockUserRepo;

  setUp(() {
    mockAuthService = MockAuthService();
    mockStorage = MockSecureStorage();
    mockDb = AppDatabase.forTesting(drift.DatabaseConnection(NativeDatabase.memory()));
    mockWs = MockWebSocketService();
    mockNotif = MockNotificationService();
    mockAnalytics = MockAnalyticsService();
    mockUserRepo = MockUserRepository();

    // Enregistrer les mocks dans getIt pour les dépendances internes du BLoC
    if (getIt.isRegistered<WebSocketService>()) {
      getIt.unregister<WebSocketService>();
    }
    if (getIt.isRegistered<NotificationService>()) {
      getIt.unregister<NotificationService>();
    }
    if (getIt.isRegistered<AnalyticsService>()) {
      getIt.unregister<AnalyticsService>();
    }
    if (getIt.isRegistered<UserRepository>()) {
      getIt.unregister<UserRepository>();
    }

    getIt.registerSingleton<WebSocketService>(mockWs);
    getIt.registerSingleton<NotificationService>(mockNotif);
    getIt.registerSingleton<AnalyticsService>(mockAnalytics);
    getIt.registerSingleton<UserRepository>(mockUserRepo);

    // Défauts des mocks
    when(() => mockWs.statusStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockWs.connect()).thenAnswer((_) async {});
    when(() => mockWs.disconnect()).thenReturn(null);
    when(() => mockNotif.getFcmToken())
        .thenAnswer((_) async => 'fcm_token_test');
    when(() => mockUserRepo.registerFcmToken(any()))
        .thenAnswer((_) async {});
    when(() => mockAnalytics.logLogin(any())).thenAnswer((_) async {});
    when(() => mockAnalytics.logSignUp(any())).thenAnswer((_) async {});
    when(() => mockAnalytics.logLogout()).thenAnswer((_) async {});
    when(() => mockAnalytics.clearUser()).thenAnswer((_) async {});
    when(() => mockAnalytics.setUserId(any())).thenAnswer((_) async {});
    when(() => mockAnalytics.setUserMode(any())).thenAnswer((_) async {});
    when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});
    when(() => mockStorage.delete(key: any(named: 'key')))
        .thenAnswer((_) async {});
    when(() => mockStorage.read(key: any(named: 'key')))
        .thenAnswer((_) async => null);
    when(() => mockUserRepo.unregisterFcmToken(any()))
        .thenAnswer((_) async {});
  });

  tearDown(() async {
    await mockDb.close();
    getIt.unregister<WebSocketService>();
    getIt.unregister<NotificationService>();
    getIt.unregister<AnalyticsService>();
    getIt.unregister<UserRepository>();
  });

  AuthBloc buildBloc() => AuthBloc(
        mockAuthService,
        mockStorage,
        mockDb,
      );

  // ─── appStarted ───────────────────────────────────────────────────────────

  group('AppStarted', () {
    blocTest<AuthBloc, AuthState>(
      'émet unauthenticated quand aucun token stocké',
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthEvent.appStarted()),
      expect: () => [
        const AuthState.loading(),
        const AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'émet authenticated quand token valide présent',
      setUp: () {
        when(() => mockStorage.read(key: 'jwt_token'))
            .thenAnswer((_) async => _kValidToken);
        when(() => mockStorage.read(key: 'user_id'))
            .thenAnswer((_) async => 'user123');
        when(() => mockStorage.read(key: 'current_mode'))
            .thenAnswer((_) async => 'client');
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthEvent.appStarted()),
      expect: () => [
        const AuthState.loading(),
        isA<AuthState>().having(
          (s) => s.maybeWhen(
            authenticated: (_, userId, _) => userId,
            orElse: () => null,
          ),
          'userId',
          'user123',
        ),
      ],
    );
  });

  // ─── loginWithEmail ───────────────────────────────────────────────────────

  group('LoginWithEmail', () {
    final successBody = {
      'tokens': {'accessToken': _kValidToken},
      'data': {
        'user': {'_id': 'user123'},
      },
    };

    blocTest<AuthBloc, AuthState>(
      'émet authenticated après login email réussi',
      setUp: () {
        when(() => mockAuthService.login(any()))
            .thenAnswer((_) async => _buildResponse(successBody));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthEvent.loginWithEmail(
        email: 'test@cliceat.cm',
        password: 'password123',
      )),
      expect: () => [
        const AuthState.loading(),
        isA<AuthState>().having(
          (s) => s.maybeWhen(
            authenticated: (_, userId, _) => userId,
            orElse: () => null,
          ),
          'userId',
          'user123',
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'émet error avec mauvais credentials',
      setUp: () {
        when(() => mockAuthService.login(any()))
            .thenAnswer((_) async => _buildResponse(
              {'message': 'auth.error_invalid_credentials'},
              status: 401,
            ));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthEvent.loginWithEmail(
        email: 'test@cliceat.cm',
        password: 'wrong',
      )),
      expect: () => [
        const AuthState.loading(),
        isA<AuthState>().having(
          (s) => s.maybeWhen(
            error: (msg) => msg,
            orElse: () => null,
          ),
          'message',
          isNotNull,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'émet error réseau sur exception',
      setUp: () {
        when(() => mockAuthService.login(any()))
            .thenThrow(Exception('Network error'));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthEvent.loginWithEmail(
        email: 'test@cliceat.cm',
        password: 'password123',
      )),
      expect: () => [
        const AuthState.loading(),
        const AuthState.error(message: 'common.network_error'),
      ],
    );
  });

  // ─── logout ───────────────────────────────────────────────────────────────

  group('Logout', () {
    blocTest<AuthBloc, AuthState>(
      'émet unauthenticated après logout',
      setUp: () {
        when(() => mockAuthService.logout())
            .thenAnswer((_) async => _buildResponse({}));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthEvent.logout()),
      expect: () => [
        const AuthState.loading(),
        const AuthState.unauthenticated(),
      ],
    );
  });

  // ─── sessionExpired ───────────────────────────────────────────────────────

  group('SessionExpired', () {
    blocTest<AuthBloc, AuthState>(
      'émet unauthenticated sur sessionExpired',
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthEvent.sessionExpired()),
      expect: () => [const AuthState.unauthenticated()],
    );
  });

  // ─── Google Sign-In annulé ────────────────────────────────────────────────

  group('LoginWithGoogle', () {
    blocTest<AuthBloc, AuthState>(
      'émet error google si réponse non successful',
      setUp: () {
        when(() => mockAuthService.loginWithFirebase(any()))
            .thenAnswer((_) async => _buildResponse(
              {'message': 'Unauthorized'},
              status: 401,
            ));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthEvent.loginWithGoogle(
        token: 'invalid_google_token',
      )),
      expect: () => [
        const AuthState.loading(),
        const AuthState.error(message: 'auth.error_google'),
      ],
    );
  });
}

// ─── Helpers pour les DeleteStatement mocks ───────────────────────────────────

class MockDeleteStatement extends Mock {
  Future<int> go() async => 0;
}
