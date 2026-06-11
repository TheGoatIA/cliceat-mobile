// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiState {

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiState);
}

@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AiState()';
}

}

/// @nodoc
class $AiStateCopyWith<$Res>  {
$AiStateCopyWith(AiState _, $Res Function(AiState) __);
}

/// Adds pattern-matching-related methods to [AiState].
extension AiStatePatterns on AiState {

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function(_Initial value)? initial,TResult Function(_ConversationList value)? conversationList,TResult Function(_Chat value)? chat,TResult Function(_Error value)? error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _ConversationList() when conversationList != null:
return conversationList(_that);case _Chat() when chat != null:
return chat(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();
}
}

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function(_Initial value) initial,required TResult Function(_ConversationList value) conversationList,required TResult Function(_Chat value) chat,required TResult Function(_Error value) error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _ConversationList():
return conversationList(_that);case _Chat():
return chat(_that);case _Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');
}
}

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function(_Initial value)? initial,TResult? Function(_ConversationList value)? conversationList,TResult? Function(_Chat value)? chat,TResult? Function(_Error value)? error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _ConversationList() when conversationList != null:
return conversationList(_that);case _Chat() when chat != null:
return chat(_that);case _Error() when error != null:
return error(_that);case _:
  return null;
}
}

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function(List<AiConversationModel> conversations)? initial,TResult Function(List<AiConversationModel> conversations)? conversationList,TResult Function(String conversationId, List<AiMessageModel> messages, bool isTyping, bool offlineError, List<AiSuggestionModel> suggestions)? chat,TResult Function(String message)? error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.conversations);case _ConversationList() when conversationList != null:
return conversationList(_that.conversations);case _Chat() when chat != null:
return chat(_that.conversationId,_that.messages,_that.isTyping,_that.offlineError,_that.suggestions);case _Error() when error != null:
return error(_that.message);case _:
  return orElse();
}
}

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function(List<AiConversationModel> conversations) initial,required TResult Function(List<AiConversationModel> conversations) conversationList,required TResult Function(String conversationId, List<AiMessageModel> messages, bool isTyping, bool offlineError, List<AiSuggestionModel> suggestions) chat,required TResult Function(String message) error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial(_that.conversations);case _ConversationList():
return conversationList(_that.conversations);case _Chat():
return chat(_that.conversationId,_that.messages,_that.isTyping,_that.offlineError,_that.suggestions);case _Error():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');
}
}

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function(List<AiConversationModel> conversations)? initial,TResult? Function(List<AiConversationModel> conversations)? conversationList,TResult? Function(String conversationId, List<AiMessageModel> messages, bool isTyping, bool offlineError, List<AiSuggestionModel> suggestions)? chat,TResult? Function(String message)? error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.conversations);case _ConversationList() when conversationList != null:
return conversationList(_that.conversations);case _Chat() when chat != null:
return chat(_that.conversationId,_that.messages,_that.isTyping,_that.offlineError,_that.suggestions);case _Error() when error != null:
return error(_that.message);case _:
  return null;
}
}

}

/// @nodoc

class _Initial implements AiState {
  const _Initial({required final List<AiConversationModel> conversations}): _conversations = conversations;

 final List<AiConversationModel> _conversations;
 List<AiConversationModel> get conversations {
  if (_conversations is EqualUnmodifiableListView) return _conversations;
  return EqualUnmodifiableListView(_conversations);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<_Initial> get copyWith => __$InitialCopyWithImpl<_Initial>(this, _$identity);

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial&&const DeepCollectionEquality().equals(other._conversations, _conversations));
}

@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_conversations));

@override
String toString() {
  return 'AiState.initial(conversations: $conversations)';
}

}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res> implements $AiStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) = __$InitialCopyWithImpl;
@useResult
$Res call({List<AiConversationModel> conversations});
}
/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);
  final _Initial _self;
  final $Res Function(_Initial) _then;
@pragma('vm:prefer-inline') $Res call({Object? conversations = null,}) {
  return _then(_Initial(
conversations: null == conversations ? _self._conversations : conversations as List<AiConversationModel>,
  ));
}
}

/// @nodoc

class _ConversationList implements AiState {
  const _ConversationList({required final List<AiConversationModel> conversations}): _conversations = conversations;

 final List<AiConversationModel> _conversations;
 List<AiConversationModel> get conversations {
  if (_conversations is EqualUnmodifiableListView) return _conversations;
  return EqualUnmodifiableListView(_conversations);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationListCopyWith<_ConversationList> get copyWith => __$ConversationListCopyWithImpl<_ConversationList>(this, _$identity);

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationList&&const DeepCollectionEquality().equals(other._conversations, _conversations));
}

@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_conversations));

@override
String toString() {
  return 'AiState.conversationList(conversations: $conversations)';
}

}

/// @nodoc
abstract mixin class _$ConversationListCopyWith<$Res> implements $AiStateCopyWith<$Res> {
  factory _$ConversationListCopyWith(_ConversationList value, $Res Function(_ConversationList) _then) = __$ConversationListCopyWithImpl;
@useResult
$Res call({List<AiConversationModel> conversations});
}
/// @nodoc
class __$ConversationListCopyWithImpl<$Res> implements _$ConversationListCopyWith<$Res> {
  __$ConversationListCopyWithImpl(this._self, this._then);
  final _ConversationList _self;
  final $Res Function(_ConversationList) _then;
@pragma('vm:prefer-inline') $Res call({Object? conversations = null,}) {
  return _then(_ConversationList(
conversations: null == conversations ? _self._conversations : conversations as List<AiConversationModel>,
  ));
}
}

/// @nodoc

class _Chat implements AiState {
  const _Chat({required this.conversationId, required final List<AiMessageModel> messages, required this.isTyping, this.offlineError = false, final List<AiSuggestionModel> suggestions = const []}): _messages = messages, _suggestions = suggestions;

 final String conversationId;
 final List<AiMessageModel> _messages;
 List<AiMessageModel> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  return EqualUnmodifiableListView(_messages);
}
 final bool isTyping;
 final bool offlineError;
 final List<AiSuggestionModel> _suggestions;
 List<AiSuggestionModel> get suggestions {
  if (_suggestions is EqualUnmodifiableListView) return _suggestions;
  return EqualUnmodifiableListView(_suggestions);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCopyWith<_Chat> get copyWith => __$ChatCopyWithImpl<_Chat>(this, _$identity);

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Chat&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.isTyping, isTyping) || other.isTyping == isTyping)&&(identical(other.offlineError, offlineError) || other.offlineError == offlineError)&&const DeepCollectionEquality().equals(other._suggestions, _suggestions));
}

@override
int get hashCode => Object.hash(runtimeType,conversationId,const DeepCollectionEquality().hash(_messages),isTyping,offlineError,const DeepCollectionEquality().hash(_suggestions));

@override
String toString() {
  return 'AiState.chat(conversationId: $conversationId, messages: $messages, isTyping: $isTyping, offlineError: $offlineError, suggestions: $suggestions)';
}

}

/// @nodoc
abstract mixin class _$ChatCopyWith<$Res> implements $AiStateCopyWith<$Res> {
  factory _$ChatCopyWith(_Chat value, $Res Function(_Chat) _then) = __$ChatCopyWithImpl;
@useResult
$Res call({String conversationId, List<AiMessageModel> messages, bool isTyping, bool offlineError, List<AiSuggestionModel> suggestions});
}
/// @nodoc
class __$ChatCopyWithImpl<$Res> implements _$ChatCopyWith<$Res> {
  __$ChatCopyWithImpl(this._self, this._then);
  final _Chat _self;
  final $Res Function(_Chat) _then;
@pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? messages = null,Object? isTyping = null,Object? offlineError = null,Object? suggestions = null,}) {
  return _then(_Chat(
conversationId: null == conversationId ? _self.conversationId : conversationId as String,messages: null == messages ? _self._messages : messages as List<AiMessageModel>,isTyping: null == isTyping ? _self.isTyping : isTyping as bool,offlineError: null == offlineError ? _self.offlineError : offlineError as bool,suggestions: null == suggestions ? _self._suggestions : suggestions as List<AiSuggestionModel>,
  ));
}
}

/// @nodoc

class _Error implements AiState {
  const _Error(this.message);

 final String message;

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
  return 'AiState.error(message: $message)';
}

}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AiStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({String message});
}
/// @nodoc
class __$ErrorCopyWithImpl<$Res> implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);
  final _Error _self;
  final $Res Function(_Error) _then;
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message as String,
  ));
}
}

// dart format on
