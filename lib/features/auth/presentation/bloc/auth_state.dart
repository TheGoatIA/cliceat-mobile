part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.otpSent({required String phone}) = _OtpSent;
  const factory AuthState.authenticated({
    required String token,
    required String userId,
    required String currentMode, // 'client' or 'delivery'
  }) = _Authenticated;
  const factory AuthState.error({required String message}) = _Error;
}
