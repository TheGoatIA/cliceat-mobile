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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Loading value)?  loading,TResult Function( _Chat value)?  chat,TResult Function( _Error value)?  error,TResult Function( _PhotoOrderResult value)?  photoOrderResult,TResult Function( _QualityResult value)?  qualityResult,TResult Function( _GastroChat value)?  gastroChat,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _Chat() when chat != null:
return chat(_that);case _Error() when error != null:
return error(_that);case _PhotoOrderResult() when photoOrderResult != null:
return photoOrderResult(_that);case _QualityResult() when qualityResult != null:
return qualityResult(_that);case _GastroChat() when gastroChat != null:
return gastroChat(_that);case _:
  return orElse();

}
}

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Loading value)  loading,required TResult Function( _Chat value)  chat,required TResult Function( _Error value)  error,required TResult Function( _PhotoOrderResult value)  photoOrderResult,required TResult Function( _QualityResult value)  qualityResult,required TResult Function( _GastroChat value)  gastroChat,}){
final _that = this;
switch (_that) {
case _Loading():
return loading(_that);case _Chat():
return chat(_that);case _Error():
return error(_that);case _PhotoOrderResult():
return photoOrderResult(_that);case _QualityResult():
return qualityResult(_that);case _GastroChat():
return gastroChat(_that);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Loading value)?  loading,TResult? Function( _Chat value)?  chat,TResult? Function( _Error value)?  error,TResult? Function( _PhotoOrderResult value)?  photoOrderResult,TResult? Function( _QualityResult value)?  qualityResult,TResult? Function( _GastroChat value)?  gastroChat,}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _Chat() when chat != null:
return chat(_that);case _Error() when error != null:
return error(_that);case _PhotoOrderResult() when photoOrderResult != null:
return photoOrderResult(_that);case _QualityResult() when qualityResult != null:
return qualityResult(_that);case _GastroChat() when gastroChat != null:
return gastroChat(_that);case _:
  return null;

}
}

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( String conversationId,  List<AiMessageModel> messages,  bool isTyping,  bool offlineError,  List<AiSuggestionModel> suggestions)?  chat,TResult Function( String message)?  error,TResult Function( List<Map<String, dynamic>> items,  String message)?  photoOrderResult,TResult Function( Map<String, dynamic> scores,  int overall,  String feedback,  String recommendation)?  qualityResult,TResult Function( List<Map<String, dynamic>> history,  bool isTyping)?  gastroChat,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _Chat() when chat != null:
return chat(_that.conversationId,_that.messages,_that.isTyping,_that.offlineError,_that.suggestions);case _Error() when error != null:
return error(_that.message);case _PhotoOrderResult() when photoOrderResult != null:
return photoOrderResult(_that.items,_that.message);case _QualityResult() when qualityResult != null:
return qualityResult(_that.scores,_that.overall,_that.feedback,_that.recommendation);case _GastroChat() when gastroChat != null:
return gastroChat(_that.history,_that.isTyping);case _:
  return orElse();

}
}

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( String conversationId,  List<AiMessageModel> messages,  bool isTyping,  bool offlineError,  List<AiSuggestionModel> suggestions)  chat,required TResult Function( String message)  error,required TResult Function( List<Map<String, dynamic>> items,  String message)  photoOrderResult,required TResult Function( Map<String, dynamic> scores,  int overall,  String feedback,  String recommendation)  qualityResult,required TResult Function( List<Map<String, dynamic>> history,  bool isTyping)  gastroChat,}) {final _that = this;
switch (_that) {
case _Loading():
return loading();case _Chat():
return chat(_that.conversationId,_that.messages,_that.isTyping,_that.offlineError,_that.suggestions);case _Error():
return error(_that.message);case _PhotoOrderResult():
return photoOrderResult(_that.items,_that.message);case _QualityResult():
return qualityResult(_that.scores,_that.overall,_that.feedback,_that.recommendation);case _GastroChat():
return gastroChat(_that.history,_that.isTyping);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( String conversationId,  List<AiMessageModel> messages,  bool isTyping,  bool offlineError,  List<AiSuggestionModel> suggestions)?  chat,TResult? Function( String message)?  error,TResult? Function( List<Map<String, dynamic>> items,  String message)?  photoOrderResult,TResult? Function( Map<String, dynamic> scores,  int overall,  String feedback,  String recommendation)?  qualityResult,TResult? Function( List<Map<String, dynamic>> history,  bool isTyping)?  gastroChat,}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _Chat() when chat != null:
return chat(_that.conversationId,_that.messages,_that.isTyping,_that.offlineError,_that.suggestions);case _Error() when error != null:
return error(_that.message);case _PhotoOrderResult() when photoOrderResult != null:
return photoOrderResult(_that.items,_that.message);case _QualityResult() when qualityResult != null:
return qualityResult(_that.scores,_that.overall,_that.feedback,_that.recommendation);case _GastroChat() when gastroChat != null:
return gastroChat(_that.history,_that.isTyping);case _:
  return null;

}
}

}

/// @nodoc


class _Loading implements AiState {
  const _Loading();

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}

@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AiState.loading()';
}

}




/// @nodoc


class _Chat implements AiState {
  const _Chat({required this.conversationId, required final  List<AiMessageModel> messages, required this.isTyping, this.offlineError = false, final  List<AiSuggestionModel> suggestions = const []}): _messages = messages,_suggestions = suggestions;

 final  String conversationId;
 final  List<AiMessageModel> _messages;
 List<AiMessageModel> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

 final  bool isTyping;
@JsonKey() final  bool offlineError;
 final  List<AiSuggestionModel> _suggestions;
@JsonKey() List<AiSuggestionModel> get suggestions {
  if (_suggestions is EqualUnmodifiableListView) return _suggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestions);
}


/// Create a copy of AiState
/// with the given fields replaced by the non-null parameter values.
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
$Res call({
 String conversationId, List<AiMessageModel> messages, bool isTyping, bool offlineError, List<AiSuggestionModel> suggestions
});

}
/// @nodoc
class __$ChatCopyWithImpl<$Res>
    implements _$ChatCopyWith<$Res> {
  __$ChatCopyWithImpl(this._self, this._then);

  final _Chat _self;
  final $Res Function(_Chat) _then;

/// Create a copy of AiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? messages = null,Object? isTyping = null,Object? offlineError = null,Object? suggestions = null,}) {
  return _then(_Chat(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessageModel>,isTyping: null == isTyping ? _self.isTyping : isTyping // ignore: cast_nullable_to_non_nullable
as bool,offlineError: null == offlineError ? _self.offlineError : offlineError // ignore: cast_nullable_to_non_nullable
as bool,suggestions: null == suggestions ? _self._suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<AiSuggestionModel>,
  ));
}

}

/// @nodoc


class _Error implements AiState {
  const _Error(this.message);

 final  String message;

/// Create a copy of AiState
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
  return 'AiState.error(message: $message)';
}

}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AiStateCopyWith<$Res> {
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

/// Create a copy of AiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}

/// @nodoc


class _PhotoOrderResult implements AiState {
  const _PhotoOrderResult({required final List<Map<String, dynamic>> items, required this.message}): _items = items;

 final  List<Map<String, dynamic>> _items;
 List<Map<String, dynamic>> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  return EqualUnmodifiableListView(_items);
}

 final  String message;

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoOrderResult&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.message, message) || other.message == message));
}

@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),message);

@override
String toString() {
  return 'AiState.photoOrderResult(items: $items, message: $message)';
}

}

/// @nodoc


class _QualityResult implements AiState {
  const _QualityResult({required final Map<String, dynamic> scores, required this.overall, required this.feedback, required this.recommendation}): _scores = scores;

 final  Map<String, dynamic> _scores;
 Map<String, dynamic> get scores {
  if (_scores is EqualUnmodifiableMapView) return _scores;
  return EqualUnmodifiableMapView(_scores);
}

 final  int overall;
 final  String feedback;
 final  String recommendation;

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QualityResult&&const DeepCollectionEquality().equals(other._scores, _scores)&&(identical(other.overall, overall) || other.overall == overall)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.recommendation, recommendation) || other.recommendation == recommendation));
}

@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_scores),overall,feedback,recommendation);

@override
String toString() {
  return 'AiState.qualityResult(scores: $scores, overall: $overall, feedback: $feedback, recommendation: $recommendation)';
}

}

/// @nodoc


class _GastroChat implements AiState {
  const _GastroChat({required final List<Map<String, dynamic>> history, required this.isTyping}): _history = history;

 final  List<Map<String, dynamic>> _history;
 List<Map<String, dynamic>> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  return EqualUnmodifiableListView(_history);
}

 final  bool isTyping;

/// Create a copy of AiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GastroChatCopyWith<_GastroChat> get copyWith => __$GastroChatCopyWithImpl<_GastroChat>(this, _$identity);

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GastroChat&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.isTyping, isTyping) || other.isTyping == isTyping));
}

@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_history),isTyping);

@override
String toString() {
  return 'AiState.gastroChat(history: $history, isTyping: $isTyping)';
}

}

/// @nodoc
abstract mixin class _$GastroChatCopyWith<$Res> implements $AiStateCopyWith<$Res> {
  factory _$GastroChatCopyWith(_GastroChat value, $Res Function(_GastroChat) _then) = __$GastroChatCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> history, bool isTyping
});

}
/// @nodoc
class __$GastroChatCopyWithImpl<$Res>
    implements _$GastroChatCopyWith<$Res> {
  __$GastroChatCopyWithImpl(this._self, this._then);

  final _GastroChat _self;
  final $Res Function(_GastroChat) _then;

@pragma('vm:prefer-inline') $Res call({Object? history = null,Object? isTyping = null,}) {
  return _then(_GastroChat(
history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isTyping: null == isTyping ? _self.isTyping : isTyping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}

// dart format on
