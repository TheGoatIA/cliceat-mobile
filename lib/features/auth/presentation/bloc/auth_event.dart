part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.appStarted() = _AppStarted;
  const factory AuthEvent.sendOtp({required String phone}) = _SendOtp;
  const factory AuthEvent.verifyOtp({required String phone, required String otp}) = _VerifyOtp;
  const factory AuthEvent.loginWithEmail({required String email, required String password}) = _LoginWithEmail;
  const factory AuthEvent.logout() = _Logout;
  const factory AuthEvent.switchMode({required String mode}) = _SwitchMode;
}
