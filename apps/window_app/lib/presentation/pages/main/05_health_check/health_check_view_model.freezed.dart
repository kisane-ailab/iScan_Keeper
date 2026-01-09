// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_check_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HealthCheckState {

 List<SystemLogEntity> get productionLogs; List<SystemLogEntity> get developmentLogs; int get productionAlertCount; int get developmentAlertCount;
/// Create a copy of HealthCheckState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthCheckStateCopyWith<HealthCheckState> get copyWith => _$HealthCheckStateCopyWithImpl<HealthCheckState>(this as HealthCheckState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthCheckState&&const DeepCollectionEquality().equals(other.productionLogs, productionLogs)&&const DeepCollectionEquality().equals(other.developmentLogs, developmentLogs)&&(identical(other.productionAlertCount, productionAlertCount) || other.productionAlertCount == productionAlertCount)&&(identical(other.developmentAlertCount, developmentAlertCount) || other.developmentAlertCount == developmentAlertCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(productionLogs),const DeepCollectionEquality().hash(developmentLogs),productionAlertCount,developmentAlertCount);

@override
String toString() {
  return 'HealthCheckState(productionLogs: $productionLogs, developmentLogs: $developmentLogs, productionAlertCount: $productionAlertCount, developmentAlertCount: $developmentAlertCount)';
}


}

/// @nodoc
abstract mixin class $HealthCheckStateCopyWith<$Res>  {
  factory $HealthCheckStateCopyWith(HealthCheckState value, $Res Function(HealthCheckState) _then) = _$HealthCheckStateCopyWithImpl;
@useResult
$Res call({
 List<SystemLogEntity> productionLogs, List<SystemLogEntity> developmentLogs, int productionAlertCount, int developmentAlertCount
});




}
/// @nodoc
class _$HealthCheckStateCopyWithImpl<$Res>
    implements $HealthCheckStateCopyWith<$Res> {
  _$HealthCheckStateCopyWithImpl(this._self, this._then);

  final HealthCheckState _self;
  final $Res Function(HealthCheckState) _then;

/// Create a copy of HealthCheckState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productionLogs = null,Object? developmentLogs = null,Object? productionAlertCount = null,Object? developmentAlertCount = null,}) {
  return _then(_self.copyWith(
productionLogs: null == productionLogs ? _self.productionLogs : productionLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,developmentLogs: null == developmentLogs ? _self.developmentLogs : developmentLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,productionAlertCount: null == productionAlertCount ? _self.productionAlertCount : productionAlertCount // ignore: cast_nullable_to_non_nullable
as int,developmentAlertCount: null == developmentAlertCount ? _self.developmentAlertCount : developmentAlertCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthCheckState].
extension HealthCheckStatePatterns on HealthCheckState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthCheckState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthCheckState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthCheckState value)  $default,){
final _that = this;
switch (_that) {
case _HealthCheckState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthCheckState value)?  $default,){
final _that = this;
switch (_that) {
case _HealthCheckState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SystemLogEntity> productionLogs,  List<SystemLogEntity> developmentLogs,  int productionAlertCount,  int developmentAlertCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthCheckState() when $default != null:
return $default(_that.productionLogs,_that.developmentLogs,_that.productionAlertCount,_that.developmentAlertCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SystemLogEntity> productionLogs,  List<SystemLogEntity> developmentLogs,  int productionAlertCount,  int developmentAlertCount)  $default,) {final _that = this;
switch (_that) {
case _HealthCheckState():
return $default(_that.productionLogs,_that.developmentLogs,_that.productionAlertCount,_that.developmentAlertCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SystemLogEntity> productionLogs,  List<SystemLogEntity> developmentLogs,  int productionAlertCount,  int developmentAlertCount)?  $default,) {final _that = this;
switch (_that) {
case _HealthCheckState() when $default != null:
return $default(_that.productionLogs,_that.developmentLogs,_that.productionAlertCount,_that.developmentAlertCount);case _:
  return null;

}
}

}

/// @nodoc


class _HealthCheckState implements HealthCheckState {
  const _HealthCheckState({final  List<SystemLogEntity> productionLogs = const [], final  List<SystemLogEntity> developmentLogs = const [], this.productionAlertCount = 0, this.developmentAlertCount = 0}): _productionLogs = productionLogs,_developmentLogs = developmentLogs;
  

 final  List<SystemLogEntity> _productionLogs;
@override@JsonKey() List<SystemLogEntity> get productionLogs {
  if (_productionLogs is EqualUnmodifiableListView) return _productionLogs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_productionLogs);
}

 final  List<SystemLogEntity> _developmentLogs;
@override@JsonKey() List<SystemLogEntity> get developmentLogs {
  if (_developmentLogs is EqualUnmodifiableListView) return _developmentLogs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_developmentLogs);
}

@override@JsonKey() final  int productionAlertCount;
@override@JsonKey() final  int developmentAlertCount;

/// Create a copy of HealthCheckState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthCheckStateCopyWith<_HealthCheckState> get copyWith => __$HealthCheckStateCopyWithImpl<_HealthCheckState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthCheckState&&const DeepCollectionEquality().equals(other._productionLogs, _productionLogs)&&const DeepCollectionEquality().equals(other._developmentLogs, _developmentLogs)&&(identical(other.productionAlertCount, productionAlertCount) || other.productionAlertCount == productionAlertCount)&&(identical(other.developmentAlertCount, developmentAlertCount) || other.developmentAlertCount == developmentAlertCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_productionLogs),const DeepCollectionEquality().hash(_developmentLogs),productionAlertCount,developmentAlertCount);

@override
String toString() {
  return 'HealthCheckState(productionLogs: $productionLogs, developmentLogs: $developmentLogs, productionAlertCount: $productionAlertCount, developmentAlertCount: $developmentAlertCount)';
}


}

/// @nodoc
abstract mixin class _$HealthCheckStateCopyWith<$Res> implements $HealthCheckStateCopyWith<$Res> {
  factory _$HealthCheckStateCopyWith(_HealthCheckState value, $Res Function(_HealthCheckState) _then) = __$HealthCheckStateCopyWithImpl;
@override @useResult
$Res call({
 List<SystemLogEntity> productionLogs, List<SystemLogEntity> developmentLogs, int productionAlertCount, int developmentAlertCount
});




}
/// @nodoc
class __$HealthCheckStateCopyWithImpl<$Res>
    implements _$HealthCheckStateCopyWith<$Res> {
  __$HealthCheckStateCopyWithImpl(this._self, this._then);

  final _HealthCheckState _self;
  final $Res Function(_HealthCheckState) _then;

/// Create a copy of HealthCheckState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productionLogs = null,Object? developmentLogs = null,Object? productionAlertCount = null,Object? developmentAlertCount = null,}) {
  return _then(_HealthCheckState(
productionLogs: null == productionLogs ? _self._productionLogs : productionLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,developmentLogs: null == developmentLogs ? _self._developmentLogs : developmentLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,productionAlertCount: null == productionAlertCount ? _self.productionAlertCount : productionAlertCount // ignore: cast_nullable_to_non_nullable
as int,developmentAlertCount: null == developmentAlertCount ? _self.developmentAlertCount : developmentAlertCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
