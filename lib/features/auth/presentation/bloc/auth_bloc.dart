import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/datasources/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final FlutterSecureStorage _secureStorage;

  AuthBloc(this._authService, this._secureStorage)
      : super(const AuthState.initial()) {
    on<_AppStarted>(_onAppStarted);
    on<_SendOtp>(_onSendOtp);
    on<_VerifyOtp>(_onVerifyOtp);
    on<_LoginWithEmail>(_onLoginWithEmail);
    on<_SwitchMode>(_onSwitchMode);
    on<_Logout>(_onLogout);
  }

  Future<void> _onAppStarted(
    _AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      final userId = await _secureStorage.read(key: 'user_id');
      final mode =
          await _secureStorage.read(key: 'user_mode') ?? 'client';
      if (token != null && userId != null) {
        emit(AuthState.authenticated(
          token: token,
          userId: userId,
          currentMode: mode,
        ));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (_) {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSendOtp(
    _SendOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final response = await _authService.sendOtp({
        'phone': event.phone,
        'countryCode': '237',
      });
      if (response.isSuccessful) {
        emit(AuthState.otpSent(phone: event.phone));
      } else {
        emit(AuthState.error(message: _parseError(response)));
      }
    } catch (_) {
      emit(const AuthState.error(
          message: 'Erreur réseau. Vérifiez votre connexion.'));
    }
  }

  Future<void> _onVerifyOtp(
    _VerifyOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final response = await _authService.verifyOtp({
        'phone': event.phone,
        'otp': event.otp,
      });
      if (response.isSuccessful) {
        final data = response.body as Map<String, dynamic>;
        final tokens = data['tokens'] as Map<String, dynamic>;
        final user = data['data'] as Map<String, dynamic>;
        await _saveSession(
          tokens['accessToken'] as String,
          user['_id'] as String,
          'client',
        );
        emit(AuthState.authenticated(
          token: tokens['accessToken'] as String,
          userId: user['_id'] as String,
          currentMode: 'client',
        ));
      } else {
        emit(AuthState.error(message: _parseError(response)));
      }
    } catch (_) {
      emit(const AuthState.error(
          message: 'Erreur réseau. Vérifiez votre connexion.'));
    }
  }

  Future<void> _onLoginWithEmail(
    _LoginWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final response = await _authService.login({
        'email': event.email,
        'password': event.password,
      });
      if (response.isSuccessful) {
        final data = response.body as Map<String, dynamic>;
        final tokens = data['tokens'] as Map<String, dynamic>;
        final user = data['data'] as Map<String, dynamic>;
        final mode = (user['role'] as String?) == 'deliveryman'
            ? 'deliveryman'
            : 'client';
        await _saveSession(
          tokens['accessToken'] as String,
          user['_id'] as String,
          mode,
        );
        emit(AuthState.authenticated(
          token: tokens['accessToken'] as String,
          userId: user['_id'] as String,
          currentMode: mode,
        ));
      } else {
        emit(AuthState.error(message: _parseError(response)));
      }
    } catch (_) {
      emit(const AuthState.error(
          message: 'Erreur réseau. Vérifiez votre connexion.'));
    }
  }

  Future<void> _onSwitchMode(
    _SwitchMode event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    await currentState.maybeWhen(
      authenticated: (token, userId, _) async {
        await _secureStorage.write(key: 'user_mode', value: event.mode);
        emit(AuthState.authenticated(
          token: token,
          userId: userId,
          currentMode: event.mode,
        ));
      },
      orElse: () async {},
    );
  }

  Future<void> _onLogout(
    _Logout event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      await _authService.logout();
    } catch (_) {}
    await _secureStorage.deleteAll();
    emit(const AuthState.unauthenticated());
  }

  Future<void> _saveSession(
      String token, String userId, String mode) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
    await _secureStorage.write(key: 'user_id', value: userId);
    await _secureStorage.write(key: 'user_mode', value: mode);
  }

  String _parseError(dynamic response) {
    try {
      final body = response.error as Map<String, dynamic>;
      return body['message'] as String? ?? 'Une erreur est survenue.';
    } catch (_) {
      return 'Erreur ${response.statusCode}. Réessayez.';
    }
  }
}
