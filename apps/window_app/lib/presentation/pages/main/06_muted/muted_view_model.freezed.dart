// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'muted_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MutedState {

 List<SystemLogEntity> get logs; bool get isLoading; String? get error;
/// Create a copy of MutedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MutedStateCopyWith<MutedState> get copyWith => _$MutedStateCopyWithImpl<MutedState>(this as MutedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MutedState&&const DeepCollectionEquality().equals(other.logs, logs)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(logs),isLoading,error);

@override
String toString() {
  return 'MutedState(logs: $logs, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $MutedStateCopyWith<$Res>  {
  factory $MutedStateCopyWith(MutedState value, $Res Function(MutedState) _then) = _$MutedStateCopyWithImpl;
@useResult
$Res call({
 List<SystemLogEntity> logs, bool isLoading, String? error
});




}
/// @nodoc
class _$MutedStateCopyWithImpl<$Res>
    implements $MutedStateCopyWith<$Res> {
  _$MutedStateCopyWithImpl(this._self, this._then);

  final MutedState _self;
  final $Res Function(MutedState) _then;

/// Create a copy of MutedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? logs = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MutedState].
extension MutedStatePatterns on MutedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MutedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MutedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MutedState value)  $default,){
final _that = this;
switch (_that) {
case _MutedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MutedState value)?  $default,){
final _that = this;
switch (_that) {
case _MutedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SystemLogEntity> logs,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MutedState() when $default != null:
return $default(_that.logs,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SystemLogEntity> logs,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _MutedState():
return $default(_that.logs,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SystemLogEntity> logs,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _MutedState() when $default != null:
return $default(_that.logs,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _MutedState implements MutedState {
  const _MutedState({final  List<SystemLogEntity> logs = const [], this.isLoading = false, this.error}): _logs = logs;
  

 final  List<SystemLogEntity> _logs;
@override@JsonKey() List<SystemLogEntity> get logs {
  if (_logs is EqualUnmodifiableListView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_logs);
}

@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of MutedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MutedStateCopyWith<_MutedState> get copyWith => __$MutedStateCopyWithImpl<_MutedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MutedState&&const DeepCollectionEquality().equals(other._logs, _logs)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_logs),isLoading,error);

@override
String toString() {
  return 'MutedState(logs: $logs, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$MutedStateCopyWith<$Res> implements $MutedStateCopyWith<$Res> {
  factory _$MutedStateCopyWith(_MutedState value, $Res Function(_MutedState) _then) = __$MutedStateCopyWithImpl;
@override @useResult
$Res call({
 List<SystemLogEntity> logs, bool isLoading, String? error
});




}
/// @nodoc
class __$MutedStateCopyWithImpl<$Res>
    implements _$MutedStateCopyWith<$Res> {
  __$MutedStateCopyWithImpl(this._self, this._then);

  final _MutedState _self;
  final $Res Function(_MutedState) _then;

/// Create a copy of MutedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? logs = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_MutedState(
logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
