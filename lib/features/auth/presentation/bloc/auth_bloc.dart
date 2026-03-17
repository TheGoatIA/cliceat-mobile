import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../../../../core/data/local/database.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/services/user_service.dart';
import '../../data/datasources/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final FlutterSecureStorage _secureStorage;
  final AppDatabase _db;
  final Logger _logger = Logger();

  AuthBloc(
    this._authService,
    this._secureStorage,
    this._db,
  ) : super(const AuthState.initial()) {
    on<_AppStarted>(_onAppStarted);
    on<_SendOtp>(_onSendOtp);
    on<_VerifyOtp>(_onVerifyOtp);
    on<_LoginWithEmail>(_onLoginWithEmail);
    on<_LoginWithGoogle>(_onLoginWithGoogle);
    on<_LoginWithApple>(_onLoginWithApple);
    on<_Register>(_onRegister);
    on<_ForgotPassword>(_onForgotPassword);
    on<_ResetPassword>(_onResetPassword);
    on<_VerifyEmail>(_onVerifyEmail);
    on<_ResendVerificationEmail>(_onResendVerificationEmail);
    on<_SwitchMode>(_onSwitchMode);
    on<_Logout>(_onLogout);
  }

  Future<void> _onAppStarted(_AppStarted event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      final userId = await _secureStorage.read(key: 'user_id');
      final currentMode =
          await _secureStorage.read(key: 'current_mode') ?? 'client';
      if (token != null && userId != null) {
        await _postAuthSetup(token);
        emit(AuthState.authenticated(
            token: token, userId: userId, currentMode: currentMode));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      _logger.e("Error checking auth state: $e");
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSendOtp(_SendOtp event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.sendOtp({
        "phone": event.phone,
        "countryCode": "237",
      });
      if (res.isSuccessful) {
        emit(AuthState.otpSent(phone: event.phone));
      } else {
        final msg = _extractError(res.body, 'auth.error_send_otp');
        emit(AuthState.error(message: msg));
      }
    } catch (e) {
      _logger.e("Error sending OTP: $e");
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onVerifyOtp(_VerifyOtp event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.verifyOtp({
        "phone": event.phone,
        "otp": event.otp,
      });
      if (res.isSuccessful && res.body != null) {
        final parsed = _parseAuthResponse(res.body);
        if (parsed != null) {
          await _persistAuth(parsed.$1, parsed.$2, 'client');
          await _postAuthSetup(parsed.$1);
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
      _logger.e("Error verifying OTP: $e");
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onLoginWithEmail(
      _LoginWithEmail event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.login({
        "email": event.email,
        "password": event.password,
      });
      if (res.isSuccessful && res.body != null) {
        final parsed = _parseAuthResponse(res.body);
        if (parsed != null) {
          await _persistAuth(parsed.$1, parsed.$2, 'client');
          await _postAuthSetup(parsed.$1);
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
      _logger.e("Error logging in: $e");
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onLoginWithGoogle(
      _LoginWithGoogle event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.loginWithFirebase({
        "idToken": event.token,
      });
      if (res.isSuccessful && res.body != null) {
        final parsed = _parseAuthResponse(res.body);
        if (parsed != null) {
          await _persistAuth(parsed.$1, parsed.$2, 'client');
          await _postAuthSetup(parsed.$1);
          emit(AuthState.authenticated(
              token: parsed.$1, userId: parsed.$2, currentMode: 'client'));
        } else {
          emit(const AuthState.error(message: 'auth.error_invalid_response'));
        }
      } else {
        emit(const AuthState.error(message: 'auth.error_google'));
      }
    } catch (e) {
      _logger.e("Error logging in with Google: $e");
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onLoginWithApple(
      _LoginWithApple event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.loginWithFirebase({
        "idToken": event.token,
      });
      if (res.isSuccessful && res.body != null) {
        final parsed = _parseAuthResponse(res.body);
        if (parsed != null) {
          await _persistAuth(parsed.$1, parsed.$2, 'client');
          await _postAuthSetup(parsed.$1);
          emit(AuthState.authenticated(
              token: parsed.$1, userId: parsed.$2, currentMode: 'client'));
        } else {
          emit(const AuthState.error(message: 'auth.error_invalid_response'));
        }
      } else {
        emit(const AuthState.error(message: 'auth.error_apple'));
      }
    } catch (e) {
      _logger.e("Error logging in with Apple: $e");
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onRegister(_Register event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.register({
        "name": event.name,
        "email": event.email,
        "password": event.password,
        "city": event.city,
      });
      if (res.isSuccessful && res.body != null) {
        final body = res.body as Map<String, dynamic>?;
        // Backend may require email verification before issuing token
        final requiresVerification = body?['requiresEmailVerification'] as bool? ?? false;
        if (requiresVerification) {
          emit(AuthState.emailVerificationRequired(email: event.email));
          return;
        }
        final parsed = _parseAuthResponse(res.body);
        if (parsed != null) {
          await _persistAuth(parsed.$1, parsed.$2, 'client');
          await _postAuthSetup(parsed.$1);
          getIt<AnalyticsService>().logSignUp('email');
          getIt<AnalyticsService>().setUserId(parsed.$2);
          emit(AuthState.authenticated(
              token: parsed.$1, userId: parsed.$2, currentMode: 'client'));
        } else {
          emit(const AuthState.error(message: 'auth.error_invalid_response'));
        }
      } else {
        final msg = _extractError(res.body, 'auth.error_register');
        emit(AuthState.error(message: msg));
      }
    } catch (e) {
      _logger.e("Error registering: $e");
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onForgotPassword(_ForgotPassword event, Emitter<AuthState> emit) async {
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
      _logger.e('Error sending forgot password: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onResetPassword(_ResetPassword event, Emitter<AuthState> emit) async {
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
      _logger.e('Error resetting password: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onVerifyEmail(_VerifyEmail event, Emitter<AuthState> emit) async {
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
      _logger.e('Error verifying email: $e');
      emit(const AuthState.error(message: 'common.network_error'));
    }
  }

  Future<void> _onResendVerificationEmail(_ResendVerificationEmail event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final res = await _authService.resendVerificationEmail({'email': event.email});
      if (res.isSuccessful) {
        emit(AuthState.emailVerificationRequired(email: event.email));
      } else {
        final msg = _extractError(res.body, 'auth.error_resend_verification');
        emit(AuthState.error(message: msg));
      }
    } catch (e) {
      _logger.e('Error resending verification email: $e');
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
    try {
      // Attempt server logout (best effort)
      await _authService.logout().catchError((_) {});
      // Disconnect WebSocket
      getIt<WebSocketService>().disconnect();
      getIt<AnalyticsService>().logLogout();
      getIt<AnalyticsService>().clearUser();
      // Clear local storage
      await _secureStorage.delete(key: 'jwt_token');
      await _secureStorage.delete(key: 'user_id');
      await _secureStorage.delete(key: 'current_mode');
      await _db.delete(_db.userPrefsTable).go();
      await _db.delete(_db.cartTable).go();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      _logger.e("Error logging out: $e");
      emit(const AuthState.unauthenticated());
    }
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  /// Parse auth response: returns (accessToken, userId) or null on failure.
  /// API format: { success, data: { user: { _id } }, tokens: { accessToken } }
  (String, String)? _parseAuthResponse(dynamic body) {
    try {
      final map = body as Map<String, dynamic>;
      final tokens = map['tokens'] as Map<String, dynamic>?;
      final token = tokens?['accessToken'] as String?;
      final data = map['data'] as Map<String, dynamic>?;
      final user = data?['user'] as Map<String, dynamic>?;
      final userId = user?['_id']?.toString() ?? user?['id']?.toString();
      if (token != null && userId != null) return (token, userId);
      return null;
    } catch (_) {
      return null;
    }
  }

  String _extractError(dynamic body, String fallback) {
    try {
      return (body as Map<String, dynamic>)['message']?.toString() ?? fallback;
    } catch (_) {
      return fallback;
    }
  }

  Future<void> _persistAuth(
      String token, String userId, String mode) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
    await _secureStorage.write(key: 'user_id', value: userId);
    await _secureStorage.write(key: 'current_mode', value: mode);
  }

  /// Called after successful auth: connect WebSocket + register FCM token
  Future<void> _postAuthSetup(String token) async {
    try {
      // Connect WebSocket for real-time events
      await getIt<WebSocketService>().connect();
    } catch (e) {
      _logger.w('WebSocket connect failed: $e');
    }
    try {
      // Register FCM token with backend
      final fcmToken = await getIt<NotificationService>().getFcmToken();
      if (fcmToken != null) {
        await getIt<UserService>()
            .registerFcmToken({'token': fcmToken});
      }
    } catch (e) {
      _logger.w('FCM token registration failed: $e');
    }
  }
}
