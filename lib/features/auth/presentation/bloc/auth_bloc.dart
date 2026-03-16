import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.initial()) {
    on<_AppStarted>((event, emit) async {
      emit(const AuthState.loading());
      // TODO: Check local storage for token and mode
      await Future.delayed(const Duration(seconds: 1)); // Mocking load
      emit(const AuthState.unauthenticated());
    });

    on<_SendOtp>((event, emit) async {
      emit(const AuthState.loading());
      // TODO: Call API to send OTP
      await Future.delayed(const Duration(seconds: 1)); 
      emit(AuthState.otpSent(phone: event.phone));
    });

    on<_VerifyOtp>((event, emit) async {
      emit(const AuthState.loading());
      // TODO: Call API to verify OTP
      await Future.delayed(const Duration(seconds: 1));
      emit(const AuthState.authenticated(token: 'mock_token', userId: '1', currentMode: 'client'));
    });

    on<_LoginWithEmail>((event, emit) async {
      emit(const AuthState.loading());
      // TODO: Call API for Email Auth
      await Future.delayed(const Duration(seconds: 1));
      emit(const AuthState.authenticated(token: 'mock_token', userId: '1', currentMode: 'client'));
    });
    
    on<_SwitchMode>((event, emit) async {
      state.maybeWhen(
        authenticated: (token, userId, currentMode) {
          // TODO: Save new mode to Drift UserPrefs
          emit(AuthState.authenticated(token: token, userId: userId, currentMode: event.mode));
        },
        orElse: () {},
      );
    });

    on<_Logout>((event, emit) async {
      emit(const AuthState.loading());
      // TODO: Clear local storage and Drift DB
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const AuthState.unauthenticated());
    });
  }
}
