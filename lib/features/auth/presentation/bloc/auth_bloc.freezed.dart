// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AppStarted value)?  appStarted,TResult Function( _SendOtp value)?  sendOtp,TResult Function( _VerifyOtp value)?  verifyOtp,TResult Function( _LoginWithEmail value)?  loginWithEmail,TResult Function( _LoginWithGoogle value)?  loginWithGoogle,TResult Function( _LoginWithApple value)?  loginWithApple,TResult Function( _Register value)?  register,TResult Function( _ForgotPassword value)?  forgotPassword,TResult Function( _ResetPassword value)?  resetPassword,TResult Function( _VerifyEmail value)?  verifyEmail,TResult Function( _ResendVerificationEmail value)?  resendVerificationEmail,TResult Function( _Logout value)?  logout,TResult Function( _SwitchMode value)?  switchMode,TResult Function( _SessionExpired value)?  sessionExpired,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppStarted() when appStarted != null:
return appStarted(_that);case _SendOtp() when sendOtp != null:
return sendOtp(_that);case _VerifyOtp() when verifyOtp != null:
return verifyOtp(_that);case _LoginWithEmail() when loginWithEmail != null:
return loginWithEmail(_that);case _LoginWithGoogle() when loginWithGoogle != null:
return loginWithGoogle(_that);case _LoginWithApple() when loginWithApple != null:
return loginWithApple(_that);case _Register() when register != null:
return register(_that);case _ForgotPassword() when forgotPassword != null:
return forgotPassword(_that);case _ResetPassword() when resetPassword != null:
return resetPassword(_that);case _VerifyEmail() when verifyEmail != null:
return verifyEmail(_that);case _ResendVerificationEmail() when resendVerificationEmail != null:
return resendVerificationEmail(_that);case _Logout() when logout != null:
return logout(_that);case _SwitchMode() when switchMode != null:
return switchMode(_that);case _SessionExpired() when sessionExpired != null:
return sessionExpired(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AppStarted value)  appStarted,required TResult Function( _SendOtp value)  sendOtp,required TResult Function( _VerifyOtp value)  verifyOtp,required TResult Function( _LoginWithEmail value)  loginWithEmail,required TResult Function( _LoginWithGoogle value)  loginWithGoogle,required TResult Function( _LoginWithApple value)  loginWithApple,required TResult Function( _Register value)  register,required TResult Function( _ForgotPassword value)  forgotPassword,required TResult Function( _ResetPassword value)  resetPassword,required TResult Function( _VerifyEmail value)  verifyEmail,required TResult Function( _ResendVerificationEmail value)  resendVerificationEmail,required TResult Function( _Logout value)  logout,required TResult Function( _SwitchMode value)  switchMode,required TResult Function( _SessionExpired value)  sessionExpired,}){
final _that = this;
switch (_that) {
case _AppStarted():
return appStarted(_that);case _SendOtp():
return sendOtp(_that);case _VerifyOtp():
return verifyOtp(_that);case _LoginWithEmail():
return loginWithEmail(_that);case _LoginWithGoogle():
return loginWithGoogle(_that);case _LoginWithApple():
return loginWithApple(_that);case _Register():
return register(_that);case _ForgotPassword():
return forgotPassword(_that);case _ResetPassword():
return resetPassword(_that);case _VerifyEmail():
return verifyEmail(_that);case _ResendVerificationEmail():
return resendVerificationEmail(_that);case _Logout():
return logout(_that);case _SwitchMode():
return switchMode(_that);case _SessionExpired():
return sessionExpired(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AppStarted value)?  appStarted,TResult? Function( _SendOtp value)?  sendOtp,TResult? Function( _VerifyOtp value)?  verifyOtp,TResult? Function( _LoginWithEmail value)?  loginWithEmail,TResult? Function( _LoginWithGoogle value)?  loginWithGoogle,TResult? Function( _LoginWithApple value)?  loginWithApple,TResult? Function( _Register value)?  register,TResult? Function( _ForgotPassword value)?  forgotPassword,TResult? Function( _ResetPassword value)?  resetPassword,TResult? Function( _VerifyEmail value)?  verifyEmail,TResult? Function( _ResendVerificationEmail value)?  resendVerificationEmail,TResult? Function( _Logout value)?  logout,TResult? Function( _SwitchMode value)?  switchMode,TResult? Function( _SessionExpired value)?  sessionExpired,}){
final _that = this;
switch (_that) {
case _AppStarted() when appStarted != null:
return appStarted(_that);case _SendOtp() when sendOtp != null:
return sendOtp(_that);case _VerifyOtp() when verifyOtp != null:
return verifyOtp(_that);case _LoginWithEmail() when loginWithEmail != null:
return loginWithEmail(_that);case _LoginWithGoogle() when loginWithGoogle != null:
return loginWithGoogle(_that);case _LoginWithApple() when loginWithApple != null:
return loginWithApple(_that);case _Register() when register != null:
return register(_that);case _ForgotPassword() when forgotPassword != null:
return forgotPassword(_that);case _ResetPassword() when resetPassword != null:
return resetPassword(_that);case _VerifyEmail() when verifyEmail != null:
return verifyEmail(_that);case _ResendVerificationEmail() when resendVerificationEmail != null:
return resendVerificationEmail(_that);case _Logout() when logout != null:
return logout(_that);case _SwitchMode() when switchMode != null:
return switchMode(_that);case _SessionExpired() when sessionExpired != null:
return sessionExpired(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  appStarted,TResult Function( String phone)?  sendOtp,TResult Function( String phone,  String otp)?  verifyOtp,TResult Function( String email,  String password)?  loginWithEmail,TResult Function( String token)?  loginWithGoogle,TResult Function( String token)?  loginWithApple,TResult Function( String name,  String email,  String password,  String city)?  register,TResult Function( String email)?  forgotPassword,TResult Function( String token,  String newPassword)?  resetPassword,TResult Function( String token)?  verifyEmail,TResult Function( String email)?  resendVerificationEmail,TResult Function()?  logout,TResult Function( String mode)?  switchMode,TResult Function()?  sessionExpired,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppStarted() when appStarted != null:
return appStarted();case _SendOtp() when sendOtp != null:
return sendOtp(_that.phone);case _VerifyOtp() when verifyOtp != null:
return verifyOtp(_that.phone,_that.otp);case _LoginWithEmail() when loginWithEmail != null:
return loginWithEmail(_that.email,_that.password);case _LoginWithGoogle() when loginWithGoogle != null:
return loginWithGoogle(_that.token);case _LoginWithApple() when loginWithApple != null:
return loginWithApple(_that.token);case _Register() when register != null:
return register(_that.name,_that.email,_that.password,_that.city);case _ForgotPassword() when forgotPassword != null:
return forgotPassword(_that.email);case _ResetPassword() when resetPassword != null:
return resetPassword(_that.token,_that.newPassword);case _VerifyEmail() when verifyEmail != null:
return verifyEmail(_that.token);case _ResendVerificationEmail() when resendVerificationEmail != null:
return resendVerificationEmail(_that.email);case _Logout() when logout != null:
return logout();case _SwitchMode() when switchMode != null:
return switchMode(_that.mode);case _SessionExpired() when sessionExpired != null:
return sessionExpired();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  appStarted,required TResult Function( String phone)  sendOtp,required TResult Function( String phone,  String otp)  verifyOtp,required TResult Function( String email,  String password)  loginWithEmail,required TResult Function( String token)  loginWithGoogle,required TResult Function( String token)  loginWithApple,required TResult Function( String name,  String email,  String password,  String city)  register,required TResult Function( String email)  forgotPassword,required TResult Function( String token,  String newPassword)  resetPassword,required TResult Function( String token)  verifyEmail,required TResult Function( String email)  resendVerificationEmail,required TResult Function()  logout,required TResult Function( String mode)  switchMode,required TResult Function()  sessionExpired,}) {final _that = this;
switch (_that) {
case _AppStarted():
return appStarted();case _SendOtp():
return sendOtp(_that.phone);case _VerifyOtp():
return verifyOtp(_that.phone,_that.otp);case _LoginWithEmail():
return loginWithEmail(_that.email,_that.password);case _LoginWithGoogle():
return loginWithGoogle(_that.token);case _LoginWithApple():
return loginWithApple(_that.token);case _Register():
return register(_that.name,_that.email,_that.password,_that.city);case _ForgotPassword():
return forgotPassword(_that.email);case _ResetPassword():
return resetPassword(_that.token,_that.newPassword);case _VerifyEmail():
return verifyEmail(_that.token);case _ResendVerificationEmail():
return resendVerificationEmail(_that.email);case _Logout():
return logout();case _SwitchMode():
return switchMode(_that.mode);case _SessionExpired():
return sessionExpired();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  appStarted,TResult? Function( String phone)?  sendOtp,TResult? Function( String phone,  String otp)?  verifyOtp,TResult? Function( String email,  String password)?  loginWithEmail,TResult? Function( String token)?  loginWithGoogle,TResult? Function( String token)?  loginWithApple,TResult? Function( String name,  String email,  String password,  String city)?  register,TResult? Function( String email)?  forgotPassword,TResult? Function( String token,  String newPassword)?  resetPassword,TResult? Function( String token)?  verifyEmail,TResult? Function( String email)?  resendVerificationEmail,TResult? Function()?  logout,TResult? Function( String mode)?  switchMode,TResult? Function()?  sessionExpired,}) {final _that = this;
switch (_that) {
case _AppStarted() when appStarted != null:
return appStarted();case _SendOtp() when sendOtp != null:
return sendOtp(_that.phone);case _VerifyOtp() when verifyOtp != null:
return verifyOtp(_that.phone,_that.otp);case _LoginWithEmail() when loginWithEmail != null:
return loginWithEmail(_that.email,_that.password);case _LoginWithGoogle() when loginWithGoogle != null:
return loginWithGoogle(_that.token);case _LoginWithApple() when loginWithApple != null:
return loginWithApple(_that.token);case _Register() when register != null:
return register(_that.name,_that.email,_that.password,_that.city);case _ForgotPassword() when forgotPassword != null:
return forgotPassword(_that.email);case _ResetPassword() when resetPassword != null:
return resetPassword(_that.token,_that.newPassword);case _VerifyEmail() when verifyEmail != null:
return verifyEmail(_that.token);case _ResendVerificationEmail() when resendVerificationEmail != null:
return resendVerificationEmail(_that.email);case _Logout() when logout != null:
return logout();case _SwitchMode() when switchMode != null:
return switchMode(_that.mode);case _SessionExpired() when sessionExpired != null:
return sessionExpired();case _:
  return null;

}
}

}

/// @nodoc


class _AppStarted implements AuthEvent {
  const _AppStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.appStarted()';
}


}




/// @nodoc


class _SendOtp implements AuthEvent {
  const _SendOtp({required this.phone});
  

 final  String phone;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendOtpCopyWith<_SendOtp> get copyWith => __$SendOtpCopyWithImpl<_SendOtp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendOtp&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,phone);

@override
String toString() {
  return 'AuthEvent.sendOtp(phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$SendOtpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$SendOtpCopyWith(_SendOtp value, $Res Function(_SendOtp) _then) = __$SendOtpCopyWithImpl;
@useResult
$Res call({
 String phone
});




}
/// @nodoc
class __$SendOtpCopyWithImpl<$Res>
    implements _$SendOtpCopyWith<$Res> {
  __$SendOtpCopyWithImpl(this._self, this._then);

  final _SendOtp _self;
  final $Res Function(_SendOtp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phone = null,}) {
  return _then(_SendOtp(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _VerifyOtp implements AuthEvent {
  const _VerifyOtp({required this.phone, required this.otp});
  

 final  String phone;
 final  String otp;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyOtpCopyWith<_VerifyOtp> get copyWith => __$VerifyOtpCopyWithImpl<_VerifyOtp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyOtp&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.otp, otp) || other.otp == otp));
}


@override
int get hashCode => Object.hash(runtimeType,phone,otp);

@override
String toString() {
  return 'AuthEvent.verifyOtp(phone: $phone, otp: $otp)';
}


}

/// @nodoc
abstract mixin class _$VerifyOtpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$VerifyOtpCopyWith(_VerifyOtp value, $Res Function(_VerifyOtp) _then) = __$VerifyOtpCopyWithImpl;
@useResult
$Res call({
 String phone, String otp
});




}
/// @nodoc
class __$VerifyOtpCopyWithImpl<$Res>
    implements _$VerifyOtpCopyWith<$Res> {
  __$VerifyOtpCopyWithImpl(this._self, this._then);

  final _VerifyOtp _self;
  final $Res Function(_VerifyOtp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? otp = null,}) {
  return _then(_VerifyOtp(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LoginWithEmail implements AuthEvent {
  const _LoginWithEmail({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginWithEmailCopyWith<_LoginWithEmail> get copyWith => __$LoginWithEmailCopyWithImpl<_LoginWithEmail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginWithEmail&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.loginWithEmail(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$LoginWithEmailCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$LoginWithEmailCopyWith(_LoginWithEmail value, $Res Function(_LoginWithEmail) _then) = __$LoginWithEmailCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class __$LoginWithEmailCopyWithImpl<$Res>
    implements _$LoginWithEmailCopyWith<$Res> {
  __$LoginWithEmailCopyWithImpl(this._self, this._then);

  final _LoginWithEmail _self;
  final $Res Function(_LoginWithEmail) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(_LoginWithEmail(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LoginWithGoogle implements AuthEvent {
  const _LoginWithGoogle({required this.token});
  

 final  String token;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginWithGoogleCopyWith<_LoginWithGoogle> get copyWith => __$LoginWithGoogleCopyWithImpl<_LoginWithGoogle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginWithGoogle&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'AuthEvent.loginWithGoogle(token: $token)';
}


}

/// @nodoc
abstract mixin class _$LoginWithGoogleCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$LoginWithGoogleCopyWith(_LoginWithGoogle value, $Res Function(_LoginWithGoogle) _then) = __$LoginWithGoogleCopyWithImpl;
@useResult
$Res call({
 String token
});




}
/// @nodoc
class __$LoginWithGoogleCopyWithImpl<$Res>
    implements _$LoginWithGoogleCopyWith<$Res> {
  __$LoginWithGoogleCopyWithImpl(this._self, this._then);

  final _LoginWithGoogle _self;
  final $Res Function(_LoginWithGoogle) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? token = null,}) {
  return _then(_LoginWithGoogle(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LoginWithApple implements AuthEvent {
  const _LoginWithApple({required this.token});
  

 final  String token;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginWithAppleCopyWith<_LoginWithApple> get copyWith => __$LoginWithAppleCopyWithImpl<_LoginWithApple>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginWithApple&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'AuthEvent.loginWithApple(token: $token)';
}


}

/// @nodoc
abstract mixin class _$LoginWithAppleCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$LoginWithAppleCopyWith(_LoginWithApple value, $Res Function(_LoginWithApple) _then) = __$LoginWithAppleCopyWithImpl;
@useResult
$Res call({
 String token
});




}
/// @nodoc
class __$LoginWithAppleCopyWithImpl<$Res>
    implements _$LoginWithAppleCopyWith<$Res> {
  __$LoginWithAppleCopyWithImpl(this._self, this._then);

  final _LoginWithApple _self;
  final $Res Function(_LoginWithApple) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? token = null,}) {
  return _then(_LoginWithApple(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Register implements AuthEvent {
  const _Register({required this.name, required this.email, required this.password, required this.city});
  

 final  String name;
 final  String email;
 final  String password;
 final  String city;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterCopyWith<_Register> get copyWith => __$RegisterCopyWithImpl<_Register>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Register&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.city, city) || other.city == city));
}


@override
int get hashCode => Object.hash(runtimeType,name,email,password,city);

@override
String toString() {
  return 'AuthEvent.register(name: $name, email: $email, password: $password, city: $city)';
}


}

/// @nodoc
abstract mixin class _$RegisterCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$RegisterCopyWith(_Register value, $Res Function(_Register) _then) = __$RegisterCopyWithImpl;
@useResult
$Res call({
 String name, String email, String password, String city
});




}
/// @nodoc
class __$RegisterCopyWithImpl<$Res>
    implements _$RegisterCopyWith<$Res> {
  __$RegisterCopyWithImpl(this._self, this._then);

  final _Register _self;
  final $Res Function(_Register) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? password = null,Object? city = null,}) {
  return _then(_Register(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ForgotPassword implements AuthEvent {
  const _ForgotPassword({required this.email});
  

 final  String email;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForgotPasswordCopyWith<_ForgotPassword> get copyWith => __$ForgotPasswordCopyWithImpl<_ForgotPassword>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForgotPassword&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthEvent.forgotPassword(email: $email)';
}


}

/// @nodoc
abstract mixin class _$ForgotPasswordCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$ForgotPasswordCopyWith(_ForgotPassword value, $Res Function(_ForgotPassword) _then) = __$ForgotPasswordCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class __$ForgotPasswordCopyWithImpl<$Res>
    implements _$ForgotPasswordCopyWith<$Res> {
  __$ForgotPasswordCopyWithImpl(this._self, this._then);

  final _ForgotPassword _self;
  final $Res Function(_ForgotPassword) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(_ForgotPassword(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ResetPassword implements AuthEvent {
  const _ResetPassword({required this.token, required this.newPassword});
  

 final  String token;
 final  String newPassword;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResetPasswordCopyWith<_ResetPassword> get copyWith => __$ResetPasswordCopyWithImpl<_ResetPassword>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetPassword&&(identical(other.token, token) || other.token == token)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword));
}


@override
int get hashCode => Object.hash(runtimeType,token,newPassword);

@override
String toString() {
  return 'AuthEvent.resetPassword(token: $token, newPassword: $newPassword)';
}


}

/// @nodoc
abstract mixin class _$ResetPasswordCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$ResetPasswordCopyWith(_ResetPassword value, $Res Function(_ResetPassword) _then) = __$ResetPasswordCopyWithImpl;
@useResult
$Res call({
 String token, String newPassword
});




}
/// @nodoc
class __$ResetPasswordCopyWithImpl<$Res>
    implements _$ResetPasswordCopyWith<$Res> {
  __$ResetPasswordCopyWithImpl(this._self, this._then);

  final _ResetPassword _self;
  final $Res Function(_ResetPassword) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? token = null,Object? newPassword = null,}) {
  return _then(_ResetPassword(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _VerifyEmail implements AuthEvent {
  const _VerifyEmail({required this.token});
  

 final  String token;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyEmailCopyWith<_VerifyEmail> get copyWith => __$VerifyEmailCopyWithImpl<_VerifyEmail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyEmail&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'AuthEvent.verifyEmail(token: $token)';
}


}

/// @nodoc
abstract mixin class _$VerifyEmailCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$VerifyEmailCopyWith(_VerifyEmail value, $Res Function(_VerifyEmail) _then) = __$VerifyEmailCopyWithImpl;
@useResult
$Res call({
 String token
});




}
/// @nodoc
class __$VerifyEmailCopyWithImpl<$Res>
    implements _$VerifyEmailCopyWith<$Res> {
  __$VerifyEmailCopyWithImpl(this._self, this._then);

  final _VerifyEmail _self;
  final $Res Function(_VerifyEmail) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? token = null,}) {
  return _then(_VerifyEmail(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ResendVerificationEmail implements AuthEvent {
  const _ResendVerificationEmail({required this.email});
  

 final  String email;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResendVerificationEmailCopyWith<_ResendVerificationEmail> get copyWith => __$ResendVerificationEmailCopyWithImpl<_ResendVerificationEmail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResendVerificationEmail&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthEvent.resendVerificationEmail(email: $email)';
}


}

/// @nodoc
abstract mixin class _$ResendVerificationEmailCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$ResendVerificationEmailCopyWith(_ResendVerificationEmail value, $Res Function(_ResendVerificationEmail) _then) = __$ResendVerificationEmailCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class __$ResendVerificationEmailCopyWithImpl<$Res>
    implements _$ResendVerificationEmailCopyWith<$Res> {
  __$ResendVerificationEmailCopyWithImpl(this._self, this._then);

  final _ResendVerificationEmail _self;
  final $Res Function(_ResendVerificationEmail) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(_ResendVerificationEmail(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Logout implements AuthEvent {
  const _Logout();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Logout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.logout()';
}


}




/// @nodoc


class _SwitchMode implements AuthEvent {
  const _SwitchMode({required this.mode});
  

 final  String mode;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwitchModeCopyWith<_SwitchMode> get copyWith => __$SwitchModeCopyWithImpl<_SwitchMode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwitchMode&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'AuthEvent.switchMode(mode: $mode)';
}


}

/// @nodoc
abstract mixin class _$SwitchModeCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$SwitchModeCopyWith(_SwitchMode value, $Res Function(_SwitchMode) _then) = __$SwitchModeCopyWithImpl;
@useResult
$Res call({
 String mode
});




}
/// @nodoc
class __$SwitchModeCopyWithImpl<$Res>
    implements _$SwitchModeCopyWith<$Res> {
  __$SwitchModeCopyWithImpl(this._self, this._then);

  final _SwitchMode _self;
  final $Res Function(_SwitchMode) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(_SwitchMode(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SessionExpired implements AuthEvent {
  const _SessionExpired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.sessionExpired()';
}


}




/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Unauthenticated value)?  unauthenticated,TResult Function( _OtpSent value)?  otpSent,TResult Function( _Authenticated value)?  authenticated,TResult Function( _EmailVerificationRequired value)?  emailVerificationRequired,TResult Function( _EmailVerified value)?  emailVerified,TResult Function( _ForgotPasswordEmailSent value)?  forgotPasswordEmailSent,TResult Function( _ResetPasswordSuccess value)?  resetPasswordSuccess,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _OtpSent() when otpSent != null:
return otpSent(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _EmailVerificationRequired() when emailVerificationRequired != null:
return emailVerificationRequired(_that);case _EmailVerified() when emailVerified != null:
return emailVerified(_that);case _ForgotPasswordEmailSent() when forgotPasswordEmailSent != null:
return forgotPasswordEmailSent(_that);case _ResetPasswordSuccess() when resetPasswordSuccess != null:
return resetPasswordSuccess(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Unauthenticated value)  unauthenticated,required TResult Function( _OtpSent value)  otpSent,required TResult Function( _Authenticated value)  authenticated,required TResult Function( _EmailVerificationRequired value)  emailVerificationRequired,required TResult Function( _EmailVerified value)  emailVerified,required TResult Function( _ForgotPasswordEmailSent value)  forgotPasswordEmailSent,required TResult Function( _ResetPasswordSuccess value)  resetPasswordSuccess,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Unauthenticated():
return unauthenticated(_that);case _OtpSent():
return otpSent(_that);case _Authenticated():
return authenticated(_that);case _EmailVerificationRequired():
return emailVerificationRequired(_that);case _EmailVerified():
return emailVerified(_that);case _ForgotPasswordEmailSent():
return forgotPasswordEmailSent(_that);case _ResetPasswordSuccess():
return resetPasswordSuccess(_that);case _Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Unauthenticated value)?  unauthenticated,TResult? Function( _OtpSent value)?  otpSent,TResult? Function( _Authenticated value)?  authenticated,TResult? Function( _EmailVerificationRequired value)?  emailVerificationRequired,TResult? Function( _EmailVerified value)?  emailVerified,TResult? Function( _ForgotPasswordEmailSent value)?  forgotPasswordEmailSent,TResult? Function( _ResetPasswordSuccess value)?  resetPasswordSuccess,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _OtpSent() when otpSent != null:
return otpSent(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _EmailVerificationRequired() when emailVerificationRequired != null:
return emailVerificationRequired(_that);case _EmailVerified() when emailVerified != null:
return emailVerified(_that);case _ForgotPasswordEmailSent() when forgotPasswordEmailSent != null:
return forgotPasswordEmailSent(_that);case _ResetPasswordSuccess() when resetPasswordSuccess != null:
return resetPasswordSuccess(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  unauthenticated,TResult Function( String phone)?  otpSent,TResult Function( String token,  String userId,  String currentMode)?  authenticated,TResult Function( String email)?  emailVerificationRequired,TResult Function()?  emailVerified,TResult Function( String email)?  forgotPasswordEmailSent,TResult Function()?  resetPasswordSuccess,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Unauthenticated() when unauthenticated != null:
return unauthenticated();case _OtpSent() when otpSent != null:
return otpSent(_that.phone);case _Authenticated() when authenticated != null:
return authenticated(_that.token,_that.userId,_that.currentMode);case _EmailVerificationRequired() when emailVerificationRequired != null:
return emailVerificationRequired(_that.email);case _EmailVerified() when emailVerified != null:
return emailVerified();case _ForgotPasswordEmailSent() when forgotPasswordEmailSent != null:
return forgotPasswordEmailSent(_that.email);case _ResetPasswordSuccess() when resetPasswordSuccess != null:
return resetPasswordSuccess();case _Error() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  unauthenticated,required TResult Function( String phone)  otpSent,required TResult Function( String token,  String userId,  String currentMode)  authenticated,required TResult Function( String email)  emailVerificationRequired,required TResult Function()  emailVerified,required TResult Function( String email)  forgotPasswordEmailSent,required TResult Function()  resetPasswordSuccess,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Unauthenticated():
return unauthenticated();case _OtpSent():
return otpSent(_that.phone);case _Authenticated():
return authenticated(_that.token,_that.userId,_that.currentMode);case _EmailVerificationRequired():
return emailVerificationRequired(_that.email);case _EmailVerified():
return emailVerified();case _ForgotPasswordEmailSent():
return forgotPasswordEmailSent(_that.email);case _ResetPasswordSuccess():
return resetPasswordSuccess();case _Error():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  unauthenticated,TResult? Function( String phone)?  otpSent,TResult? Function( String token,  String userId,  String currentMode)?  authenticated,TResult? Function( String email)?  emailVerificationRequired,TResult? Function()?  emailVerified,TResult? Function( String email)?  forgotPasswordEmailSent,TResult? Function()?  resetPasswordSuccess,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Unauthenticated() when unauthenticated != null:
return unauthenticated();case _OtpSent() when otpSent != null:
return otpSent(_that.phone);case _Authenticated() when authenticated != null:
return authenticated(_that.token,_that.userId,_that.currentMode);case _EmailVerificationRequired() when emailVerificationRequired != null:
return emailVerificationRequired(_that.email);case _EmailVerified() when emailVerified != null:
return emailVerified();case _ForgotPasswordEmailSent() when forgotPasswordEmailSent != null:
return forgotPasswordEmailSent(_that.email);case _ResetPasswordSuccess() when resetPasswordSuccess != null:
return resetPasswordSuccess();case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AuthState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.initial()';
}


}




/// @nodoc


class _Loading implements AuthState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




/// @nodoc


class _Unauthenticated implements AuthState {
  const _Unauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unauthenticated()';
}


}




/// @nodoc


class _OtpSent implements AuthState {
  const _OtpSent({required this.phone});
  

 final  String phone;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpSentCopyWith<_OtpSent> get copyWith => __$OtpSentCopyWithImpl<_OtpSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpSent&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,phone);

@override
String toString() {
  return 'AuthState.otpSent(phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$OtpSentCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$OtpSentCopyWith(_OtpSent value, $Res Function(_OtpSent) _then) = __$OtpSentCopyWithImpl;
@useResult
$Res call({
 String phone
});




}
/// @nodoc
class __$OtpSentCopyWithImpl<$Res>
    implements _$OtpSentCopyWith<$Res> {
  __$OtpSentCopyWithImpl(this._self, this._then);

  final _OtpSent _self;
  final $Res Function(_OtpSent) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phone = null,}) {
  return _then(_OtpSent(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Authenticated implements AuthState {
  const _Authenticated({required this.token, required this.userId, required this.currentMode});
  

 final  String token;
 final  String userId;
 final  String currentMode;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticatedCopyWith<_Authenticated> get copyWith => __$AuthenticatedCopyWithImpl<_Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authenticated&&(identical(other.token, token) || other.token == token)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.currentMode, currentMode) || other.currentMode == currentMode));
}


@override
int get hashCode => Object.hash(runtimeType,token,userId,currentMode);

@override
String toString() {
  return 'AuthState.authenticated(token: $token, userId: $userId, currentMode: $currentMode)';
}


}

/// @nodoc
abstract mixin class _$AuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthenticatedCopyWith(_Authenticated value, $Res Function(_Authenticated) _then) = __$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 String token, String userId, String currentMode
});




}
/// @nodoc
class __$AuthenticatedCopyWithImpl<$Res>
    implements _$AuthenticatedCopyWith<$Res> {
  __$AuthenticatedCopyWithImpl(this._self, this._then);

  final _Authenticated _self;
  final $Res Function(_Authenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? token = null,Object? userId = null,Object? currentMode = null,}) {
  return _then(_Authenticated(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,currentMode: null == currentMode ? _self.currentMode : currentMode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _EmailVerificationRequired implements AuthState {
  const _EmailVerificationRequired({required this.email});
  

 final  String email;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmailVerificationRequiredCopyWith<_EmailVerificationRequired> get copyWith => __$EmailVerificationRequiredCopyWithImpl<_EmailVerificationRequired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailVerificationRequired&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthState.emailVerificationRequired(email: $email)';
}


}

/// @nodoc
abstract mixin class _$EmailVerificationRequiredCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$EmailVerificationRequiredCopyWith(_EmailVerificationRequired value, $Res Function(_EmailVerificationRequired) _then) = __$EmailVerificationRequiredCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class __$EmailVerificationRequiredCopyWithImpl<$Res>
    implements _$EmailVerificationRequiredCopyWith<$Res> {
  __$EmailVerificationRequiredCopyWithImpl(this._self, this._then);

  final _EmailVerificationRequired _self;
  final $Res Function(_EmailVerificationRequired) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(_EmailVerificationRequired(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _EmailVerified implements AuthState {
  const _EmailVerified();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailVerified);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.emailVerified()';
}


}




/// @nodoc


class _ForgotPasswordEmailSent implements AuthState {
  const _ForgotPasswordEmailSent({required this.email});
  

 final  String email;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForgotPasswordEmailSentCopyWith<_ForgotPasswordEmailSent> get copyWith => __$ForgotPasswordEmailSentCopyWithImpl<_ForgotPasswordEmailSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForgotPasswordEmailSent&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthState.forgotPasswordEmailSent(email: $email)';
}


}

/// @nodoc
abstract mixin class _$ForgotPasswordEmailSentCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$ForgotPasswordEmailSentCopyWith(_ForgotPasswordEmailSent value, $Res Function(_ForgotPasswordEmailSent) _then) = __$ForgotPasswordEmailSentCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class __$ForgotPasswordEmailSentCopyWithImpl<$Res>
    implements _$ForgotPasswordEmailSentCopyWith<$Res> {
  __$ForgotPasswordEmailSentCopyWithImpl(this._self, this._then);

  final _ForgotPasswordEmailSent _self;
  final $Res Function(_ForgotPasswordEmailSent) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(_ForgotPasswordEmailSent(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ResetPasswordSuccess implements AuthState {
  const _ResetPasswordSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetPasswordSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.resetPasswordSuccess()';
}


}




/// @nodoc


class _Error implements AuthState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
