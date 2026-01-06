// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlertState {

 List<SystemLogEntity> get logs; int get alertCount;
/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertStateCopyWith<AlertState> get copyWith => _$AlertStateCopyWithImpl<AlertState>(this as AlertState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertState&&const DeepCollectionEquality().equals(other.logs, logs)&&(identical(other.alertCount, alertCount) || other.alertCount == alertCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(logs),alertCount);

@override
String toString() {
  return 'AlertState(logs: $logs, alertCount: $alertCount)';
}


}

/// @nodoc
abstract mixin class $AlertStateCopyWith<$Res>  {
  factory $AlertStateCopyWith(AlertState value, $Res Function(AlertState) _then) = _$AlertStateCopyWithImpl;
@useResult
$Res call({
 List<SystemLogEntity> logs, int alertCount
});




}
/// @nodoc
class _$AlertStateCopyWithImpl<$Res>
    implements $AlertStateCopyWith<$Res> {
  _$AlertStateCopyWithImpl(this._self, this._then);

  final AlertState _self;
  final $Res Function(AlertState) _then;

/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? logs = null,Object? alertCount = null,}) {
  return _then(_self.copyWith(
logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,alertCount: null == alertCount ? _self.alertCount : alertCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertState].
extension AlertStatePatterns on AlertState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertState value)  $default,){
final _that = this;
switch (_that) {
case _AlertState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertState value)?  $default,){
final _that = this;
switch (_that) {
case _AlertState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SystemLogEntity> logs,  int alertCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertState() when $default != null:
return $default(_that.logs,_that.alertCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SystemLogEntity> logs,  int alertCount)  $default,) {final _that = this;
switch (_that) {
case _AlertState():
return $default(_that.logs,_that.alertCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SystemLogEntity> logs,  int alertCount)?  $default,) {final _that = this;
switch (_that) {
case _AlertState() when $default != null:
return $default(_that.logs,_that.alertCount);case _:
  return null;

}
}

}

/// @nodoc


class _AlertState implements AlertState {
  const _AlertState({final  List<SystemLogEntity> logs = const [], this.alertCount = 0}): _logs = logs;
  

 final  List<SystemLogEntity> _logs;
@override@JsonKey() List<SystemLogEntity> get logs {
  if (_logs is EqualUnmodifiableListView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_logs);
}

@override@JsonKey() final  int alertCount;

/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertStateCopyWith<_AlertState> get copyWith => __$AlertStateCopyWithImpl<_AlertState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertState&&const DeepCollectionEquality().equals(other._logs, _logs)&&(identical(other.alertCount, alertCount) || other.alertCount == alertCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_logs),alertCount);

@override
String toString() {
  return 'AlertState(logs: $logs, alertCount: $alertCount)';
}


}

/// @nodoc
abstract mixin class _$AlertStateCopyWith<$Res> implements $AlertStateCopyWith<$Res> {
  factory _$AlertStateCopyWith(_AlertState value, $Res Function(_AlertState) _then) = __$AlertStateCopyWithImpl;
@override @useResult
$Res call({
 List<SystemLogEntity> logs, int alertCount
});




}
/// @nodoc
class __$AlertStateCopyWithImpl<$Res>
    implements _$AlertStateCopyWith<$Res> {
  __$AlertStateCopyWithImpl(this._self, this._then);

  final _AlertState _self;
  final $Res Function(_AlertState) _then;

/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? logs = null,Object? alertCount = null,}) {
  return _then(_AlertState(
logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,alertCount: null == alertCount ? _self.alertCount : alertCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
