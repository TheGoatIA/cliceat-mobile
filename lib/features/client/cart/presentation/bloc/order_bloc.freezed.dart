// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState()';
}


}

/// @nodoc
class $OrderStateCopyWith<$Res>  {
$OrderStateCopyWith(OrderState _, $Res Function(OrderState) __);
}


/// Adds pattern-matching-related methods to [OrderState].
extension OrderStatePatterns on OrderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Created value)?  created,TResult Function( _OrdersLoaded value)?  ordersLoaded,TResult Function( _LoadingMore value)?  loadingMore,TResult Function( _Cancelled value)?  cancelled,TResult Function( _Rated value)?  rated,TResult Function( _ReorderSuccess value)?  reorderSuccess,TResult Function( _InvoiceDownloaded value)?  invoiceDownloaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Created() when created != null:
return created(_that);case _OrdersLoaded() when ordersLoaded != null:
return ordersLoaded(_that);case _LoadingMore() when loadingMore != null:
return loadingMore(_that);case _Cancelled() when cancelled != null:
return cancelled(_that);case _Rated() when rated != null:
return rated(_that);case _ReorderSuccess() when reorderSuccess != null:
return reorderSuccess(_that);case _InvoiceDownloaded() when invoiceDownloaded != null:
return invoiceDownloaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Created value)  created,required TResult Function( _OrdersLoaded value)  ordersLoaded,required TResult Function( _LoadingMore value)  loadingMore,required TResult Function( _Cancelled value)  cancelled,required TResult Function( _Rated value)  rated,required TResult Function( _ReorderSuccess value)  reorderSuccess,required TResult Function( _InvoiceDownloaded value)  invoiceDownloaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Created():
return created(_that);case _OrdersLoaded():
return ordersLoaded(_that);case _LoadingMore():
return loadingMore(_that);case _Cancelled():
return cancelled(_that);case _Rated():
return rated(_that);case _ReorderSuccess():
return reorderSuccess(_that);case _InvoiceDownloaded():
return invoiceDownloaded(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Created value)?  created,TResult? Function( _OrdersLoaded value)?  ordersLoaded,TResult? Function( _LoadingMore value)?  loadingMore,TResult? Function( _Cancelled value)?  cancelled,TResult? Function( _Rated value)?  rated,TResult? Function( _ReorderSuccess value)?  reorderSuccess,TResult? Function( _InvoiceDownloaded value)?  invoiceDownloaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Created() when created != null:
return created(_that);case _OrdersLoaded() when ordersLoaded != null:
return ordersLoaded(_that);case _LoadingMore() when loadingMore != null:
return loadingMore(_that);case _Cancelled() when cancelled != null:
return cancelled(_that);case _Rated() when rated != null:
return rated(_that);case _ReorderSuccess() when reorderSuccess != null:
return reorderSuccess(_that);case _InvoiceDownloaded() when invoiceDownloaded != null:
return invoiceDownloaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String orderId,  String? paymentUrl)?  created,TResult Function( List<Map<String, dynamic>> orders)?  ordersLoaded,TResult Function( List<Map<String, dynamic>> orders)?  loadingMore,TResult Function()?  cancelled,TResult Function()?  rated,TResult Function( String newOrderId,  String? paymentUrl)?  reorderSuccess,TResult Function( String filePath)?  invoiceDownloaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Created() when created != null:
return created(_that.orderId,_that.paymentUrl);case _OrdersLoaded() when ordersLoaded != null:
return ordersLoaded(_that.orders);case _LoadingMore() when loadingMore != null:
return loadingMore(_that.orders);case _Cancelled() when cancelled != null:
return cancelled();case _Rated() when rated != null:
return rated();case _ReorderSuccess() when reorderSuccess != null:
return reorderSuccess(_that.newOrderId,_that.paymentUrl);case _InvoiceDownloaded() when invoiceDownloaded != null:
return invoiceDownloaded(_that.filePath);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String orderId,  String? paymentUrl)  created,required TResult Function( List<Map<String, dynamic>> orders)  ordersLoaded,required TResult Function( List<Map<String, dynamic>> orders)  loadingMore,required TResult Function()  cancelled,required TResult Function()  rated,required TResult Function( String newOrderId,  String? paymentUrl)  reorderSuccess,required TResult Function( String filePath)  invoiceDownloaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Created():
return created(_that.orderId,_that.paymentUrl);case _OrdersLoaded():
return ordersLoaded(_that.orders);case _LoadingMore():
return loadingMore(_that.orders);case _Cancelled():
return cancelled();case _Rated():
return rated();case _ReorderSuccess():
return reorderSuccess(_that.newOrderId,_that.paymentUrl);case _InvoiceDownloaded():
return invoiceDownloaded(_that.filePath);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String orderId,  String? paymentUrl)?  created,TResult? Function( List<Map<String, dynamic>> orders)?  ordersLoaded,TResult? Function( List<Map<String, dynamic>> orders)?  loadingMore,TResult? Function()?  cancelled,TResult? Function()?  rated,TResult? Function( String newOrderId,  String? paymentUrl)?  reorderSuccess,TResult? Function( String filePath)?  invoiceDownloaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Created() when created != null:
return created(_that.orderId,_that.paymentUrl);case _OrdersLoaded() when ordersLoaded != null:
return ordersLoaded(_that.orders);case _LoadingMore() when loadingMore != null:
return loadingMore(_that.orders);case _Cancelled() when cancelled != null:
return cancelled();case _Rated() when rated != null:
return rated();case _ReorderSuccess() when reorderSuccess != null:
return reorderSuccess(_that.newOrderId,_that.paymentUrl);case _InvoiceDownloaded() when invoiceDownloaded != null:
return invoiceDownloaded(_that.filePath);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements OrderState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState.initial()';
}


}




/// @nodoc


class _Loading implements OrderState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState.loading()';
}


}




/// @nodoc


class _Created implements OrderState {
  const _Created({required this.orderId, this.paymentUrl});
  

 final  String orderId;
 final  String? paymentUrl;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedCopyWith<_Created> get copyWith => __$CreatedCopyWithImpl<_Created>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Created&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,paymentUrl);

@override
String toString() {
  return 'OrderState.created(orderId: $orderId, paymentUrl: $paymentUrl)';
}


}

/// @nodoc
abstract mixin class _$CreatedCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory _$CreatedCopyWith(_Created value, $Res Function(_Created) _then) = __$CreatedCopyWithImpl;
@useResult
$Res call({
 String orderId, String? paymentUrl
});




}
/// @nodoc
class __$CreatedCopyWithImpl<$Res>
    implements _$CreatedCopyWith<$Res> {
  __$CreatedCopyWithImpl(this._self, this._then);

  final _Created _self;
  final $Res Function(_Created) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? paymentUrl = freezed,}) {
  return _then(_Created(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,paymentUrl: freezed == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _OrdersLoaded implements OrderState {
  const _OrdersLoaded(final  List<Map<String, dynamic>> orders): _orders = orders;
  

 final  List<Map<String, dynamic>> _orders;
 List<Map<String, dynamic>> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}


/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrdersLoadedCopyWith<_OrdersLoaded> get copyWith => __$OrdersLoadedCopyWithImpl<_OrdersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrdersLoaded&&const DeepCollectionEquality().equals(other._orders, _orders));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_orders));

@override
String toString() {
  return 'OrderState.ordersLoaded(orders: $orders)';
}


}

/// @nodoc
abstract mixin class _$OrdersLoadedCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory _$OrdersLoadedCopyWith(_OrdersLoaded value, $Res Function(_OrdersLoaded) _then) = __$OrdersLoadedCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> orders
});




}
/// @nodoc
class __$OrdersLoadedCopyWithImpl<$Res>
    implements _$OrdersLoadedCopyWith<$Res> {
  __$OrdersLoadedCopyWithImpl(this._self, this._then);

  final _OrdersLoaded _self;
  final $Res Function(_OrdersLoaded) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orders = null,}) {
  return _then(_OrdersLoaded(
null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}


}

/// @nodoc


class _LoadingMore implements OrderState {
  const _LoadingMore(final  List<Map<String, dynamic>> orders): _orders = orders;
  

 final  List<Map<String, dynamic>> _orders;
 List<Map<String, dynamic>> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}


/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingMoreCopyWith<_LoadingMore> get copyWith => __$LoadingMoreCopyWithImpl<_LoadingMore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadingMore&&const DeepCollectionEquality().equals(other._orders, _orders));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_orders));

@override
String toString() {
  return 'OrderState.loadingMore(orders: $orders)';
}


}

/// @nodoc
abstract mixin class _$LoadingMoreCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory _$LoadingMoreCopyWith(_LoadingMore value, $Res Function(_LoadingMore) _then) = __$LoadingMoreCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> orders
});




}
/// @nodoc
class __$LoadingMoreCopyWithImpl<$Res>
    implements _$LoadingMoreCopyWith<$Res> {
  __$LoadingMoreCopyWithImpl(this._self, this._then);

  final _LoadingMore _self;
  final $Res Function(_LoadingMore) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orders = null,}) {
  return _then(_LoadingMore(
null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}


}

/// @nodoc


class _Cancelled implements OrderState {
  const _Cancelled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState.cancelled()';
}


}




/// @nodoc


class _Rated implements OrderState {
  const _Rated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Rated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState.rated()';
}


}




/// @nodoc


class _ReorderSuccess implements OrderState {
  const _ReorderSuccess(this.newOrderId, {this.paymentUrl});
  

 final  String newOrderId;
 final  String? paymentUrl;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReorderSuccessCopyWith<_ReorderSuccess> get copyWith => __$ReorderSuccessCopyWithImpl<_ReorderSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReorderSuccess&&(identical(other.newOrderId, newOrderId) || other.newOrderId == newOrderId)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl));
}


@override
int get hashCode => Object.hash(runtimeType,newOrderId,paymentUrl);

@override
String toString() {
  return 'OrderState.reorderSuccess(newOrderId: $newOrderId, paymentUrl: $paymentUrl)';
}


}

/// @nodoc
abstract mixin class _$ReorderSuccessCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory _$ReorderSuccessCopyWith(_ReorderSuccess value, $Res Function(_ReorderSuccess) _then) = __$ReorderSuccessCopyWithImpl;
@useResult
$Res call({
 String newOrderId, String? paymentUrl
});




}
/// @nodoc
class __$ReorderSuccessCopyWithImpl<$Res>
    implements _$ReorderSuccessCopyWith<$Res> {
  __$ReorderSuccessCopyWithImpl(this._self, this._then);

  final _ReorderSuccess _self;
  final $Res Function(_ReorderSuccess) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? newOrderId = null,Object? paymentUrl = freezed,}) {
  return _then(_ReorderSuccess(
null == newOrderId ? _self.newOrderId : newOrderId // ignore: cast_nullable_to_non_nullable
as String,paymentUrl: freezed == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _InvoiceDownloaded implements OrderState {
  const _InvoiceDownloaded(this.filePath);
  

 final  String filePath;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceDownloadedCopyWith<_InvoiceDownloaded> get copyWith => __$InvoiceDownloadedCopyWithImpl<_InvoiceDownloaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceDownloaded&&(identical(other.filePath, filePath) || other.filePath == filePath));
}


@override
int get hashCode => Object.hash(runtimeType,filePath);

@override
String toString() {
  return 'OrderState.invoiceDownloaded(filePath: $filePath)';
}


}

/// @nodoc
abstract mixin class _$InvoiceDownloadedCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory _$InvoiceDownloadedCopyWith(_InvoiceDownloaded value, $Res Function(_InvoiceDownloaded) _then) = __$InvoiceDownloadedCopyWithImpl;
@useResult
$Res call({
 String filePath
});




}
/// @nodoc
class __$InvoiceDownloadedCopyWithImpl<$Res>
    implements _$InvoiceDownloadedCopyWith<$Res> {
  __$InvoiceDownloadedCopyWithImpl(this._self, this._then);

  final _InvoiceDownloaded _self;
  final $Res Function(_InvoiceDownloaded) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filePath = null,}) {
  return _then(_InvoiceDownloaded(
null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements OrderState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of OrderState
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
  return 'OrderState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
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

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
