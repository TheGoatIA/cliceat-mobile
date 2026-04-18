import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../../../../core/data/local/database.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../core/services/analytics_service.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/profile/data/repositories/user_repository.dart';
import '../../data/datasources/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

/// Intervalle de vérification d'expiration du token JWT (toutes les 5 minutes).
const _kSessionCheckInterval = Duration(minutes: 5);

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final FlutterSecureStorage _secureStorage;
  final AppDatabase _db;
  final Logger _logger = Logger();

  /// Toutes les StreamSubscriptions ouvertes après auth, fermées dans [close].
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  /// Timer périodique de vérification d'expiration du JWT.
  Timer? _sessionTimer;

  AuthBloc(
    this._authService,
    this._secureStorage,
    this._db,
  ) : super(const AuthState.initial()) {
    on<_AppStarted>(_onAppStarted);
    on<_SendOtp>(_onSendOtp);
    on<_VerifyOtp>(_onVerifyOtp);
    on<_LoginWithEmail>(_onLoginWithEmail);
    on<_LoginDelivery>(_onLoginDelivery);
    on<_LoginWithGoogle>(_onLoginWithGoogle);
    on<_LoginWithApple>(_onLoginWithApple);
    on<_Register>(_onRegister);
    on<_ForgotPassword>(_onForgotPassword);
    on<_ResetPassword>(_onResetPassword);
    on<_VerifyEmail>(_onVerifyEmail);
    on<_ResendVerificationEmail>(_onResendVerificationEmail);
    on<_SwitchMode>(_onSwitchMode);
    on<_Logout>(_onLogout);
    on<_SessionExpired>(_onSessionExpired);
  }

  // ─── Event handlers ─────────────────────────────────────────────────────

  Future<void> _onAppStarted(_AppStarted event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      final userId = await _secureStorage.read(key: 'user_id');
      final currentMode =
          await _secureStorage.read(key: 'current_mode') ?? 'client';
      if (token != null && userId != null) {
        // Vérifier que le token n'a pas déjà expiré avant de restaurer la session
        if (_isTokenExpired(token)) {
          _logger.w('[Auth] Token expiré au démarrage — déconnexion.');
          await _clearCredentials();
          emit(const AuthState.unauthenticated());
          return;
        }
        await _postAuthSetup(token);
        _startSessionTimer(token);
        emit(AuthState.authenticated(
            token: token, userId: userId, currentMode: currentMode));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      _logger.e('[Auth] Erreur vérification état auth: $e');
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSendOtp(_SendOtp event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.sendOtp({
        'phone': event.phone,
        'countryCode': '237',
      });
      if (res.isSuccessful) {
        emit(AuthState.otpSent(phone: event.phone));
      } else {
        final msg = _extractError(res.body, 'auth.error_send_otp');
        emit(AuthState.error(message: msg));
      }
    } catch (e) {
      _logger.e('[Auth] Erreur envoi OTP: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onVerifyOtp(_VerifyOtp event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.verifyOtp({
        'phone': event.phone,
        'otp': event.otp,
      });
      if (res.isSuccessful && res.body != null) {
        final parsed = _parseAuthResponse(res.body);
        if (parsed != null) {
          await _persistAuth(parsed.$1, parsed.$2, 'client');
          await _postAuthSetup(parsed.$1);
          _startSessionTimer(parsed.$1);
          getIt<AnalyticsService>().logLogin('otp');
          getIt<AnalyticsService>().setUserId(parsed.$2);
          emit(AuthState.authenticated(
              token: parsed.$1, userId: parsed.$2, currentMode: 'client'));
        } else {
          emit(const AuthState.error(message: 'auth.error_invalid_response'));
        }
      } else {
        final msg = _extractError(res.body, 'auth.error_invalid_otp');
        emit(AuthState.error(message: msg));
      }
    } catch (e) {
      _logger.e('[Auth] Erreur vérification OTP: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onLoginWithEmail(
      _LoginWithEmail event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.login({
        'email': event.email,
        'password': event.password,
      });
      if (res.isSuccessful && res.body != null) {
        final parsed = _parseAuthResponse(res.body);
        if (parsed != null) {
          await _persistAuth(parsed.$1, parsed.$2, 'client');
          await _postAuthSetup(parsed.$1);
          _startSessionTimer(parsed.$1);
          getIt<AnalyticsService>().logLogin('email');
          getIt<AnalyticsService>().setUserId(parsed.$2);
          emit(AuthState.authenticated(
              token: parsed.$1, userId: parsed.$2, currentMode: 'client'));
        } else {
          emit(const AuthState.error(message: 'auth.error_invalid_response'));
        }
      } else {
        final msg = _extractError(res.body, 'auth.error_invalid_credentials');
        emit(AuthState.error(message: msg));
      }
    } catch (e) {
      _logger.e('[Auth] Erreur login email: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  /// Handler dédié au login livreur → POST /auth/delivery/login
  /// Le backend attend { phone, password } (pas email).
  Future<void> _onLoginDelivery(
      _LoginDelivery event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.loginDelivery({
        'phone': event.phone,
        'password': event.password,
      });
      if (res.isSuccessful && res.body != null) {
        final parsed = _parseAuthResponse(res.body);
        if (parsed != null) {
          await _persistAuth(parsed.$1, parsed.$2, 'delivery');
          await _postAuthSetup(parsed.$1);
          _startSessionTimer(parsed.$1);
          getIt<AnalyticsService>().logLogin('delivery_phone');
          getIt<AnalyticsService>().setUserId(parsed.$2);
          emit(AuthState.authenticated(
              token: parsed.$1, userId: parsed.$2, currentMode: 'delivery'));
        } else {
          emit(const AuthState.error(message: 'auth.error_invalid_response'));
        }
      } else {
        final msg = _extractError(res.body, 'auth.error_invalid_credentials');
        emit(AuthState.error(message: msg));
      }
    } catch (e) {
      _logger.e('[Auth] Erreur login livreur: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onLoginWithGoogle(
      _LoginWithGoogle event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.loginWithFirebase({
        'idToken': event.token,
      });
      if (res.isSuccessful && res.body != null) {
        final parsed = _parseAuthResponse(res.body);
        if (parsed != null) {
          await _persistAuth(parsed.$1, parsed.$2, 'client');
          await _postAuthSetup(parsed.$1);
          _startSessionTimer(parsed.$1);
          getIt<AnalyticsService>().logLogin('google');
          getIt<AnalyticsService>().setUserId(parsed.$2);
          emit(AuthState.authenticated(
              token: parsed.$1, userId: parsed.$2, currentMode: 'client'));
        } else {
          emit(const AuthState.error(message: 'auth.error_invalid_response'));
        }
      } else {
        emit(const AuthState.error(message: 'auth.error_google'));
      }
    } catch (e) {
      _logger.e('[Auth] Erreur login Google: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onLoginWithApple(
      _LoginWithApple event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.loginWithFirebase({
        'idToken': event.token,
      });
      if (res.isSuccessful && res.body != null) {
        final parsed = _parseAuthResponse(res.body);
        if (parsed != null) {
          await _persistAuth(parsed.$1, parsed.$2, 'client');
          await _postAuthSetup(parsed.$1);
          _startSessionTimer(parsed.$1);
          getIt<AnalyticsService>().logLogin('apple');
          getIt<AnalyticsService>().setUserId(parsed.$2);
          emit(AuthState.authenticated(
              token: parsed.$1, userId: parsed.$2, currentMode: 'client'));
        } else {
          emit(const AuthState.error(message: 'auth.error_invalid_response'));
        }
      } else {
        emit(const AuthState.error(message: 'auth.error_apple'));
      }
    } catch (e) {
      _logger.e('[Auth] Erreur login Apple: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onRegister(_Register event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.register({
        'name': event.name,
        'email': event.email,
        'password': event.password,
        'city': event.city,
      });
      if (res.isSuccessful && res.body != null) {
        final body = res.body as Map<String, dynamic>?;
        final parsed = _parseAuthResponse(res.body);
        final hasTokens = parsed != null;

        final requiresVerification =
            body?['requiresEmailVerification'] as bool? ??
            (!hasTokens &&
                (body?['message']
                        ?.toString()
                        .toLowerCase()
                        .contains('verify') ??
                    false));

        if (requiresVerification || !hasTokens) {
          emit(AuthState.emailVerificationRequired(email: event.email));
          return;
        }

        // We are guaranteed to have tokens here
        await _persistAuth(parsed.$1, parsed.$2, 'client');
        await _postAuthSetup(parsed.$1);
        _startSessionTimer(parsed.$1);
        getIt<AnalyticsService>().logSignUp('email');
        getIt<AnalyticsService>().setUserId(parsed.$2);
        emit(AuthState.authenticated(
            token: parsed.$1, userId: parsed.$2, currentMode: 'client'));
      } else {
        final msg = _extractError(res.body, 'auth.error_register');
        emit(AuthState.error(message: msg));
      }
    } catch (e) {
      _logger.e('[Auth] Erreur inscription: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onForgotPassword(
      _ForgotPassword event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.forgotPassword({'email': event.email});
      if (res.isSuccessful) {
        emit(AuthState.forgotPasswordEmailSent(email: event.email));
      } else {
        final msg = _extractError(res.body, 'auth.error_forgot_password');
        emit(AuthState.error(message: msg));
      }
    } catch (e) {
      _logger.e('[Auth] Erreur mot de passe oublié: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onResetPassword(
      _ResetPassword event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.resetPassword({
        'token': event.token,
        'password': event.newPassword,
      });
      if (res.isSuccessful) {
        emit(const AuthState.resetPasswordSuccess());
      } else {
        final msg = _extractError(res.body, 'auth.error_reset_password');
        emit(AuthState.error(message: msg));
      }
    } catch (e) {
      _logger.e('[Auth] Erreur réinitialisation mot de passe: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onVerifyEmail(
      _VerifyEmail event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.verifyEmail(event.token);
      if (res.isSuccessful) {
        emit(const AuthState.emailVerified());
      } else {
        final msg = _extractError(res.body, 'auth.error_verify_email');
        emit(AuthState.error(message: msg));
      }
    } catch (e) {
      _logger.e('[Auth] Erreur vérification email: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onResendVerificationEmail(
      _ResendVerificationEmail event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService
          .resendVerificationEmail({'email': event.email});
      if (res.isSuccessful) {
        emit(AuthState.emailVerificationRequired(email: event.email));
      } else {
        final msg =
            _extractError(res.body, 'auth.error_resend_verification');
        emit(AuthState.error(message: msg));
      }
    } catch (e) {
      _logger.e('[Auth] Erreur renvoi email vérification: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onSwitchMode(
      _SwitchMode event, Emitter<AuthState> emit) async {
    state.maybeWhen(
      authenticated: (token, userId, currentMode) async {
        await _secureStorage.write(key: 'current_mode', value: event.mode);
        getIt<AnalyticsService>().setUserMode(event.mode);
        emit(AuthState.authenticated(
            token: token, userId: userId, currentMode: event.mode));
      },
      orElse: () {},
    );
  }

  Future<void> _onLogout(_Logout event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    _stopSessionTimer();
    await _cancelSubscriptions();
    // Revoke FCM token before clearing credentials
    await _revokeFcmToken();
    try {
      try {
        await _authService.logout();
      } catch (_) {}
      getIt<WebSocketService>().disconnect();
      getIt<AnalyticsService>().logLogout();
      getIt<AnalyticsService>().clearUser();
      await _clearCredentials();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      _logger.e('[Auth] Erreur déconnexion: $e');
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSessionExpired(
      _SessionExpired event, Emitter<AuthState> emit) async {
    _logger.w('[Auth] Session expirée — déconnexion automatique.');
    _stopSessionTimer();
    await _cancelSubscriptions();
    await _revokeFcmToken();
    getIt<WebSocketService>().disconnect();
    await _clearCredentials();
    emit(const AuthState.unauthenticated());
  }

  // ─── Session timer ────────────────────────────────────────────────────────

  /// Démarre un timer périodique qui vérifie l'expiration du JWT.
  void _startSessionTimer(String token) {
    _stopSessionTimer();
    _sessionTimer =
        Timer.periodic(_kSessionCheckInterval, (_) {
      if (_isTokenExpired(token)) {
        add(const AuthEvent.sessionExpired());
      }
    });
  }

  void _stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  /// Décode le payload JWT (base64url) et vérifie le champ `exp`.
  /// Retourne `true` si le token est expiré ou non décodable.
  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      // Base64url → base64 standard
      final payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      final decoded = utf8.decode(
        base64Decode(payload.padRight(
          payload.length + (4 - payload.length % 4) % 4,
          '=',
        )),
      );
      final map = jsonDecode(decoded) as Map<String, dynamic>;
      final exp = map['exp'] as int?;
      if (exp == null) return false;
      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      // Considérer expiré si moins de 2 minutes restantes
      return DateTime.now().isAfter(
          expiry.subtract(const Duration(minutes: 2)));
    } catch (_) {
      return false; // Token malformé → ne pas déconnecter de force
    }
  }

  // ─── Post-auth setup ──────────────────────────────────────────────────────

  /// Appelé après chaque authentification réussie.
  /// Connecte le WebSocket et enregistre le token FCM.
  /// Les erreurs FCM et WebSocket sont indépendantes pour éviter les races.
  Future<void> _postAuthSetup(String token) async {
    // WebSocket — indépendant de FCM
    try {
      final wsSub = getIt<WebSocketService>().statusStream.listen(
        (status) => _logger.d('[Auth/WS] Statut: $status'),
        onError: (e) => _logger.w('[Auth/WS] Erreur stream: $e'),
      );
      _subscriptions.add(wsSub);
      await getIt<WebSocketService>().connect();
    } catch (e) {
      _logger.w('[Auth] Connexion WebSocket échouée: $e');
    }

    // FCM — indépendant du WebSocket
    try {
      final fcmToken = await getIt<NotificationService>().getFcmToken();
      if (fcmToken != null) {
        await getIt<UserRepository>().registerFcmToken(fcmToken);
      }
    } catch (e) {
      _logger.w('[Auth] Enregistrement FCM échoué: $e');
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Parse la réponse d'auth : retourne (accessToken, userId) ou null.
  (String, String)? _parseAuthResponse(dynamic body) {
    try {
      final map = body as Map<String, dynamic>;
      final tokens = map['tokens'] as Map<String, dynamic>?;
      final token = tokens?['accessToken'] as String?;
      final data = map['data'] as Map<String, dynamic>?;
      final user = data?['user'] as Map<String, dynamic>?;
      final userId =
          user?['_id']?.toString() ?? user?['id']?.toString();
      if (token != null && userId != null) return (token, userId);
      return null;
    } catch (_) {
      return null;
    }
  }

  String _extractError(dynamic body, String fallback) {
    try {
      return (body as Map<String, dynamic>)['message']?.toString() ??
          fallback;
    } catch (_) {
      return fallback;
    }
  }

  Future<void> _persistAuth(String token, String userId, String mode) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
    await _secureStorage.write(key: 'user_id', value: userId);
    await _secureStorage.write(key: 'current_mode', value: mode);
  }

  /// Révoque le token FCM côté Firebase et côté backend.
  Future<void> _revokeFcmToken() async {
    try {
      final fcmToken = await getIt<NotificationService>().getFcmToken();
      if (fcmToken != null) {
        await getIt<UserRepository>().unregisterFcmToken(fcmToken).catchError((_) {});
      }
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      _logger.w('[Auth] Révocation token FCM échouée: $e');
    }
  }

  Future<void> _clearCredentials() async {
    await _secureStorage.delete(key: 'jwt_token');
    await _secureStorage.delete(key: 'user_id');
    await _secureStorage.delete(key: 'current_mode');
    await _db.delete(_db.userPrefsTable).go();
    await _db.delete(_db.cartTable).go();
  }

  Future<void> _cancelSubscriptions() async {
    await Future.wait(_subscriptions.map((s) => s.cancel()));
    _subscriptions.clear();
  }

  // ─── close ────────────────────────────────────────────────────────────────

  @override
  Future<void> close() async {
    _stopSessionTimer();
    await _cancelSubscriptions();
    return super.close();
  }
}
