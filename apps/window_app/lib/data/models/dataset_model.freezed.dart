// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dataset_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DatasetModel {

 String get id; String get name; String? get description;@JsonKey(name: 'source_path') String get sourcePath; Map<String, dynamic> get metadata;// 워크플로우 상태
@JsonKey(name: 'state') DatasetState get state;@JsonKey(name: 'admin_decision') AdminDecision get adminDecision;@JsonKey(name: 'rejection_reason') String? get rejectionReason;// 리뷰어 정보
@JsonKey(name: 'reviewer_id') String? get reviewerId;@JsonKey(name: 'reviewer_name') String? get reviewerName;@JsonKey(name: 'review_started_at') DateTime? get reviewStartedAt;@JsonKey(name: 'review_completed_at') DateTime? get reviewCompletedAt;@JsonKey(name: 'review_note') String? get reviewNote;// 승인자 정보
@JsonKey(name: 'approver_id') String? get approverId;@JsonKey(name: 'approver_name') String? get approverName;@JsonKey(name: 'approved_at') DateTime? get approvedAt;// 퍼블리시 정보
@JsonKey(name: 'published_at') DateTime? get publishedAt;@JsonKey(name: 'published_path') String? get publishedPath;// 공통 필드
@JsonKey(name: 'environment') Environment get environment;@JsonKey(name: 'organization_id') String? get organizationId;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of DatasetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatasetModelCopyWith<DatasetModel> get copyWith => _$DatasetModelCopyWithImpl<DatasetModel>(this as DatasetModel, _$identity);

  /// Serializes this DatasetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DatasetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.sourcePath, sourcePath) || other.sourcePath == sourcePath)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.state, state) || other.state == state)&&(identical(other.adminDecision, adminDecision) || other.adminDecision == adminDecision)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.reviewerId, reviewerId) || other.reviewerId == reviewerId)&&(identical(other.reviewerName, reviewerName) || other.reviewerName == reviewerName)&&(identical(other.reviewStartedAt, reviewStartedAt) || other.reviewStartedAt == reviewStartedAt)&&(identical(other.reviewCompletedAt, reviewCompletedAt) || other.reviewCompletedAt == reviewCompletedAt)&&(identical(other.reviewNote, reviewNote) || other.reviewNote == reviewNote)&&(identical(other.approverId, approverId) || other.approverId == approverId)&&(identical(other.approverName, approverName) || other.approverName == approverName)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.publishedPath, publishedPath) || other.publishedPath == publishedPath)&&(identical(other.environment, environment) || other.environment == environment)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,sourcePath,const DeepCollectionEquality().hash(metadata),state,adminDecision,rejectionReason,reviewerId,reviewerName,reviewStartedAt,reviewCompletedAt,reviewNote,approverId,approverName,approvedAt,publishedAt,publishedPath,environment,organizationId,createdAt,updatedAt]);

@override
String toString() {
  return 'DatasetModel(id: $id, name: $name, description: $description, sourcePath: $sourcePath, metadata: $metadata, state: $state, adminDecision: $adminDecision, rejectionReason: $rejectionReason, reviewerId: $reviewerId, reviewerName: $reviewerName, reviewStartedAt: $reviewStartedAt, reviewCompletedAt: $reviewCompletedAt, reviewNote: $reviewNote, approverId: $approverId, approverName: $approverName, approvedAt: $approvedAt, publishedAt: $publishedAt, publishedPath: $publishedPath, environment: $environment, organizationId: $organizationId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DatasetModelCopyWith<$Res>  {
  factory $DatasetModelCopyWith(DatasetModel value, $Res Function(DatasetModel) _then) = _$DatasetModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description,@JsonKey(name: 'source_path') String sourcePath, Map<String, dynamic> metadata,@JsonKey(name: 'state') DatasetState state,@JsonKey(name: 'admin_decision') AdminDecision adminDecision,@JsonKey(name: 'rejection_reason') String? rejectionReason,@JsonKey(name: 'reviewer_id') String? reviewerId,@JsonKey(name: 'reviewer_name') String? reviewerName,@JsonKey(name: 'review_started_at') DateTime? reviewStartedAt,@JsonKey(name: 'review_completed_at') DateTime? reviewCompletedAt,@JsonKey(name: 'review_note') String? reviewNote,@JsonKey(name: 'approver_id') String? approverId,@JsonKey(name: 'approver_name') String? approverName,@JsonKey(name: 'approved_at') DateTime? approvedAt,@JsonKey(name: 'published_at') DateTime? publishedAt,@JsonKey(name: 'published_path') String? publishedPath,@JsonKey(name: 'environment') Environment environment,@JsonKey(name: 'organization_id') String? organizationId,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$DatasetModelCopyWithImpl<$Res>
    implements $DatasetModelCopyWith<$Res> {
  _$DatasetModelCopyWithImpl(this._self, this._then);

  final DatasetModel _self;
  final $Res Function(DatasetModel) _then;

/// Create a copy of DatasetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? sourcePath = null,Object? metadata = null,Object? state = null,Object? adminDecision = null,Object? rejectionReason = freezed,Object? reviewerId = freezed,Object? reviewerName = freezed,Object? reviewStartedAt = freezed,Object? reviewCompletedAt = freezed,Object? reviewNote = freezed,Object? approverId = freezed,Object? approverName = freezed,Object? approvedAt = freezed,Object? publishedAt = freezed,Object? publishedPath = freezed,Object? environment = null,Object? organizationId = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sourcePath: null == sourcePath ? _self.sourcePath : sourcePath // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as DatasetState,adminDecision: null == adminDecision ? _self.adminDecision : adminDecision // ignore: cast_nullable_to_non_nullable
as AdminDecision,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,reviewerId: freezed == reviewerId ? _self.reviewerId : reviewerId // ignore: cast_nullable_to_non_nullable
as String?,reviewerName: freezed == reviewerName ? _self.reviewerName : reviewerName // ignore: cast_nullable_to_non_nullable
as String?,reviewStartedAt: freezed == reviewStartedAt ? _self.reviewStartedAt : reviewStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewCompletedAt: freezed == reviewCompletedAt ? _self.reviewCompletedAt : reviewCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewNote: freezed == reviewNote ? _self.reviewNote : reviewNote // ignore: cast_nullable_to_non_nullable
as String?,approverId: freezed == approverId ? _self.approverId : approverId // ignore: cast_nullable_to_non_nullable
as String?,approverName: freezed == approverName ? _self.approverName : approverName // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedPath: freezed == publishedPath ? _self.publishedPath : publishedPath // ignore: cast_nullable_to_non_nullable
as String?,environment: null == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as Environment,organizationId: freezed == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DatasetModel].
extension DatasetModelPatterns on DatasetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DatasetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DatasetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DatasetModel value)  $default,){
final _that = this;
switch (_that) {
case _DatasetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DatasetModel value)?  $default,){
final _that = this;
switch (_that) {
case _DatasetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description, @JsonKey(name: 'source_path')  String sourcePath,  Map<String, dynamic> metadata, @JsonKey(name: 'state')  DatasetState state, @JsonKey(name: 'admin_decision')  AdminDecision adminDecision, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'reviewer_id')  String? reviewerId, @JsonKey(name: 'reviewer_name')  String? reviewerName, @JsonKey(name: 'review_started_at')  DateTime? reviewStartedAt, @JsonKey(name: 'review_completed_at')  DateTime? reviewCompletedAt, @JsonKey(name: 'review_note')  String? reviewNote, @JsonKey(name: 'approver_id')  String? approverId, @JsonKey(name: 'approver_name')  String? approverName, @JsonKey(name: 'approved_at')  DateTime? approvedAt, @JsonKey(name: 'published_at')  DateTime? publishedAt, @JsonKey(name: 'published_path')  String? publishedPath, @JsonKey(name: 'environment')  Environment environment, @JsonKey(name: 'organization_id')  String? organizationId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DatasetModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.sourcePath,_that.metadata,_that.state,_that.adminDecision,_that.rejectionReason,_that.reviewerId,_that.reviewerName,_that.reviewStartedAt,_that.reviewCompletedAt,_that.reviewNote,_that.approverId,_that.approverName,_that.approvedAt,_that.publishedAt,_that.publishedPath,_that.environment,_that.organizationId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description, @JsonKey(name: 'source_path')  String sourcePath,  Map<String, dynamic> metadata, @JsonKey(name: 'state')  DatasetState state, @JsonKey(name: 'admin_decision')  AdminDecision adminDecision, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'reviewer_id')  String? reviewerId, @JsonKey(name: 'reviewer_name')  String? reviewerName, @JsonKey(name: 'review_started_at')  DateTime? reviewStartedAt, @JsonKey(name: 'review_completed_at')  DateTime? reviewCompletedAt, @JsonKey(name: 'review_note')  String? reviewNote, @JsonKey(name: 'approver_id')  String? approverId, @JsonKey(name: 'approver_name')  String? approverName, @JsonKey(name: 'approved_at')  DateTime? approvedAt, @JsonKey(name: 'published_at')  DateTime? publishedAt, @JsonKey(name: 'published_path')  String? publishedPath, @JsonKey(name: 'environment')  Environment environment, @JsonKey(name: 'organization_id')  String? organizationId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DatasetModel():
return $default(_that.id,_that.name,_that.description,_that.sourcePath,_that.metadata,_that.state,_that.adminDecision,_that.rejectionReason,_that.reviewerId,_that.reviewerName,_that.reviewStartedAt,_that.reviewCompletedAt,_that.reviewNote,_that.approverId,_that.approverName,_that.approvedAt,_that.publishedAt,_that.publishedPath,_that.environment,_that.organizationId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description, @JsonKey(name: 'source_path')  String sourcePath,  Map<String, dynamic> metadata, @JsonKey(name: 'state')  DatasetState state, @JsonKey(name: 'admin_decision')  AdminDecision adminDecision, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'reviewer_id')  String? reviewerId, @JsonKey(name: 'reviewer_name')  String? reviewerName, @JsonKey(name: 'review_started_at')  DateTime? reviewStartedAt, @JsonKey(name: 'review_completed_at')  DateTime? reviewCompletedAt, @JsonKey(name: 'review_note')  String? reviewNote, @JsonKey(name: 'approver_id')  String? approverId, @JsonKey(name: 'approver_name')  String? approverName, @JsonKey(name: 'approved_at')  DateTime? approvedAt, @JsonKey(name: 'published_at')  DateTime? publishedAt, @JsonKey(name: 'published_path')  String? publishedPath, @JsonKey(name: 'environment')  Environment environment, @JsonKey(name: 'organization_id')  String? organizationId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DatasetModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.sourcePath,_that.metadata,_that.state,_that.adminDecision,_that.rejectionReason,_that.reviewerId,_that.reviewerName,_that.reviewStartedAt,_that.reviewCompletedAt,_that.reviewNote,_that.approverId,_that.approverName,_that.approvedAt,_that.publishedAt,_that.publishedPath,_that.environment,_that.organizationId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DatasetModel implements DatasetModel {
  const _DatasetModel({required this.id, required this.name, this.description, @JsonKey(name: 'source_path') required this.sourcePath, final  Map<String, dynamic> metadata = const {}, @JsonKey(name: 'state') this.state = DatasetState.s2Registered, @JsonKey(name: 'admin_decision') this.adminDecision = AdminDecision.pending, @JsonKey(name: 'rejection_reason') this.rejectionReason, @JsonKey(name: 'reviewer_id') this.reviewerId, @JsonKey(name: 'reviewer_name') this.reviewerName, @JsonKey(name: 'review_started_at') this.reviewStartedAt, @JsonKey(name: 'review_completed_at') this.reviewCompletedAt, @JsonKey(name: 'review_note') this.reviewNote, @JsonKey(name: 'approver_id') this.approverId, @JsonKey(name: 'approver_name') this.approverName, @JsonKey(name: 'approved_at') this.approvedAt, @JsonKey(name: 'published_at') this.publishedAt, @JsonKey(name: 'published_path') this.publishedPath, @JsonKey(name: 'environment') this.environment = Environment.production, @JsonKey(name: 'organization_id') this.organizationId, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _metadata = metadata;
  factory _DatasetModel.fromJson(Map<String, dynamic> json) => _$DatasetModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override@JsonKey(name: 'source_path') final  String sourcePath;
 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

// 워크플로우 상태
@override@JsonKey(name: 'state') final  DatasetState state;
@override@JsonKey(name: 'admin_decision') final  AdminDecision adminDecision;
@override@JsonKey(name: 'rejection_reason') final  String? rejectionReason;
// 리뷰어 정보
@override@JsonKey(name: 'reviewer_id') final  String? reviewerId;
@override@JsonKey(name: 'reviewer_name') final  String? reviewerName;
@override@JsonKey(name: 'review_started_at') final  DateTime? reviewStartedAt;
@override@JsonKey(name: 'review_completed_at') final  DateTime? reviewCompletedAt;
@override@JsonKey(name: 'review_note') final  String? reviewNote;
// 승인자 정보
@override@JsonKey(name: 'approver_id') final  String? approverId;
@override@JsonKey(name: 'approver_name') final  String? approverName;
@override@JsonKey(name: 'approved_at') final  DateTime? approvedAt;
// 퍼블리시 정보
@override@JsonKey(name: 'published_at') final  DateTime? publishedAt;
@override@JsonKey(name: 'published_path') final  String? publishedPath;
// 공통 필드
@override@JsonKey(name: 'environment') final  Environment environment;
@override@JsonKey(name: 'organization_id') final  String? organizationId;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of DatasetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatasetModelCopyWith<_DatasetModel> get copyWith => __$DatasetModelCopyWithImpl<_DatasetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DatasetModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DatasetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.sourcePath, sourcePath) || other.sourcePath == sourcePath)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.state, state) || other.state == state)&&(identical(other.adminDecision, adminDecision) || other.adminDecision == adminDecision)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.reviewerId, reviewerId) || other.reviewerId == reviewerId)&&(identical(other.reviewerName, reviewerName) || other.reviewerName == reviewerName)&&(identical(other.reviewStartedAt, reviewStartedAt) || other.reviewStartedAt == reviewStartedAt)&&(identical(other.reviewCompletedAt, reviewCompletedAt) || other.reviewCompletedAt == reviewCompletedAt)&&(identical(other.reviewNote, reviewNote) || other.reviewNote == reviewNote)&&(identical(other.approverId, approverId) || other.approverId == approverId)&&(identical(other.approverName, approverName) || other.approverName == approverName)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.publishedPath, publishedPath) || other.publishedPath == publishedPath)&&(identical(other.environment, environment) || other.environment == environment)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,sourcePath,const DeepCollectionEquality().hash(_metadata),state,adminDecision,rejectionReason,reviewerId,reviewerName,reviewStartedAt,reviewCompletedAt,reviewNote,approverId,approverName,approvedAt,publishedAt,publishedPath,environment,organizationId,createdAt,updatedAt]);

@override
String toString() {
  return 'DatasetModel(id: $id, name: $name, description: $description, sourcePath: $sourcePath, metadata: $metadata, state: $state, adminDecision: $adminDecision, rejectionReason: $rejectionReason, reviewerId: $reviewerId, reviewerName: $reviewerName, reviewStartedAt: $reviewStartedAt, reviewCompletedAt: $reviewCompletedAt, reviewNote: $reviewNote, approverId: $approverId, approverName: $approverName, approvedAt: $approvedAt, publishedAt: $publishedAt, publishedPath: $publishedPath, environment: $environment, organizationId: $organizationId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DatasetModelCopyWith<$Res> implements $DatasetModelCopyWith<$Res> {
  factory _$DatasetModelCopyWith(_DatasetModel value, $Res Function(_DatasetModel) _then) = __$DatasetModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description,@JsonKey(name: 'source_path') String sourcePath, Map<String, dynamic> metadata,@JsonKey(name: 'state') DatasetState state,@JsonKey(name: 'admin_decision') AdminDecision adminDecision,@JsonKey(name: 'rejection_reason') String? rejectionReason,@JsonKey(name: 'reviewer_id') String? reviewerId,@JsonKey(name: 'reviewer_name') String? reviewerName,@JsonKey(name: 'review_started_at') DateTime? reviewStartedAt,@JsonKey(name: 'review_completed_at') DateTime? reviewCompletedAt,@JsonKey(name: 'review_note') String? reviewNote,@JsonKey(name: 'approver_id') String? approverId,@JsonKey(name: 'approver_name') String? approverName,@JsonKey(name: 'approved_at') DateTime? approvedAt,@JsonKey(name: 'published_at') DateTime? publishedAt,@JsonKey(name: 'published_path') String? publishedPath,@JsonKey(name: 'environment') Environment environment,@JsonKey(name: 'organization_id') String? organizationId,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$DatasetModelCopyWithImpl<$Res>
    implements _$DatasetModelCopyWith<$Res> {
  __$DatasetModelCopyWithImpl(this._self, this._then);

  final _DatasetModel _self;
  final $Res Function(_DatasetModel) _then;

/// Create a copy of DatasetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? sourcePath = null,Object? metadata = null,Object? state = null,Object? adminDecision = null,Object? rejectionReason = freezed,Object? reviewerId = freezed,Object? reviewerName = freezed,Object? reviewStartedAt = freezed,Object? reviewCompletedAt = freezed,Object? reviewNote = freezed,Object? approverId = freezed,Object? approverName = freezed,Object? approvedAt = freezed,Object? publishedAt = freezed,Object? publishedPath = freezed,Object? environment = null,Object? organizationId = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_DatasetModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sourcePath: null == sourcePath ? _self.sourcePath : sourcePath // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as DatasetState,adminDecision: null == adminDecision ? _self.adminDecision : adminDecision // ignore: cast_nullable_to_non_nullable
as AdminDecision,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,reviewerId: freezed == reviewerId ? _self.reviewerId : reviewerId // ignore: cast_nullable_to_non_nullable
as String?,reviewerName: freezed == reviewerName ? _self.reviewerName : reviewerName // ignore: cast_nullable_to_non_nullable
as String?,reviewStartedAt: freezed == reviewStartedAt ? _self.reviewStartedAt : reviewStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewCompletedAt: freezed == reviewCompletedAt ? _self.reviewCompletedAt : reviewCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewNote: freezed == reviewNote ? _self.reviewNote : reviewNote // ignore: cast_nullable_to_non_nullable
as String?,approverId: freezed == approverId ? _self.approverId : approverId // ignore: cast_nullable_to_non_nullable
as String?,approverName: freezed == approverName ? _self.approverName : approverName // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedPath: freezed == publishedPath ? _self.publishedPath : publishedPath // ignore: cast_nullable_to_non_nullable
as String?,environment: null == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as Environment,organizationId: freezed == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
