part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.appStarted() = _AppStarted;
  const factory AuthEvent.sendOtp({required String phone}) = _SendOtp;
  const factory AuthEvent.verifyOtp({required String phone, required String otp}) = _VerifyOtp;
  const factory AuthEvent.loginWithEmail({required String email, required String password}) = _LoginWithEmail;
  /// Login dédié livreur → POST /auth/delivery/login { phone, password }
  const factory AuthEvent.loginDelivery({required String phone, required String password}) = _LoginDelivery;
  const factory AuthEvent.loginWithGoogle({required String token}) = _LoginWithGoogle;
  const factory AuthEvent.loginWithApple({required String token}) = _LoginWithApple;
  const factory AuthEvent.register({
    required String name,
    required String email,
    required String password,
    required String city,
  }) = _Register;
  const factory AuthEvent.forgotPassword({required String email}) = _ForgotPassword;
  const factory AuthEvent.resetPassword({required String token, required String newPassword}) = _ResetPassword;
  const factory AuthEvent.verifyEmail({required String token}) = _VerifyEmail;
  const factory AuthEvent.resendVerificationEmail({required String email}) = _ResendVerificationEmail;
  const factory AuthEvent.logout() = _Logout;
  const factory AuthEvent.switchMode({required String mode}) = _SwitchMode;
  /// Émis par le timer interne quand le JWT a expiré.
  const factory AuthEvent.sessionExpired() = _SessionExpired;
}

