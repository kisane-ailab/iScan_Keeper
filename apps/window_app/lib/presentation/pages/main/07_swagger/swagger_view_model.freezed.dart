// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'swagger_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SwaggerState {

 bool get isLoading; double get progress; bool get canGoBack; bool get canGoForward; String? get currentUrl; bool get hasError; String? get errorMessage;
/// Create a copy of SwaggerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwaggerStateCopyWith<SwaggerState> get copyWith => _$SwaggerStateCopyWithImpl<SwaggerState>(this as SwaggerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwaggerState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.canGoBack, canGoBack) || other.canGoBack == canGoBack)&&(identical(other.canGoForward, canGoForward) || other.canGoForward == canGoForward)&&(identical(other.currentUrl, currentUrl) || other.currentUrl == currentUrl)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,progress,canGoBack,canGoForward,currentUrl,hasError,errorMessage);

@override
String toString() {
  return 'SwaggerState(isLoading: $isLoading, progress: $progress, canGoBack: $canGoBack, canGoForward: $canGoForward, currentUrl: $currentUrl, hasError: $hasError, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SwaggerStateCopyWith<$Res>  {
  factory $SwaggerStateCopyWith(SwaggerState value, $Res Function(SwaggerState) _then) = _$SwaggerStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, double progress, bool canGoBack, bool canGoForward, String? currentUrl, bool hasError, String? errorMessage
});




}
/// @nodoc
class _$SwaggerStateCopyWithImpl<$Res>
    implements $SwaggerStateCopyWith<$Res> {
  _$SwaggerStateCopyWithImpl(this._self, this._then);

  final SwaggerState _self;
  final $Res Function(SwaggerState) _then;

/// Create a copy of SwaggerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? progress = null,Object? canGoBack = null,Object? canGoForward = null,Object? currentUrl = freezed,Object? hasError = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,canGoBack: null == canGoBack ? _self.canGoBack : canGoBack // ignore: cast_nullable_to_non_nullable
as bool,canGoForward: null == canGoForward ? _self.canGoForward : canGoForward // ignore: cast_nullable_to_non_nullable
as bool,currentUrl: freezed == currentUrl ? _self.currentUrl : currentUrl // ignore: cast_nullable_to_non_nullable
as String?,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SwaggerState].
extension SwaggerStatePatterns on SwaggerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwaggerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwaggerState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwaggerState value)  $default,){
final _that = this;
switch (_that) {
case _SwaggerState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwaggerState value)?  $default,){
final _that = this;
switch (_that) {
case _SwaggerState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  double progress,  bool canGoBack,  bool canGoForward,  String? currentUrl,  bool hasError,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwaggerState() when $default != null:
return $default(_that.isLoading,_that.progress,_that.canGoBack,_that.canGoForward,_that.currentUrl,_that.hasError,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  double progress,  bool canGoBack,  bool canGoForward,  String? currentUrl,  bool hasError,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SwaggerState():
return $default(_that.isLoading,_that.progress,_that.canGoBack,_that.canGoForward,_that.currentUrl,_that.hasError,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  double progress,  bool canGoBack,  bool canGoForward,  String? currentUrl,  bool hasError,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SwaggerState() when $default != null:
return $default(_that.isLoading,_that.progress,_that.canGoBack,_that.canGoForward,_that.currentUrl,_that.hasError,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SwaggerState implements SwaggerState {
  const _SwaggerState({this.isLoading = true, this.progress = 0, this.canGoBack = false, this.canGoForward = false, this.currentUrl, this.hasError = false, this.errorMessage});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  double progress;
@override@JsonKey() final  bool canGoBack;
@override@JsonKey() final  bool canGoForward;
@override final  String? currentUrl;
@override@JsonKey() final  bool hasError;
@override final  String? errorMessage;

/// Create a copy of SwaggerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwaggerStateCopyWith<_SwaggerState> get copyWith => __$SwaggerStateCopyWithImpl<_SwaggerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwaggerState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.canGoBack, canGoBack) || other.canGoBack == canGoBack)&&(identical(other.canGoForward, canGoForward) || other.canGoForward == canGoForward)&&(identical(other.currentUrl, currentUrl) || other.currentUrl == currentUrl)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,progress,canGoBack,canGoForward,currentUrl,hasError,errorMessage);

@override
String toString() {
  return 'SwaggerState(isLoading: $isLoading, progress: $progress, canGoBack: $canGoBack, canGoForward: $canGoForward, currentUrl: $currentUrl, hasError: $hasError, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SwaggerStateCopyWith<$Res> implements $SwaggerStateCopyWith<$Res> {
  factory _$SwaggerStateCopyWith(_SwaggerState value, $Res Function(_SwaggerState) _then) = __$SwaggerStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, double progress, bool canGoBack, bool canGoForward, String? currentUrl, bool hasError, String? errorMessage
});




}
/// @nodoc
class __$SwaggerStateCopyWithImpl<$Res>
    implements _$SwaggerStateCopyWith<$Res> {
  __$SwaggerStateCopyWithImpl(this._self, this._then);

  final _SwaggerState _self;
  final $Res Function(_SwaggerState) _then;

/// Create a copy of SwaggerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? progress = null,Object? canGoBack = null,Object? canGoForward = null,Object? currentUrl = freezed,Object? hasError = null,Object? errorMessage = freezed,}) {
  return _then(_SwaggerState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,canGoBack: null == canGoBack ? _self.canGoBack : canGoBack // ignore: cast_nullable_to_non_nullable
as bool,canGoForward: null == canGoForward ? _self.canGoForward : canGoForward // ignore: cast_nullable_to_non_nullable
as bool,currentUrl: freezed == currentUrl ? _self.currentUrl : currentUrl // ignore: cast_nullable_to_non_nullable
as String?,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
