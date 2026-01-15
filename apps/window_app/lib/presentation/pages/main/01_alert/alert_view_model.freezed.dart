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
mixin _$EnvironmentFilterState {

 List<String> get availableSources; List<String> get availableSites; List<String> get availableCodes; String? get selectedSource; String? get selectedSite; String? get selectedCode; Set<LogLevel> get selectedLogLevels; DateTime? get startDate; DateTime? get endDate; GroupingMode get groupingMode;
/// Create a copy of EnvironmentFilterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnvironmentFilterStateCopyWith<EnvironmentFilterState> get copyWith => _$EnvironmentFilterStateCopyWithImpl<EnvironmentFilterState>(this as EnvironmentFilterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnvironmentFilterState&&const DeepCollectionEquality().equals(other.availableSources, availableSources)&&const DeepCollectionEquality().equals(other.availableSites, availableSites)&&const DeepCollectionEquality().equals(other.availableCodes, availableCodes)&&(identical(other.selectedSource, selectedSource) || other.selectedSource == selectedSource)&&(identical(other.selectedSite, selectedSite) || other.selectedSite == selectedSite)&&(identical(other.selectedCode, selectedCode) || other.selectedCode == selectedCode)&&const DeepCollectionEquality().equals(other.selectedLogLevels, selectedLogLevels)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.groupingMode, groupingMode) || other.groupingMode == groupingMode));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(availableSources),const DeepCollectionEquality().hash(availableSites),const DeepCollectionEquality().hash(availableCodes),selectedSource,selectedSite,selectedCode,const DeepCollectionEquality().hash(selectedLogLevels),startDate,endDate,groupingMode);

@override
String toString() {
  return 'EnvironmentFilterState(availableSources: $availableSources, availableSites: $availableSites, availableCodes: $availableCodes, selectedSource: $selectedSource, selectedSite: $selectedSite, selectedCode: $selectedCode, selectedLogLevels: $selectedLogLevels, startDate: $startDate, endDate: $endDate, groupingMode: $groupingMode)';
}


}

/// @nodoc
abstract mixin class $EnvironmentFilterStateCopyWith<$Res>  {
  factory $EnvironmentFilterStateCopyWith(EnvironmentFilterState value, $Res Function(EnvironmentFilterState) _then) = _$EnvironmentFilterStateCopyWithImpl;
@useResult
$Res call({
 List<String> availableSources, List<String> availableSites, List<String> availableCodes, String? selectedSource, String? selectedSite, String? selectedCode, Set<LogLevel> selectedLogLevels, DateTime? startDate, DateTime? endDate, GroupingMode groupingMode
});




}
/// @nodoc
class _$EnvironmentFilterStateCopyWithImpl<$Res>
    implements $EnvironmentFilterStateCopyWith<$Res> {
  _$EnvironmentFilterStateCopyWithImpl(this._self, this._then);

  final EnvironmentFilterState _self;
  final $Res Function(EnvironmentFilterState) _then;

/// Create a copy of EnvironmentFilterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? availableSources = null,Object? availableSites = null,Object? availableCodes = null,Object? selectedSource = freezed,Object? selectedSite = freezed,Object? selectedCode = freezed,Object? selectedLogLevels = null,Object? startDate = freezed,Object? endDate = freezed,Object? groupingMode = null,}) {
  return _then(_self.copyWith(
availableSources: null == availableSources ? _self.availableSources : availableSources // ignore: cast_nullable_to_non_nullable
as List<String>,availableSites: null == availableSites ? _self.availableSites : availableSites // ignore: cast_nullable_to_non_nullable
as List<String>,availableCodes: null == availableCodes ? _self.availableCodes : availableCodes // ignore: cast_nullable_to_non_nullable
as List<String>,selectedSource: freezed == selectedSource ? _self.selectedSource : selectedSource // ignore: cast_nullable_to_non_nullable
as String?,selectedSite: freezed == selectedSite ? _self.selectedSite : selectedSite // ignore: cast_nullable_to_non_nullable
as String?,selectedCode: freezed == selectedCode ? _self.selectedCode : selectedCode // ignore: cast_nullable_to_non_nullable
as String?,selectedLogLevels: null == selectedLogLevels ? _self.selectedLogLevels : selectedLogLevels // ignore: cast_nullable_to_non_nullable
as Set<LogLevel>,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,groupingMode: null == groupingMode ? _self.groupingMode : groupingMode // ignore: cast_nullable_to_non_nullable
as GroupingMode,
  ));
}

}


/// Adds pattern-matching-related methods to [EnvironmentFilterState].
extension EnvironmentFilterStatePatterns on EnvironmentFilterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnvironmentFilterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnvironmentFilterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnvironmentFilterState value)  $default,){
final _that = this;
switch (_that) {
case _EnvironmentFilterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnvironmentFilterState value)?  $default,){
final _that = this;
switch (_that) {
case _EnvironmentFilterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> availableSources,  List<String> availableSites,  List<String> availableCodes,  String? selectedSource,  String? selectedSite,  String? selectedCode,  Set<LogLevel> selectedLogLevels,  DateTime? startDate,  DateTime? endDate,  GroupingMode groupingMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnvironmentFilterState() when $default != null:
return $default(_that.availableSources,_that.availableSites,_that.availableCodes,_that.selectedSource,_that.selectedSite,_that.selectedCode,_that.selectedLogLevels,_that.startDate,_that.endDate,_that.groupingMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> availableSources,  List<String> availableSites,  List<String> availableCodes,  String? selectedSource,  String? selectedSite,  String? selectedCode,  Set<LogLevel> selectedLogLevels,  DateTime? startDate,  DateTime? endDate,  GroupingMode groupingMode)  $default,) {final _that = this;
switch (_that) {
case _EnvironmentFilterState():
return $default(_that.availableSources,_that.availableSites,_that.availableCodes,_that.selectedSource,_that.selectedSite,_that.selectedCode,_that.selectedLogLevels,_that.startDate,_that.endDate,_that.groupingMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> availableSources,  List<String> availableSites,  List<String> availableCodes,  String? selectedSource,  String? selectedSite,  String? selectedCode,  Set<LogLevel> selectedLogLevels,  DateTime? startDate,  DateTime? endDate,  GroupingMode groupingMode)?  $default,) {final _that = this;
switch (_that) {
case _EnvironmentFilterState() when $default != null:
return $default(_that.availableSources,_that.availableSites,_that.availableCodes,_that.selectedSource,_that.selectedSite,_that.selectedCode,_that.selectedLogLevels,_that.startDate,_that.endDate,_that.groupingMode);case _:
  return null;

}
}

}

/// @nodoc


class _EnvironmentFilterState implements EnvironmentFilterState {
  const _EnvironmentFilterState({final  List<String> availableSources = const [], final  List<String> availableSites = const [], final  List<String> availableCodes = const [], this.selectedSource, this.selectedSite, this.selectedCode, final  Set<LogLevel> selectedLogLevels = const {}, this.startDate, this.endDate, this.groupingMode = GroupingMode.none}): _availableSources = availableSources,_availableSites = availableSites,_availableCodes = availableCodes,_selectedLogLevels = selectedLogLevels;
  

 final  List<String> _availableSources;
@override@JsonKey() List<String> get availableSources {
  if (_availableSources is EqualUnmodifiableListView) return _availableSources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableSources);
}

 final  List<String> _availableSites;
@override@JsonKey() List<String> get availableSites {
  if (_availableSites is EqualUnmodifiableListView) return _availableSites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableSites);
}

 final  List<String> _availableCodes;
@override@JsonKey() List<String> get availableCodes {
  if (_availableCodes is EqualUnmodifiableListView) return _availableCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableCodes);
}

@override final  String? selectedSource;
@override final  String? selectedSite;
@override final  String? selectedCode;
 final  Set<LogLevel> _selectedLogLevels;
@override@JsonKey() Set<LogLevel> get selectedLogLevels {
  if (_selectedLogLevels is EqualUnmodifiableSetView) return _selectedLogLevels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedLogLevels);
}

@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override@JsonKey() final  GroupingMode groupingMode;

/// Create a copy of EnvironmentFilterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnvironmentFilterStateCopyWith<_EnvironmentFilterState> get copyWith => __$EnvironmentFilterStateCopyWithImpl<_EnvironmentFilterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnvironmentFilterState&&const DeepCollectionEquality().equals(other._availableSources, _availableSources)&&const DeepCollectionEquality().equals(other._availableSites, _availableSites)&&const DeepCollectionEquality().equals(other._availableCodes, _availableCodes)&&(identical(other.selectedSource, selectedSource) || other.selectedSource == selectedSource)&&(identical(other.selectedSite, selectedSite) || other.selectedSite == selectedSite)&&(identical(other.selectedCode, selectedCode) || other.selectedCode == selectedCode)&&const DeepCollectionEquality().equals(other._selectedLogLevels, _selectedLogLevels)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.groupingMode, groupingMode) || other.groupingMode == groupingMode));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_availableSources),const DeepCollectionEquality().hash(_availableSites),const DeepCollectionEquality().hash(_availableCodes),selectedSource,selectedSite,selectedCode,const DeepCollectionEquality().hash(_selectedLogLevels),startDate,endDate,groupingMode);

@override
String toString() {
  return 'EnvironmentFilterState(availableSources: $availableSources, availableSites: $availableSites, availableCodes: $availableCodes, selectedSource: $selectedSource, selectedSite: $selectedSite, selectedCode: $selectedCode, selectedLogLevels: $selectedLogLevels, startDate: $startDate, endDate: $endDate, groupingMode: $groupingMode)';
}


}

/// @nodoc
abstract mixin class _$EnvironmentFilterStateCopyWith<$Res> implements $EnvironmentFilterStateCopyWith<$Res> {
  factory _$EnvironmentFilterStateCopyWith(_EnvironmentFilterState value, $Res Function(_EnvironmentFilterState) _then) = __$EnvironmentFilterStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> availableSources, List<String> availableSites, List<String> availableCodes, String? selectedSource, String? selectedSite, String? selectedCode, Set<LogLevel> selectedLogLevels, DateTime? startDate, DateTime? endDate, GroupingMode groupingMode
});




}
/// @nodoc
class __$EnvironmentFilterStateCopyWithImpl<$Res>
    implements _$EnvironmentFilterStateCopyWith<$Res> {
  __$EnvironmentFilterStateCopyWithImpl(this._self, this._then);

  final _EnvironmentFilterState _self;
  final $Res Function(_EnvironmentFilterState) _then;

/// Create a copy of EnvironmentFilterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? availableSources = null,Object? availableSites = null,Object? availableCodes = null,Object? selectedSource = freezed,Object? selectedSite = freezed,Object? selectedCode = freezed,Object? selectedLogLevels = null,Object? startDate = freezed,Object? endDate = freezed,Object? groupingMode = null,}) {
  return _then(_EnvironmentFilterState(
availableSources: null == availableSources ? _self._availableSources : availableSources // ignore: cast_nullable_to_non_nullable
as List<String>,availableSites: null == availableSites ? _self._availableSites : availableSites // ignore: cast_nullable_to_non_nullable
as List<String>,availableCodes: null == availableCodes ? _self._availableCodes : availableCodes // ignore: cast_nullable_to_non_nullable
as List<String>,selectedSource: freezed == selectedSource ? _self.selectedSource : selectedSource // ignore: cast_nullable_to_non_nullable
as String?,selectedSite: freezed == selectedSite ? _self.selectedSite : selectedSite // ignore: cast_nullable_to_non_nullable
as String?,selectedCode: freezed == selectedCode ? _self.selectedCode : selectedCode // ignore: cast_nullable_to_non_nullable
as String?,selectedLogLevels: null == selectedLogLevels ? _self._selectedLogLevels : selectedLogLevels // ignore: cast_nullable_to_non_nullable
as Set<LogLevel>,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,groupingMode: null == groupingMode ? _self.groupingMode : groupingMode // ignore: cast_nullable_to_non_nullable
as GroupingMode,
  ));
}


}

/// @nodoc
mixin _$AlertState {

 List<SystemLogEntity> get productionLogs; List<SystemLogEntity> get developmentLogs; int get productionAlertCount; int get developmentAlertCount;/// Production 환경 필터 상태
 EnvironmentFilterState get productionFilter;/// Development 환경 필터 상태
 EnvironmentFilterState get developmentFilter;
/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertStateCopyWith<AlertState> get copyWith => _$AlertStateCopyWithImpl<AlertState>(this as AlertState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertState&&const DeepCollectionEquality().equals(other.productionLogs, productionLogs)&&const DeepCollectionEquality().equals(other.developmentLogs, developmentLogs)&&(identical(other.productionAlertCount, productionAlertCount) || other.productionAlertCount == productionAlertCount)&&(identical(other.developmentAlertCount, developmentAlertCount) || other.developmentAlertCount == developmentAlertCount)&&(identical(other.productionFilter, productionFilter) || other.productionFilter == productionFilter)&&(identical(other.developmentFilter, developmentFilter) || other.developmentFilter == developmentFilter));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(productionLogs),const DeepCollectionEquality().hash(developmentLogs),productionAlertCount,developmentAlertCount,productionFilter,developmentFilter);

@override
String toString() {
  return 'AlertState(productionLogs: $productionLogs, developmentLogs: $developmentLogs, productionAlertCount: $productionAlertCount, developmentAlertCount: $developmentAlertCount, productionFilter: $productionFilter, developmentFilter: $developmentFilter)';
}


}

/// @nodoc
abstract mixin class $AlertStateCopyWith<$Res>  {
  factory $AlertStateCopyWith(AlertState value, $Res Function(AlertState) _then) = _$AlertStateCopyWithImpl;
@useResult
$Res call({
 List<SystemLogEntity> productionLogs, List<SystemLogEntity> developmentLogs, int productionAlertCount, int developmentAlertCount, EnvironmentFilterState productionFilter, EnvironmentFilterState developmentFilter
});


$EnvironmentFilterStateCopyWith<$Res> get productionFilter;$EnvironmentFilterStateCopyWith<$Res> get developmentFilter;

}
/// @nodoc
class _$AlertStateCopyWithImpl<$Res>
    implements $AlertStateCopyWith<$Res> {
  _$AlertStateCopyWithImpl(this._self, this._then);

  final AlertState _self;
  final $Res Function(AlertState) _then;

/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productionLogs = null,Object? developmentLogs = null,Object? productionAlertCount = null,Object? developmentAlertCount = null,Object? productionFilter = null,Object? developmentFilter = null,}) {
  return _then(_self.copyWith(
productionLogs: null == productionLogs ? _self.productionLogs : productionLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,developmentLogs: null == developmentLogs ? _self.developmentLogs : developmentLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,productionAlertCount: null == productionAlertCount ? _self.productionAlertCount : productionAlertCount // ignore: cast_nullable_to_non_nullable
as int,developmentAlertCount: null == developmentAlertCount ? _self.developmentAlertCount : developmentAlertCount // ignore: cast_nullable_to_non_nullable
as int,productionFilter: null == productionFilter ? _self.productionFilter : productionFilter // ignore: cast_nullable_to_non_nullable
as EnvironmentFilterState,developmentFilter: null == developmentFilter ? _self.developmentFilter : developmentFilter // ignore: cast_nullable_to_non_nullable
as EnvironmentFilterState,
  ));
}
/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EnvironmentFilterStateCopyWith<$Res> get productionFilter {
  
  return $EnvironmentFilterStateCopyWith<$Res>(_self.productionFilter, (value) {
    return _then(_self.copyWith(productionFilter: value));
  });
}/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EnvironmentFilterStateCopyWith<$Res> get developmentFilter {
  
  return $EnvironmentFilterStateCopyWith<$Res>(_self.developmentFilter, (value) {
    return _then(_self.copyWith(developmentFilter: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SystemLogEntity> productionLogs,  List<SystemLogEntity> developmentLogs,  int productionAlertCount,  int developmentAlertCount,  EnvironmentFilterState productionFilter,  EnvironmentFilterState developmentFilter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertState() when $default != null:
return $default(_that.productionLogs,_that.developmentLogs,_that.productionAlertCount,_that.developmentAlertCount,_that.productionFilter,_that.developmentFilter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SystemLogEntity> productionLogs,  List<SystemLogEntity> developmentLogs,  int productionAlertCount,  int developmentAlertCount,  EnvironmentFilterState productionFilter,  EnvironmentFilterState developmentFilter)  $default,) {final _that = this;
switch (_that) {
case _AlertState():
return $default(_that.productionLogs,_that.developmentLogs,_that.productionAlertCount,_that.developmentAlertCount,_that.productionFilter,_that.developmentFilter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SystemLogEntity> productionLogs,  List<SystemLogEntity> developmentLogs,  int productionAlertCount,  int developmentAlertCount,  EnvironmentFilterState productionFilter,  EnvironmentFilterState developmentFilter)?  $default,) {final _that = this;
switch (_that) {
case _AlertState() when $default != null:
return $default(_that.productionLogs,_that.developmentLogs,_that.productionAlertCount,_that.developmentAlertCount,_that.productionFilter,_that.developmentFilter);case _:
  return null;

}
}

}

/// @nodoc


class _AlertState implements AlertState {
  const _AlertState({final  List<SystemLogEntity> productionLogs = const [], final  List<SystemLogEntity> developmentLogs = const [], this.productionAlertCount = 0, this.developmentAlertCount = 0, this.productionFilter = const EnvironmentFilterState(), this.developmentFilter = const EnvironmentFilterState()}): _productionLogs = productionLogs,_developmentLogs = developmentLogs;
  

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
/// Production 환경 필터 상태
@override@JsonKey() final  EnvironmentFilterState productionFilter;
/// Development 환경 필터 상태
@override@JsonKey() final  EnvironmentFilterState developmentFilter;

/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertStateCopyWith<_AlertState> get copyWith => __$AlertStateCopyWithImpl<_AlertState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertState&&const DeepCollectionEquality().equals(other._productionLogs, _productionLogs)&&const DeepCollectionEquality().equals(other._developmentLogs, _developmentLogs)&&(identical(other.productionAlertCount, productionAlertCount) || other.productionAlertCount == productionAlertCount)&&(identical(other.developmentAlertCount, developmentAlertCount) || other.developmentAlertCount == developmentAlertCount)&&(identical(other.productionFilter, productionFilter) || other.productionFilter == productionFilter)&&(identical(other.developmentFilter, developmentFilter) || other.developmentFilter == developmentFilter));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_productionLogs),const DeepCollectionEquality().hash(_developmentLogs),productionAlertCount,developmentAlertCount,productionFilter,developmentFilter);

@override
String toString() {
  return 'AlertState(productionLogs: $productionLogs, developmentLogs: $developmentLogs, productionAlertCount: $productionAlertCount, developmentAlertCount: $developmentAlertCount, productionFilter: $productionFilter, developmentFilter: $developmentFilter)';
}


}

/// @nodoc
abstract mixin class _$AlertStateCopyWith<$Res> implements $AlertStateCopyWith<$Res> {
  factory _$AlertStateCopyWith(_AlertState value, $Res Function(_AlertState) _then) = __$AlertStateCopyWithImpl;
@override @useResult
$Res call({
 List<SystemLogEntity> productionLogs, List<SystemLogEntity> developmentLogs, int productionAlertCount, int developmentAlertCount, EnvironmentFilterState productionFilter, EnvironmentFilterState developmentFilter
});


@override $EnvironmentFilterStateCopyWith<$Res> get productionFilter;@override $EnvironmentFilterStateCopyWith<$Res> get developmentFilter;

}
/// @nodoc
class __$AlertStateCopyWithImpl<$Res>
    implements _$AlertStateCopyWith<$Res> {
  __$AlertStateCopyWithImpl(this._self, this._then);

  final _AlertState _self;
  final $Res Function(_AlertState) _then;

/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productionLogs = null,Object? developmentLogs = null,Object? productionAlertCount = null,Object? developmentAlertCount = null,Object? productionFilter = null,Object? developmentFilter = null,}) {
  return _then(_AlertState(
productionLogs: null == productionLogs ? _self._productionLogs : productionLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,developmentLogs: null == developmentLogs ? _self._developmentLogs : developmentLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLogEntity>,productionAlertCount: null == productionAlertCount ? _self.productionAlertCount : productionAlertCount // ignore: cast_nullable_to_non_nullable
as int,developmentAlertCount: null == developmentAlertCount ? _self.developmentAlertCount : developmentAlertCount // ignore: cast_nullable_to_non_nullable
as int,productionFilter: null == productionFilter ? _self.productionFilter : productionFilter // ignore: cast_nullable_to_non_nullable
as EnvironmentFilterState,developmentFilter: null == developmentFilter ? _self.developmentFilter : developmentFilter // ignore: cast_nullable_to_non_nullable
as EnvironmentFilterState,
  ));
}

/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EnvironmentFilterStateCopyWith<$Res> get productionFilter {
  
  return $EnvironmentFilterStateCopyWith<$Res>(_self.productionFilter, (value) {
    return _then(_self.copyWith(productionFilter: value));
  });
}/// Create a copy of AlertState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EnvironmentFilterStateCopyWith<$Res> get developmentFilter {
  
  return $EnvironmentFilterStateCopyWith<$Res>(_self.developmentFilter, (value) {
    return _then(_self.copyWith(developmentFilter: value));
  });
}
}

// dart format on
