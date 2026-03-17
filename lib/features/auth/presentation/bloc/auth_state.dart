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
  const factory AuthState.emailVerificationRequired({required String email}) = _EmailVerificationRequired;
  const factory AuthState.emailVerified() = _EmailVerified;
  const factory AuthState.forgotPasswordEmailSent({required String email}) = _ForgotPasswordEmailSent;
  const factory AuthState.resetPasswordSuccess() = _ResetPasswordSuccess;
  const factory AuthState.error({required String message}) = _Error;
}
