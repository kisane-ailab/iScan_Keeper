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

 List<SystemLogEntity> get productionLogs; List<SystemLogEntity> get developmentLogs; int get productionAlertCount; int get developmentAlertCount;/// 필터링에 사용 가능한 source 목록
 List<String> get availableSources;/// 필터링에 사용 가능한 code 목록
 List<String> get availableCodes;/// 선택된 source 필터 (null이면 전체)
 String? get selectedSource;/// 선택된 code 필터 (null이면 전체)
 String? get selectedCode;/// 선택된 로그 레벨 필터 (빈 Set이면 전체)
 Set<LogLevel> get selectedLogLevels;/// 시작 날짜 필터 (null이면 제한 없음)
 DateTime? get startDate;/// 종료 날짜 필터 (null이면 제한 없음)
 DateTime? get endDate;
/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertStateCopyWith<AlertState> get copyWith => _$AlertStateCopyWithImpl<AlertState>(this as AlertState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertState&&const DeepCollectionEquality().equals(other.productionLogs, productionLogs)&&const DeepCollectionEquality().equals(other.developmentLogs, developmentLogs)&&(identical(other.productionAlertCount, productionAlertCount) || other.productionAlertCount == productionAlertCount)&&(identical(other.developmentAlertCount, developmentAlertCount) || other.developmentAlertCount == developmentAlertCount)&&const DeepCollectionEquality().equals(other.availableSources, availableSources)&&const DeepCollectionEquality().equals(other.availableCodes, availableCodes)&&(identical(other.selectedSource, selectedSource) || other.selectedSource == selectedSource)&&(identical(other.selectedCode, selectedCode) || other.selectedCode == selectedCode)&&const DeepCollectionEquality().equals(other.selectedLogLevels, selectedLogLevels)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(productionLogs),const DeepCollectionEquality().hash(developmentLogs),productionAlertCount,developmentAlertCount,const DeepCollectionEquality().hash(availableSources),const DeepCollectionEquality().hash(availableCodes),selectedSource,selectedCode,const DeepCollectionEquality().hash(selectedLogLevels),startDate,endDate);

@override
String toString() {
  return 'AlertState(productionLogs: $productionLogs, developmentLogs: $developmentLogs, productionAlertCount: $productionAlertCount, developmentAlertCount: $developmentAlertCount, availableSources: $availableSources, availableCodes: $availableCodes, selectedSource: $selectedSource, selectedCode: $selectedCode, selectedLogLevels: $selectedLogLevels, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $AlertStateCopyWith<$Res>  {
  factory $AlertStateCopyWith(AlertState value, $Res Function(AlertState) _then) = _$AlertStateCopyWithImpl;
@useResult
$Res call({
 List<SystemLogEntity> productionLogs, List<SystemLogEntity> developmentLogs, int productionAlertCount, int developmentAlertCount, List<String> availableSources, List<String> availableCodes, String? selectedSource, String? selectedCode, Set<LogLevel> selectedLogLevels, DateTime? startDate, DateTime? endDate
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
@pragma('vm:prefer-inline') @override $Res call({Object? productionLogs = null,Object? developmentLogs = null,Object? productionAlertCount = null,Object? developmentAlertCount = null,Object? availableSources = null,Object? availableCodes = null,Object? selectedSource = freezed,Object? selectedCode = freezed,Object? selectedLogLevels = null,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_self.copyWith(
productionLogs: null == productionLogs ? _self.productionLogs : productionLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,developmentLogs: null == developmentLogs ? _self.developmentLogs : developmentLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,productionAlertCount: null == productionAlertCount ? _self.productionAlertCount : productionAlertCount // ignore: cast_nullable_to_non_nullable
as int,developmentAlertCount: null == developmentAlertCount ? _self.developmentAlertCount : developmentAlertCount // ignore: cast_nullable_to_non_nullable
as int,availableSources: null == availableSources ? _self.availableSources : availableSources // ignore: cast_nullable_to_non_nullable
as List<String>,availableCodes: null == availableCodes ? _self.availableCodes : availableCodes // ignore: cast_nullable_to_non_nullable
as List<String>,selectedSource: freezed == selectedSource ? _self.selectedSource : selectedSource // ignore: cast_nullable_to_non_nullable
as String?,selectedCode: freezed == selectedCode ? _self.selectedCode : selectedCode // ignore: cast_nullable_to_non_nullable
as String?,selectedLogLevels: null == selectedLogLevels ? _self.selectedLogLevels : selectedLogLevels // ignore: cast_nullable_to_non_nullable
as Set<LogLevel>,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SystemLogEntity> productionLogs,  List<SystemLogEntity> developmentLogs,  int productionAlertCount,  int developmentAlertCount,  List<String> availableSources,  List<String> availableCodes,  String? selectedSource,  String? selectedCode,  Set<LogLevel> selectedLogLevels,  DateTime? startDate,  DateTime? endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertState() when $default != null:
return $default(_that.productionLogs,_that.developmentLogs,_that.productionAlertCount,_that.developmentAlertCount,_that.availableSources,_that.availableCodes,_that.selectedSource,_that.selectedCode,_that.selectedLogLevels,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SystemLogEntity> productionLogs,  List<SystemLogEntity> developmentLogs,  int productionAlertCount,  int developmentAlertCount,  List<String> availableSources,  List<String> availableCodes,  String? selectedSource,  String? selectedCode,  Set<LogLevel> selectedLogLevels,  DateTime? startDate,  DateTime? endDate)  $default,) {final _that = this;
switch (_that) {
case _AlertState():
return $default(_that.productionLogs,_that.developmentLogs,_that.productionAlertCount,_that.developmentAlertCount,_that.availableSources,_that.availableCodes,_that.selectedSource,_that.selectedCode,_that.selectedLogLevels,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SystemLogEntity> productionLogs,  List<SystemLogEntity> developmentLogs,  int productionAlertCount,  int developmentAlertCount,  List<String> availableSources,  List<String> availableCodes,  String? selectedSource,  String? selectedCode,  Set<LogLevel> selectedLogLevels,  DateTime? startDate,  DateTime? endDate)?  $default,) {final _that = this;
switch (_that) {
case _AlertState() when $default != null:
return $default(_that.productionLogs,_that.developmentLogs,_that.productionAlertCount,_that.developmentAlertCount,_that.availableSources,_that.availableCodes,_that.selectedSource,_that.selectedCode,_that.selectedLogLevels,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc


class _AlertState implements AlertState {
  const _AlertState({final  List<SystemLogEntity> productionLogs = const [], final  List<SystemLogEntity> developmentLogs = const [], this.productionAlertCount = 0, this.developmentAlertCount = 0, final  List<String> availableSources = const [], final  List<String> availableCodes = const [], this.selectedSource, this.selectedCode, final  Set<LogLevel> selectedLogLevels = const {}, this.startDate, this.endDate}): _productionLogs = productionLogs,_developmentLogs = developmentLogs,_availableSources = availableSources,_availableCodes = availableCodes,_selectedLogLevels = selectedLogLevels;
  

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
/// 필터링에 사용 가능한 source 목록
 final  List<String> _availableSources;
/// 필터링에 사용 가능한 source 목록
@override@JsonKey() List<String> get availableSources {
  if (_availableSources is EqualUnmodifiableListView) return _availableSources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableSources);
}

/// 필터링에 사용 가능한 code 목록
 final  List<String> _availableCodes;
/// 필터링에 사용 가능한 code 목록
@override@JsonKey() List<String> get availableCodes {
  if (_availableCodes is EqualUnmodifiableListView) return _availableCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableCodes);
}

/// 선택된 source 필터 (null이면 전체)
@override final  String? selectedSource;
/// 선택된 code 필터 (null이면 전체)
@override final  String? selectedCode;
/// 선택된 로그 레벨 필터 (빈 Set이면 전체)
 final  Set<LogLevel> _selectedLogLevels;
/// 선택된 로그 레벨 필터 (빈 Set이면 전체)
@override@JsonKey() Set<LogLevel> get selectedLogLevels {
  if (_selectedLogLevels is EqualUnmodifiableSetView) return _selectedLogLevels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedLogLevels);
}

/// 시작 날짜 필터 (null이면 제한 없음)
@override final  DateTime? startDate;
/// 종료 날짜 필터 (null이면 제한 없음)
@override final  DateTime? endDate;

/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertStateCopyWith<_AlertState> get copyWith => __$AlertStateCopyWithImpl<_AlertState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertState&&const DeepCollectionEquality().equals(other._productionLogs, _productionLogs)&&const DeepCollectionEquality().equals(other._developmentLogs, _developmentLogs)&&(identical(other.productionAlertCount, productionAlertCount) || other.productionAlertCount == productionAlertCount)&&(identical(other.developmentAlertCount, developmentAlertCount) || other.developmentAlertCount == developmentAlertCount)&&const DeepCollectionEquality().equals(other._availableSources, _availableSources)&&const DeepCollectionEquality().equals(other._availableCodes, _availableCodes)&&(identical(other.selectedSource, selectedSource) || other.selectedSource == selectedSource)&&(identical(other.selectedCode, selectedCode) || other.selectedCode == selectedCode)&&const DeepCollectionEquality().equals(other._selectedLogLevels, _selectedLogLevels)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_productionLogs),const DeepCollectionEquality().hash(_developmentLogs),productionAlertCount,developmentAlertCount,const DeepCollectionEquality().hash(_availableSources),const DeepCollectionEquality().hash(_availableCodes),selectedSource,selectedCode,const DeepCollectionEquality().hash(_selectedLogLevels),startDate,endDate);

@override
String toString() {
  return 'AlertState(productionLogs: $productionLogs, developmentLogs: $developmentLogs, productionAlertCount: $productionAlertCount, developmentAlertCount: $developmentAlertCount, availableSources: $availableSources, availableCodes: $availableCodes, selectedSource: $selectedSource, selectedCode: $selectedCode, selectedLogLevels: $selectedLogLevels, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$AlertStateCopyWith<$Res> implements $AlertStateCopyWith<$Res> {
  factory _$AlertStateCopyWith(_AlertState value, $Res Function(_AlertState) _then) = __$AlertStateCopyWithImpl;
@override @useResult
$Res call({
 List<SystemLogEntity> productionLogs, List<SystemLogEntity> developmentLogs, int productionAlertCount, int developmentAlertCount, List<String> availableSources, List<String> availableCodes, String? selectedSource, String? selectedCode, Set<LogLevel> selectedLogLevels, DateTime? startDate, DateTime? endDate
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
@override @pragma('vm:prefer-inline') $Res call({Object? productionLogs = null,Object? developmentLogs = null,Object? productionAlertCount = null,Object? developmentAlertCount = null,Object? availableSources = null,Object? availableCodes = null,Object? selectedSource = freezed,Object? selectedCode = freezed,Object? selectedLogLevels = null,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_AlertState(
productionLogs: null == productionLogs ? _self._productionLogs : productionLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,developmentLogs: null == developmentLogs ? _self._developmentLogs : developmentLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,productionAlertCount: null == productionAlertCount ? _self.productionAlertCount : productionAlertCount // ignore: cast_nullable_to_non_nullable
as int,developmentAlertCount: null == developmentAlertCount ? _self.developmentAlertCount : developmentAlertCount // ignore: cast_nullable_to_non_nullable
as int,availableSources: null == availableSources ? _self._availableSources : availableSources // ignore: cast_nullable_to_non_nullable
as List<String>,availableCodes: null == availableCodes ? _self._availableCodes : availableCodes // ignore: cast_nullable_to_non_nullable
as List<String>,selectedSource: freezed == selectedSource ? _self.selectedSource : selectedSource // ignore: cast_nullable_to_non_nullable
as String?,selectedCode: freezed == selectedCode ? _self.selectedCode : selectedCode // ignore: cast_nullable_to_non_nullable
as String?,selectedLogLevels: null == selectedLogLevels ? _self._selectedLogLevels : selectedLogLevels // ignore: cast_nullable_to_non_nullable
as Set<LogLevel>,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
