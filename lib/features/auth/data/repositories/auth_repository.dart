import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/shared/models/user_model.dart';
import 'package:cliceat_app/features/auth/data/datasources/auth_service.dart';
import 'package:cliceat_app/core/network/services/user_service.dart';
import 'package:cliceat_app/core/services/notification_service.dart';
import 'package:cliceat_app/core/services/device_service.dart';

/// Abstracts all authentication operations and token persistence.
@lazySingleton
class AuthRepository {
  final AuthService _authService;
  final UserService _userService;
  final NotificationService _notificationService;
  final DeviceService _deviceService;
  final FlutterSecureStorage _secureStorage;

  AuthRepository(
    this._authService,
    this._userService,
    this._notificationService,
    this._deviceService,
    this._secureStorage,
  );

  // ─── Token persistence helpers ────────────────────────────────────────────

  Future<String?> getToken() => _secureStorage.read(key: 'jwt_token');
  Future<String?> getUserId() => _secureStorage.read(key: 'user_id');
  Future<String?> getCurrentMode() => _secureStorage.read(key: 'current_mode');

  Future<void> persistAuth(String token, String userId, String mode) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
    await _secureStorage.write(key: 'user_id', value: userId);
    await _secureStorage.write(key: 'current_mode', value: mode);
  }

  Future<void> clearAuth() async {
    await _secureStorage.delete(key: 'jwt_token');
    await _secureStorage.delete(key: 'user_id');
    await _secureStorage.delete(key: 'current_mode');
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    final userId = await getUserId();
    return token != null && userId != null;
  }

  // ─── Email / password ─────────────────────────────────────────────────────

  Future<Either<AppError, (String, String)>> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      final deviceInfo = await _deviceService.getDeviceInfo();
      final res = await _authService.login({
        'email': email,
        'password': password,
        ...deviceInfo,
      });
      if (res.isSuccessful && res.body != null) {
        final parsed = _parseTokenAndUserId(res.body);
        if (parsed != null) {
          _syncFcmToken();
          return Right(parsed);
        }
        return Left(
          AppError.fromResponse(res.body, 'auth.error_invalid_response'),
        );
      }
      return Left(
        AppError.fromResponse(
          res.body,
          'auth.error_invalid_credentials',
          statusCode: res.statusCode,
        ),
      );
    } catch (e, s) {
      debugPrint('[auth_repository.dart] error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> register({
    required String name,
    required String email,
    required String password,
    required String city,
  }) async {
    try {
      final deviceInfo = await _deviceService.getDeviceInfo();
      final res = await _authService.register({
        'name': name,
        'email': email,
        'password': password,
        'city': city,
        ...deviceInfo,
      });
      if (res.isSuccessful) return const Right(null);
      return Left(
        AppError.fromResponse(
          res.body,
          'auth.error_register',
          statusCode: res.statusCode,
        ),
      );
    } catch (e, s) {
      debugPrint('[auth_repository.dart] error: $e\n$s');
      return Left(AppError.network());
    }
  }

  // ─── OTP (phone) ──────────────────────────────────────────────────────────

  Future<Either<AppError, void>> sendOtp(String phone) async {
    try {
      final res = await _authService.sendOtp({
        'phone': phone,
        'countryCode': '237',
      });
      if (res.isSuccessful) return const Right(null);
      return Left(
        AppError.fromResponse(
          res.body,
          'auth.error_send_otp',
          statusCode: res.statusCode,
        ),
      );
    } catch (e, s) {
      debugPrint('[auth_repository.dart] error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, (String, String)>> verifyOtp(
    String phone,
    String otp,
  ) async {
    try {
      final deviceInfo = await _deviceService.getDeviceInfo();
      final res = await _authService.verifyOtp({
        'phone': phone,
        'otp': otp,
        ...deviceInfo,
      });
      if (res.isSuccessful && res.body != null) {
        final parsed = _parseTokenAndUserId(res.body);
        if (parsed != null) {
          _syncFcmToken();
          return Right(parsed);
        }
        return Left(
          AppError.fromResponse(res.body, 'auth.error_invalid_response'),
        );
      }
      return Left(
        AppError.fromResponse(
          res.body,
          'auth.error_invalid_otp',
          statusCode: res.statusCode,
        ),
      );
    } catch (e, s) {
      debugPrint('[auth_repository.dart] error: $e\n$s');
      return Left(AppError.network());
    }
  }

  // ─── Social ───────────────────────────────────────────────────────────────

  Future<Either<AppError, (String, String)>> loginWithFirebase(
    String idToken,
  ) async {
    try {
      final deviceInfo = await _deviceService.getDeviceInfo();
      final res = await _authService.loginWithFirebase({
        'idToken': idToken,
        ...deviceInfo,
      });
      if (res.isSuccessful && res.body != null) {
        final parsed = _parseTokenAndUserId(res.body);
        if (parsed != null) {
          _syncFcmToken();
          return Right(parsed);
        }
        return Left(
          AppError.fromResponse(res.body, 'auth.error_invalid_response'),
        );
      }
      return Left(
        AppError.fromResponse(
          res.body,
          'auth.error_google',
          statusCode: res.statusCode,
        ),
      );
    } catch (e, s) {
      debugPrint('[auth_repository.dart] error: $e\n$s');
      return Left(AppError.network());
    }
  }

  // ─── Password reset ───────────────────────────────────────────────────────

  Future<Either<AppError, void>> forgotPassword(String email) async {
    try {
      final res = await _authService.forgotPassword({'email': email});
      if (res.isSuccessful) return const Right(null);
      return Left(
        AppError.fromResponse(res.body, 'auth.error_forgot_password'),
      );
    } catch (e, s) {
      debugPrint('[auth_repository.dart] error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> resetPassword(
    String token,
    String newPassword,
  ) async {
    try {
      final res = await _authService.resetPassword({
        'token': token,
        'password': newPassword,
      });
      if (res.isSuccessful) return const Right(null);
      return Left(AppError.fromResponse(res.body, 'auth.error_reset_password'));
    } catch (e, s) {
      debugPrint('[auth_repository.dart] error: $e\n$s');
      return Left(AppError.network());
    }
  }

  // ─── Email verification ───────────────────────────────────────────────────

  Future<Either<AppError, void>> verifyEmail(String token) async {
    try {
      final res = await _authService.verifyEmail(token);
      if (res.isSuccessful) return const Right(null);
      return Left(AppError.fromResponse(res.body, 'auth.error_verify_email'));
    } catch (e, s) {
      debugPrint('[auth_repository.dart] error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> resendVerificationEmail(String email) async {
    try {
      final res = await _authService.resendVerificationEmail({'email': email});
      if (res.isSuccessful) return const Right(null);
      return Left(
        AppError.fromResponse(res.body, 'auth.error_resend_verification'),
      );
    } catch (e, s) {
      debugPrint('[auth_repository.dart] error: $e\n$s');
      return Left(AppError.network());
    }
  }

  // ─── Logout ───────────────────────────────────────────────────────────────

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e, s) {
      debugPrint('[auth_repository.dart] error: $e\n$s');
    }
    await clearAuth();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Extracts (accessToken, userId) from an auth response body.
  /// Response format: { tokens: { accessToken }, data: { user: { _id } } }
  (String, String)? _parseTokenAndUserId(dynamic body) {
    try {
      final map = body as Map<String, dynamic>;
      final tokens = map['tokens'] as Map<String, dynamic>?;
      final token = tokens?['accessToken'] as String?;
      final data = map['data'] as Map<String, dynamic>?;
      final user = data?['user'] as Map<String, dynamic>?;
      final userId = user?['_id']?.toString() ?? user?['id']?.toString();
      if (token != null && userId != null) return (token, userId);
      return null;
    } catch (e, s) {
      debugPrint('[auth_repository.dart] error: $e\n$s');
      return null;
    }
  }

  /// Extracts [UserModel] from an auth response body if available.
  UserModel? extractUser(dynamic body) {
    try {
      final map = body as Map<String, dynamic>;
      final data = map['data'] as Map<String, dynamic>?;
      final user = data?['user'] as Map<String, dynamic>?;
      if (user != null) return UserModel.fromJson(user);
      return null;
    } catch (e, s) {
      debugPrint('[auth_repository.dart] error: $e\n$s');
      return null;
    }
  }

  Future<void> _syncFcmToken() async {
    try {
      final token = await _notificationService.getFcmToken();
      if (token != null) {
        // Simple mapping to 'fr' or 'en'
        final systemLocale = PlatformDispatcher.instance.locale.languageCode;
        final locale = systemLocale.startsWith('en') ? 'en' : 'fr';

        await _userService.registerFcmToken({'token': token, 'locale': locale});
      }
    } catch (e, s) {
      debugPrint('[auth_repository.dart] error: $e\n$s');
    }
  }
}
