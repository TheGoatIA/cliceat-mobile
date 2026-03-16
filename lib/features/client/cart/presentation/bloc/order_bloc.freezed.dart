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

// ─── OrderEvent ──────────────────────────────────────────────────────────────

mixin _$OrderEvent {}

extension OrderEventPatterns on OrderEvent {
  @optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function(_CreateOrder v)? createOrder,TResult Function(_LoadOrders v)? loadOrders,TResult Function(_CancelOrder v)? cancelOrder,TResult Function(_RateOrder v)? rateOrder,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateOrder() when createOrder != null: return createOrder(_that);
case _LoadOrders() when loadOrders != null: return loadOrders(_that);
case _CancelOrder() when cancelOrder != null: return cancelOrder(_that);
case _RateOrder() when rateOrder != null: return rateOrder(_that);
case _: return orElse();
}
}

  @optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function(_CreateOrder v) createOrder,required TResult Function(_LoadOrders v) loadOrders,required TResult Function(_CancelOrder v) cancelOrder,required TResult Function(_RateOrder v) rateOrder,}){
final _that = this;
switch (_that) {
case _CreateOrder(): return createOrder(_that);
case _LoadOrders(): return loadOrders(_that);
case _CancelOrder(): return cancelOrder(_that);
case _RateOrder(): return rateOrder(_that);
case _: throw StateError('Unexpected subclass');
}
}

  @optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function(_CreateOrder v)? createOrder,TResult? Function(_LoadOrders v)? loadOrders,TResult? Function(_CancelOrder v)? cancelOrder,TResult? Function(_RateOrder v)? rateOrder,}){
final _that = this;
switch (_that) {
case _CreateOrder() when createOrder != null: return createOrder(_that);
case _LoadOrders() when loadOrders != null: return loadOrders(_that);
case _CancelOrder() when cancelOrder != null: return cancelOrder(_that);
case _RateOrder() when rateOrder != null: return rateOrder(_that);
case _: return null;
}
}

  @optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function(Map<String, dynamic> payload)? createOrder,TResult Function()? loadOrders,TResult Function(String orderId)? cancelOrder,TResult Function(String orderId, int rating, String? comment)? rateOrder,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateOrder() when createOrder != null: return createOrder(_that.payload);
case _LoadOrders() when loadOrders != null: return loadOrders();
case _CancelOrder() when cancelOrder != null: return cancelOrder(_that.orderId);
case _RateOrder() when rateOrder != null: return rateOrder(_that.orderId, _that.rating, _that.comment);
case _: return orElse();
}
}

  @optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function(Map<String, dynamic> payload) createOrder,required TResult Function() loadOrders,required TResult Function(String orderId) cancelOrder,required TResult Function(String orderId, int rating, String? comment) rateOrder,}){
final _that = this;
switch (_that) {
case _CreateOrder(): return createOrder(_that.payload);
case _LoadOrders(): return loadOrders();
case _CancelOrder(): return cancelOrder(_that.orderId);
case _RateOrder(): return rateOrder(_that.orderId, _that.rating, _that.comment);
case _: throw StateError('Unexpected subclass');
}
}

  @optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function(Map<String, dynamic> payload)? createOrder,TResult? Function()? loadOrders,TResult? Function(String orderId)? cancelOrder,TResult? Function(String orderId, int rating, String? comment)? rateOrder,}){
final _that = this;
switch (_that) {
case _CreateOrder() when createOrder != null: return createOrder(_that.payload);
case _LoadOrders() when loadOrders != null: return loadOrders();
case _CancelOrder() when cancelOrder != null: return cancelOrder(_that.orderId);
case _RateOrder() when rateOrder != null: return rateOrder(_that.orderId, _that.rating, _that.comment);
case _: return null;
}
}
}

class _CreateOrder implements OrderEvent {
  const _CreateOrder(this.payload);
  final Map<String, dynamic> payload;
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _CreateOrder && other.payload == payload);
  @override int get hashCode => Object.hash(runtimeType, payload);
  @override String toString() => 'OrderEvent.createOrder(payload: $payload)';
}

class _LoadOrders implements OrderEvent {
  const _LoadOrders();
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _LoadOrders);
  @override int get hashCode => runtimeType.hashCode;
  @override String toString() => 'OrderEvent.loadOrders()';
}

class _CancelOrder implements OrderEvent {
  const _CancelOrder(this.orderId);
  final String orderId;
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _CancelOrder && other.orderId == orderId);
  @override int get hashCode => Object.hash(runtimeType, orderId);
  @override String toString() => 'OrderEvent.cancelOrder(orderId: $orderId)';
}

class _RateOrder implements OrderEvent {
  const _RateOrder({required this.orderId, required this.rating, this.comment});
  final String orderId;
  final int rating;
  final String? comment;
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _RateOrder && other.orderId == orderId && other.rating == rating && other.comment == comment);
  @override int get hashCode => Object.hash(runtimeType, orderId, rating, comment);
  @override String toString() => 'OrderEvent.rateOrder(orderId: $orderId, rating: $rating, comment: $comment)';
}

// ─── OrderState ──────────────────────────────────────────────────────────────

mixin _$OrderState {}

extension OrderStatePatterns on OrderState {
  @optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function(_Initial v)? initial,TResult Function(_Loading v)? loading,TResult Function(_Created v)? created,TResult Function(_OrdersLoaded v)? ordersLoaded,TResult Function(_Cancelled v)? cancelled,TResult Function(_Rated v)? rated,TResult Function(_Error v)? error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null: return initial(_that);
case _Loading() when loading != null: return loading(_that);
case _Created() when created != null: return created(_that);
case _OrdersLoaded() when ordersLoaded != null: return ordersLoaded(_that);
case _Cancelled() when cancelled != null: return cancelled(_that);
case _Rated() when rated != null: return rated(_that);
case _Error() when error != null: return error(_that);
case _: return orElse();
}
}

  @optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function(_Initial v) initial,required TResult Function(_Loading v) loading,required TResult Function(_Created v) created,required TResult Function(_OrdersLoaded v) ordersLoaded,required TResult Function(_Cancelled v) cancelled,required TResult Function(_Rated v) rated,required TResult Function(_Error v) error,}){
final _that = this;
switch (_that) {
case _Initial(): return initial(_that);
case _Loading(): return loading(_that);
case _Created(): return created(_that);
case _OrdersLoaded(): return ordersLoaded(_that);
case _Cancelled(): return cancelled(_that);
case _Rated(): return rated(_that);
case _Error(): return error(_that);
case _: throw StateError('Unexpected subclass');
}
}

  @optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function(_Initial v)? initial,TResult? Function(_Loading v)? loading,TResult? Function(_Created v)? created,TResult? Function(_OrdersLoaded v)? ordersLoaded,TResult? Function(_Cancelled v)? cancelled,TResult? Function(_Rated v)? rated,TResult? Function(_Error v)? error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null: return initial(_that);
case _Loading() when loading != null: return loading(_that);
case _Created() when created != null: return created(_that);
case _OrdersLoaded() when ordersLoaded != null: return ordersLoaded(_that);
case _Cancelled() when cancelled != null: return cancelled(_that);
case _Rated() when rated != null: return rated(_that);
case _Error() when error != null: return error(_that);
case _: return null;
}
}

  @optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()? initial,TResult Function()? loading,TResult Function(String orderId, String? paymentUrl)? created,TResult Function(List<Map<String, dynamic>> orders)? ordersLoaded,TResult Function()? cancelled,TResult Function()? rated,TResult Function(String message)? error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null: return initial();
case _Loading() when loading != null: return loading();
case _Created() when created != null: return created(_that.orderId, _that.paymentUrl);
case _OrdersLoaded() when ordersLoaded != null: return ordersLoaded(_that.orders);
case _Cancelled() when cancelled != null: return cancelled();
case _Rated() when rated != null: return rated();
case _Error() when error != null: return error(_that.message);
case _: return orElse();
}
}

  @optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function() initial,required TResult Function() loading,required TResult Function(String orderId, String? paymentUrl) created,required TResult Function(List<Map<String, dynamic>> orders) ordersLoaded,required TResult Function() cancelled,required TResult Function() rated,required TResult Function(String message) error,}){
final _that = this;
switch (_that) {
case _Initial(): return initial();
case _Loading(): return loading();
case _Created(): return created(_that.orderId, _that.paymentUrl);
case _OrdersLoaded(): return ordersLoaded(_that.orders);
case _Cancelled(): return cancelled();
case _Rated(): return rated();
case _Error(): return error(_that.message);
case _: throw StateError('Unexpected subclass');
}
}

  @optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()? initial,TResult? Function()? loading,TResult? Function(String orderId, String? paymentUrl)? created,TResult? Function(List<Map<String, dynamic>> orders)? ordersLoaded,TResult? Function()? cancelled,TResult? Function()? rated,TResult? Function(String message)? error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null: return initial();
case _Loading() when loading != null: return loading();
case _Created() when created != null: return created(_that.orderId, _that.paymentUrl);
case _OrdersLoaded() when ordersLoaded != null: return ordersLoaded(_that.orders);
case _Cancelled() when cancelled != null: return cancelled();
case _Rated() when rated != null: return rated();
case _Error() when error != null: return error(_that.message);
case _: return null;
}
}
}

class _Initial implements OrderState {
  const _Initial();
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _Initial);
  @override int get hashCode => runtimeType.hashCode;
  @override String toString() => 'OrderState.initial()';
}

class _Loading implements OrderState {
  const _Loading();
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _Loading);
  @override int get hashCode => runtimeType.hashCode;
  @override String toString() => 'OrderState.loading()';
}

class _Created implements OrderState {
  const _Created({required this.orderId, this.paymentUrl});
  final String orderId;
  final String? paymentUrl;
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _Created && other.orderId == orderId && other.paymentUrl == paymentUrl);
  @override int get hashCode => Object.hash(runtimeType, orderId, paymentUrl);
  @override String toString() => 'OrderState.created(orderId: $orderId, paymentUrl: $paymentUrl)';
}

class _OrdersLoaded implements OrderState {
  const _OrdersLoaded(this.orders);
  final List<Map<String, dynamic>> orders;
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _OrdersLoaded && other.orders == orders);
  @override int get hashCode => Object.hash(runtimeType, orders);
  @override String toString() => 'OrderState.ordersLoaded(orders: $orders)';
}

class _Cancelled implements OrderState {
  const _Cancelled();
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _Cancelled);
  @override int get hashCode => runtimeType.hashCode;
  @override String toString() => 'OrderState.cancelled()';
}

class _Rated implements OrderState {
  const _Rated();
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _Rated);
  @override int get hashCode => runtimeType.hashCode;
  @override String toString() => 'OrderState.rated()';
}

class _Error implements OrderState {
  const _Error(this.message);
  final String message;
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _Error && other.message == message);
  @override int get hashCode => Object.hash(runtimeType, message);
  @override String toString() => 'OrderState.error(message: $message)';
}

// dart format on
