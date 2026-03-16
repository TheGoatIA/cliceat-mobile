import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/data/local/database.dart';
import '../../data/datasources/auth_service.dart';
import 'package:logger/logger.dart';

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
    
    // Check local session
    on<_AppStarted>((event, emit) async {
      emit(const AuthState.loading());
      try {
        final token = await _secureStorage.read(key: 'jwt_token');
        final userId = await _secureStorage.read(key: 'user_id');
        final currentMode = await _secureStorage.read(key: 'current_mode') ?? 'client';
        
        if (token != null && userId != null) {
          emit(AuthState.authenticated(token: token, userId: userId, currentMode: currentMode));
        } else {
          emit(const AuthState.unauthenticated());
        }
      } catch (e) {
        _logger.e("Error checking auth state: $e");
        emit(const AuthState.unauthenticated());
      }
    });

    on<_SendOtp>((event, emit) async {
      emit(const AuthState.loading());
      try {
        final res = await _authService.sendOtp({
          "phone": event.phone,
          "channel": "sms"
        });
        if (res.isSuccessful) {
          emit(AuthState.otpSent(phone: event.phone));
        } else {
          emit(const AuthState.unauthenticated());
        }
      } catch (e) {
        _logger.e("Error sending OTP: $e");
        emit(const AuthState.unauthenticated());
      }
    });

    on<_VerifyOtp>((event, emit) async {
      emit(const AuthState.loading());
      try {
        final res = await _authService.verifyOtp({
          "phone": event.phone,
          "otp": event.otp
        });
        if (res.isSuccessful && res.body != null) {
          final data = res.body as Map<String, dynamic>;
          final token = data['token'] as String;
          final user = data['user'] as Map<String, dynamic>;
          final userId = user['id'] as String;
          
          await _persistAuth(token, userId, 'client');
          emit(AuthState.authenticated(token: token, userId: userId, currentMode: 'client'));
        } else {
          emit(const AuthState.unauthenticated());
        }
      } catch (e) {
        _logger.e("Error verifying OTP: $e");
        emit(const AuthState.unauthenticated());
      }
    });

    on<_LoginWithEmail>((event, emit) async {
      emit(const AuthState.loading());
      try {
        final res = await _authService.login({
          "email": event.email,
          "password": event.password
        });
        if (res.isSuccessful && res.body != null) {
          final data = res.body as Map<String, dynamic>;
          final token = data['token'] as String;
          final user = data['user'] as Map<String, dynamic>;
          final userId = user['id'].toString();
          
          await _persistAuth(token, userId, 'client');
          emit(AuthState.authenticated(token: token, userId: userId, currentMode: 'client'));
        } else {
          emit(const AuthState.unauthenticated());
        }
      } catch (e) {
        _logger.e("Error logging in: $e");
        emit(const AuthState.unauthenticated());
      }
    });

    on<_LoginWithGoogle>((event, emit) async {
       emit(const AuthState.loading());
       try {
         final res = await _authService.loginWithGoogle({
           "token": event.token,
         });
         
         if (res.isSuccessful && res.body != null) {
           final data = res.body as Map<String, dynamic>;
           final token = data['token'] as String;
           final user = data['user'] as Map<String, dynamic>;
           final userId = user['id'].toString();
           
           await _persistAuth(token, userId, 'client');
           emit(AuthState.authenticated(token: token, userId: userId, currentMode: 'client'));
         } else {
           emit(const AuthState.unauthenticated());
         }
       } catch (e) {
         _logger.e("Error logging in with Google: $e");
         emit(const AuthState.unauthenticated());
       }
    });

    on<_LoginWithApple>((event, emit) async {
       emit(const AuthState.loading());
       try {
         final res = await _authService.loginWithApple({
           "token": event.token,
         });
         
         if (res.isSuccessful && res.body != null) {
           final data = res.body as Map<String, dynamic>;
           final token = data['token'] as String;
           final user = data['user'] as Map<String, dynamic>;
           final userId = user['id'].toString();
           
           await _persistAuth(token, userId, 'client');
           emit(AuthState.authenticated(token: token, userId: userId, currentMode: 'client'));
         } else {
           emit(const AuthState.unauthenticated());
         }
       } catch (e) {
         _logger.e("Error logging in with Apple: $e");
         emit(const AuthState.unauthenticated());
       }
    });
    
    on<_SwitchMode>((event, emit) async {
      state.maybeWhen(
        authenticated: (token, userId, currentMode) async {
          await _secureStorage.write(key: 'current_mode', value: event.mode);
          emit(AuthState.authenticated(token: token, userId: userId, currentMode: event.mode));
        },
        orElse: () {},
      );
    });

    on<_Logout>((event, emit) async {
      emit(const AuthState.loading());
      try {
        await _secureStorage.delete(key: 'jwt_token');
        await _secureStorage.delete(key: 'user_id');
        await _secureStorage.delete(key: 'current_mode');
        // Clear UserPrefs Table
        await _db.delete(_db.userPrefsTable).go();
        emit(const AuthState.unauthenticated());
      } catch (e) {
        _logger.e("Error logging out: $e");
        emit(const AuthState.unauthenticated());
      }
    });
  }

  Future<void> _persistAuth(String token, String userId, String mode) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
    await _secureStorage.write(key: 'user_id', value: userId);
    await _secureStorage.write(key: 'current_mode', value: mode);
  }
}
