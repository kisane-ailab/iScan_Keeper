// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkflowState {

 List<DatasetEntity> get datasets; WorkflowFilterMode get filterMode; int get pendingReviewCount; int get pendingApprovalCount; bool get isLoading; String? get selectedDatasetId;
/// Create a copy of WorkflowState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowStateCopyWith<WorkflowState> get copyWith => _$WorkflowStateCopyWithImpl<WorkflowState>(this as WorkflowState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowState&&const DeepCollectionEquality().equals(other.datasets, datasets)&&(identical(other.filterMode, filterMode) || other.filterMode == filterMode)&&(identical(other.pendingReviewCount, pendingReviewCount) || other.pendingReviewCount == pendingReviewCount)&&(identical(other.pendingApprovalCount, pendingApprovalCount) || other.pendingApprovalCount == pendingApprovalCount)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.selectedDatasetId, selectedDatasetId) || other.selectedDatasetId == selectedDatasetId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(datasets),filterMode,pendingReviewCount,pendingApprovalCount,isLoading,selectedDatasetId);

@override
String toString() {
  return 'WorkflowState(datasets: $datasets, filterMode: $filterMode, pendingReviewCount: $pendingReviewCount, pendingApprovalCount: $pendingApprovalCount, isLoading: $isLoading, selectedDatasetId: $selectedDatasetId)';
}


}

/// @nodoc
abstract mixin class $WorkflowStateCopyWith<$Res>  {
  factory $WorkflowStateCopyWith(WorkflowState value, $Res Function(WorkflowState) _then) = _$WorkflowStateCopyWithImpl;
@useResult
$Res call({
 List<DatasetEntity> datasets, WorkflowFilterMode filterMode, int pendingReviewCount, int pendingApprovalCount, bool isLoading, String? selectedDatasetId
});




}
/// @nodoc
class _$WorkflowStateCopyWithImpl<$Res>
    implements $WorkflowStateCopyWith<$Res> {
  _$WorkflowStateCopyWithImpl(this._self, this._then);

  final WorkflowState _self;
  final $Res Function(WorkflowState) _then;

/// Create a copy of WorkflowState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? datasets = null,Object? filterMode = null,Object? pendingReviewCount = null,Object? pendingApprovalCount = null,Object? isLoading = null,Object? selectedDatasetId = freezed,}) {
  return _then(_self.copyWith(
datasets: null == datasets ? _self.datasets : datasets // ignore: cast_nullable_to_non_nullable
as List<DatasetEntity>,filterMode: null == filterMode ? _self.filterMode : filterMode // ignore: cast_nullable_to_non_nullable
as WorkflowFilterMode,pendingReviewCount: null == pendingReviewCount ? _self.pendingReviewCount : pendingReviewCount // ignore: cast_nullable_to_non_nullable
as int,pendingApprovalCount: null == pendingApprovalCount ? _self.pendingApprovalCount : pendingApprovalCount // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,selectedDatasetId: freezed == selectedDatasetId ? _self.selectedDatasetId : selectedDatasetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkflowState].
extension WorkflowStatePatterns on WorkflowState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowState value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DatasetEntity> datasets,  WorkflowFilterMode filterMode,  int pendingReviewCount,  int pendingApprovalCount,  bool isLoading,  String? selectedDatasetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowState() when $default != null:
return $default(_that.datasets,_that.filterMode,_that.pendingReviewCount,_that.pendingApprovalCount,_that.isLoading,_that.selectedDatasetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DatasetEntity> datasets,  WorkflowFilterMode filterMode,  int pendingReviewCount,  int pendingApprovalCount,  bool isLoading,  String? selectedDatasetId)  $default,) {final _that = this;
switch (_that) {
case _WorkflowState():
return $default(_that.datasets,_that.filterMode,_that.pendingReviewCount,_that.pendingApprovalCount,_that.isLoading,_that.selectedDatasetId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DatasetEntity> datasets,  WorkflowFilterMode filterMode,  int pendingReviewCount,  int pendingApprovalCount,  bool isLoading,  String? selectedDatasetId)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowState() when $default != null:
return $default(_that.datasets,_that.filterMode,_that.pendingReviewCount,_that.pendingApprovalCount,_that.isLoading,_that.selectedDatasetId);case _:
  return null;

}
}

}

/// @nodoc


class _WorkflowState implements WorkflowState {
  const _WorkflowState({final  List<DatasetEntity> datasets = const [], this.filterMode = WorkflowFilterMode.all, this.pendingReviewCount = 0, this.pendingApprovalCount = 0, this.isLoading = false, this.selectedDatasetId}): _datasets = datasets;
  

 final  List<DatasetEntity> _datasets;
@override@JsonKey() List<DatasetEntity> get datasets {
  if (_datasets is EqualUnmodifiableListView) return _datasets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_datasets);
}

@override@JsonKey() final  WorkflowFilterMode filterMode;
@override@JsonKey() final  int pendingReviewCount;
@override@JsonKey() final  int pendingApprovalCount;
@override@JsonKey() final  bool isLoading;
@override final  String? selectedDatasetId;

/// Create a copy of WorkflowState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowStateCopyWith<_WorkflowState> get copyWith => __$WorkflowStateCopyWithImpl<_WorkflowState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowState&&const DeepCollectionEquality().equals(other._datasets, _datasets)&&(identical(other.filterMode, filterMode) || other.filterMode == filterMode)&&(identical(other.pendingReviewCount, pendingReviewCount) || other.pendingReviewCount == pendingReviewCount)&&(identical(other.pendingApprovalCount, pendingApprovalCount) || other.pendingApprovalCount == pendingApprovalCount)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.selectedDatasetId, selectedDatasetId) || other.selectedDatasetId == selectedDatasetId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_datasets),filterMode,pendingReviewCount,pendingApprovalCount,isLoading,selectedDatasetId);

@override
String toString() {
  return 'WorkflowState(datasets: $datasets, filterMode: $filterMode, pendingReviewCount: $pendingReviewCount, pendingApprovalCount: $pendingApprovalCount, isLoading: $isLoading, selectedDatasetId: $selectedDatasetId)';
}


}

/// @nodoc
abstract mixin class _$WorkflowStateCopyWith<$Res> implements $WorkflowStateCopyWith<$Res> {
  factory _$WorkflowStateCopyWith(_WorkflowState value, $Res Function(_WorkflowState) _then) = __$WorkflowStateCopyWithImpl;
@override @useResult
$Res call({
 List<DatasetEntity> datasets, WorkflowFilterMode filterMode, int pendingReviewCount, int pendingApprovalCount, bool isLoading, String? selectedDatasetId
});




}
/// @nodoc
class __$WorkflowStateCopyWithImpl<$Res>
    implements _$WorkflowStateCopyWith<$Res> {
  __$WorkflowStateCopyWithImpl(this._self, this._then);

  final _WorkflowState _self;
  final $Res Function(_WorkflowState) _then;

/// Create a copy of WorkflowState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? datasets = null,Object? filterMode = null,Object? pendingReviewCount = null,Object? pendingApprovalCount = null,Object? isLoading = null,Object? selectedDatasetId = freezed,}) {
  return _then(_WorkflowState(
datasets: null == datasets ? _self._datasets : datasets // ignore: cast_nullable_to_non_nullable
as List<DatasetEntity>,filterMode: null == filterMode ? _self.filterMode : filterMode // ignore: cast_nullable_to_non_nullable
as WorkflowFilterMode,pendingReviewCount: null == pendingReviewCount ? _self.pendingReviewCount : pendingReviewCount // ignore: cast_nullable_to_non_nullable
as int,pendingApprovalCount: null == pendingApprovalCount ? _self.pendingApprovalCount : pendingApprovalCount // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,selectedDatasetId: freezed == selectedDatasetId ? _self.selectedDatasetId : selectedDatasetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
