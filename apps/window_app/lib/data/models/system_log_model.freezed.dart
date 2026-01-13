// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SystemLogModel {

 String get id; String get source; String? get description;@JsonKey(name: 'category') LogCategory get category;@JsonKey(name: 'code') String? get code;@JsonKey(name: 'log_level') LogLevel get logLevel;@JsonKey(name: 'environment') Environment get environment; Map<String, dynamic> get payload;@JsonKey(name: 'response_status', unknownEnumValue: ResponseStatus.unresponded) ResponseStatus get responseStatus;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'current_responder_id') String? get currentResponderId;@JsonKey(name: 'current_responder_name') String? get currentResponderName;@JsonKey(name: 'response_started_at') DateTime? get responseStartedAt;@JsonKey(name: 'organization_id') String? get organizationId;@JsonKey(name: 'assigned_by_id') String? get assignedById;@JsonKey(name: 'assigned_by_name') String? get assignedByName;@JsonKey(name: 'is_muted') bool? get isMuted;
/// Create a copy of SystemLogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SystemLogModelCopyWith<SystemLogModel> get copyWith => _$SystemLogModelCopyWithImpl<SystemLogModel>(this as SystemLogModel, _$identity);

  /// Serializes this SystemLogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SystemLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.code, code) || other.code == code)&&(identical(other.logLevel, logLevel) || other.logLevel == logLevel)&&(identical(other.environment, environment) || other.environment == environment)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.responseStatus, responseStatus) || other.responseStatus == responseStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.currentResponderId, currentResponderId) || other.currentResponderId == currentResponderId)&&(identical(other.currentResponderName, currentResponderName) || other.currentResponderName == currentResponderName)&&(identical(other.responseStartedAt, responseStartedAt) || other.responseStartedAt == responseStartedAt)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.assignedById, assignedById) || other.assignedById == assignedById)&&(identical(other.assignedByName, assignedByName) || other.assignedByName == assignedByName)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,description,category,code,logLevel,environment,const DeepCollectionEquality().hash(payload),responseStatus,createdAt,updatedAt,currentResponderId,currentResponderName,responseStartedAt,organizationId,assignedById,assignedByName,isMuted);

@override
String toString() {
  return 'SystemLogModel(id: $id, source: $source, description: $description, category: $category, code: $code, logLevel: $logLevel, environment: $environment, payload: $payload, responseStatus: $responseStatus, createdAt: $createdAt, updatedAt: $updatedAt, currentResponderId: $currentResponderId, currentResponderName: $currentResponderName, responseStartedAt: $responseStartedAt, organizationId: $organizationId, assignedById: $assignedById, assignedByName: $assignedByName, isMuted: $isMuted)';
}


}

/// @nodoc
abstract mixin class $SystemLogModelCopyWith<$Res>  {
  factory $SystemLogModelCopyWith(SystemLogModel value, $Res Function(SystemLogModel) _then) = _$SystemLogModelCopyWithImpl;
@useResult
$Res call({
 String id, String source, String? description,@JsonKey(name: 'category') LogCategory category,@JsonKey(name: 'code') String? code,@JsonKey(name: 'log_level') LogLevel logLevel,@JsonKey(name: 'environment') Environment environment, Map<String, dynamic> payload,@JsonKey(name: 'response_status', unknownEnumValue: ResponseStatus.unresponded) ResponseStatus responseStatus,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'current_responder_id') String? currentResponderId,@JsonKey(name: 'current_responder_name') String? currentResponderName,@JsonKey(name: 'response_started_at') DateTime? responseStartedAt,@JsonKey(name: 'organization_id') String? organizationId,@JsonKey(name: 'assigned_by_id') String? assignedById,@JsonKey(name: 'assigned_by_name') String? assignedByName,@JsonKey(name: 'is_muted') bool? isMuted
});




}
/// @nodoc
class _$SystemLogModelCopyWithImpl<$Res>
    implements $SystemLogModelCopyWith<$Res> {
  _$SystemLogModelCopyWithImpl(this._self, this._then);

  final SystemLogModel _self;
  final $Res Function(SystemLogModel) _then;

/// Create a copy of SystemLogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? description = freezed,Object? category = null,Object? code = freezed,Object? logLevel = null,Object? environment = null,Object? payload = null,Object? responseStatus = null,Object? createdAt = null,Object? updatedAt = freezed,Object? currentResponderId = freezed,Object? currentResponderName = freezed,Object? responseStartedAt = freezed,Object? organizationId = freezed,Object? assignedById = freezed,Object? assignedByName = freezed,Object? isMuted = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as LogCategory,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,logLevel: null == logLevel ? _self.logLevel : logLevel // ignore: cast_nullable_to_non_nullable
as LogLevel,environment: null == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as Environment,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,responseStatus: null == responseStatus ? _self.responseStatus : responseStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentResponderId: freezed == currentResponderId ? _self.currentResponderId : currentResponderId // ignore: cast_nullable_to_non_nullable
as String?,currentResponderName: freezed == currentResponderName ? _self.currentResponderName : currentResponderName // ignore: cast_nullable_to_non_nullable
as String?,responseStartedAt: freezed == responseStartedAt ? _self.responseStartedAt : responseStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,organizationId: freezed == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String?,assignedById: freezed == assignedById ? _self.assignedById : assignedById // ignore: cast_nullable_to_non_nullable
as String?,assignedByName: freezed == assignedByName ? _self.assignedByName : assignedByName // ignore: cast_nullable_to_non_nullable
as String?,isMuted: freezed == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [SystemLogModel].
extension SystemLogModelPatterns on SystemLogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SystemLogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SystemLogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SystemLogModel value)  $default,){
final _that = this;
switch (_that) {
case _SystemLogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SystemLogModel value)?  $default,){
final _that = this;
switch (_that) {
case _SystemLogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String source,  String? description, @JsonKey(name: 'category')  LogCategory category, @JsonKey(name: 'code')  String? code, @JsonKey(name: 'log_level')  LogLevel logLevel, @JsonKey(name: 'environment')  Environment environment,  Map<String, dynamic> payload, @JsonKey(name: 'response_status', unknownEnumValue: ResponseStatus.unresponded)  ResponseStatus responseStatus, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'current_responder_id')  String? currentResponderId, @JsonKey(name: 'current_responder_name')  String? currentResponderName, @JsonKey(name: 'response_started_at')  DateTime? responseStartedAt, @JsonKey(name: 'organization_id')  String? organizationId, @JsonKey(name: 'assigned_by_id')  String? assignedById, @JsonKey(name: 'assigned_by_name')  String? assignedByName, @JsonKey(name: 'is_muted')  bool? isMuted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SystemLogModel() when $default != null:
return $default(_that.id,_that.source,_that.description,_that.category,_that.code,_that.logLevel,_that.environment,_that.payload,_that.responseStatus,_that.createdAt,_that.updatedAt,_that.currentResponderId,_that.currentResponderName,_that.responseStartedAt,_that.organizationId,_that.assignedById,_that.assignedByName,_that.isMuted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String source,  String? description, @JsonKey(name: 'category')  LogCategory category, @JsonKey(name: 'code')  String? code, @JsonKey(name: 'log_level')  LogLevel logLevel, @JsonKey(name: 'environment')  Environment environment,  Map<String, dynamic> payload, @JsonKey(name: 'response_status', unknownEnumValue: ResponseStatus.unresponded)  ResponseStatus responseStatus, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'current_responder_id')  String? currentResponderId, @JsonKey(name: 'current_responder_name')  String? currentResponderName, @JsonKey(name: 'response_started_at')  DateTime? responseStartedAt, @JsonKey(name: 'organization_id')  String? organizationId, @JsonKey(name: 'assigned_by_id')  String? assignedById, @JsonKey(name: 'assigned_by_name')  String? assignedByName, @JsonKey(name: 'is_muted')  bool? isMuted)  $default,) {final _that = this;
switch (_that) {
case _SystemLogModel():
return $default(_that.id,_that.source,_that.description,_that.category,_that.code,_that.logLevel,_that.environment,_that.payload,_that.responseStatus,_that.createdAt,_that.updatedAt,_that.currentResponderId,_that.currentResponderName,_that.responseStartedAt,_that.organizationId,_that.assignedById,_that.assignedByName,_that.isMuted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String source,  String? description, @JsonKey(name: 'category')  LogCategory category, @JsonKey(name: 'code')  String? code, @JsonKey(name: 'log_level')  LogLevel logLevel, @JsonKey(name: 'environment')  Environment environment,  Map<String, dynamic> payload, @JsonKey(name: 'response_status', unknownEnumValue: ResponseStatus.unresponded)  ResponseStatus responseStatus, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'current_responder_id')  String? currentResponderId, @JsonKey(name: 'current_responder_name')  String? currentResponderName, @JsonKey(name: 'response_started_at')  DateTime? responseStartedAt, @JsonKey(name: 'organization_id')  String? organizationId, @JsonKey(name: 'assigned_by_id')  String? assignedById, @JsonKey(name: 'assigned_by_name')  String? assignedByName, @JsonKey(name: 'is_muted')  bool? isMuted)?  $default,) {final _that = this;
switch (_that) {
case _SystemLogModel() when $default != null:
return $default(_that.id,_that.source,_that.description,_that.category,_that.code,_that.logLevel,_that.environment,_that.payload,_that.responseStatus,_that.createdAt,_that.updatedAt,_that.currentResponderId,_that.currentResponderName,_that.responseStartedAt,_that.organizationId,_that.assignedById,_that.assignedByName,_that.isMuted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SystemLogModel implements SystemLogModel {
  const _SystemLogModel({required this.id, required this.source, this.description, @JsonKey(name: 'category') this.category = LogCategory.event, @JsonKey(name: 'code') this.code, @JsonKey(name: 'log_level') this.logLevel = LogLevel.info, @JsonKey(name: 'environment') this.environment = Environment.production, final  Map<String, dynamic> payload = const {}, @JsonKey(name: 'response_status', unknownEnumValue: ResponseStatus.unresponded) this.responseStatus = ResponseStatus.unresponded, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'current_responder_id') this.currentResponderId, @JsonKey(name: 'current_responder_name') this.currentResponderName, @JsonKey(name: 'response_started_at') this.responseStartedAt, @JsonKey(name: 'organization_id') this.organizationId, @JsonKey(name: 'assigned_by_id') this.assignedById, @JsonKey(name: 'assigned_by_name') this.assignedByName, @JsonKey(name: 'is_muted') this.isMuted}): _payload = payload;
  factory _SystemLogModel.fromJson(Map<String, dynamic> json) => _$SystemLogModelFromJson(json);

@override final  String id;
@override final  String source;
@override final  String? description;
@override@JsonKey(name: 'category') final  LogCategory category;
@override@JsonKey(name: 'code') final  String? code;
@override@JsonKey(name: 'log_level') final  LogLevel logLevel;
@override@JsonKey(name: 'environment') final  Environment environment;
 final  Map<String, dynamic> _payload;
@override@JsonKey() Map<String, dynamic> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}

@override@JsonKey(name: 'response_status', unknownEnumValue: ResponseStatus.unresponded) final  ResponseStatus responseStatus;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(name: 'current_responder_id') final  String? currentResponderId;
@override@JsonKey(name: 'current_responder_name') final  String? currentResponderName;
@override@JsonKey(name: 'response_started_at') final  DateTime? responseStartedAt;
@override@JsonKey(name: 'organization_id') final  String? organizationId;
@override@JsonKey(name: 'assigned_by_id') final  String? assignedById;
@override@JsonKey(name: 'assigned_by_name') final  String? assignedByName;
@override@JsonKey(name: 'is_muted') final  bool? isMuted;

/// Create a copy of SystemLogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SystemLogModelCopyWith<_SystemLogModel> get copyWith => __$SystemLogModelCopyWithImpl<_SystemLogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SystemLogModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SystemLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.code, code) || other.code == code)&&(identical(other.logLevel, logLevel) || other.logLevel == logLevel)&&(identical(other.environment, environment) || other.environment == environment)&&const DeepCollectionEquality().equals(other._payload, _payload)&&(identical(other.responseStatus, responseStatus) || other.responseStatus == responseStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.currentResponderId, currentResponderId) || other.currentResponderId == currentResponderId)&&(identical(other.currentResponderName, currentResponderName) || other.currentResponderName == currentResponderName)&&(identical(other.responseStartedAt, responseStartedAt) || other.responseStartedAt == responseStartedAt)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.assignedById, assignedById) || other.assignedById == assignedById)&&(identical(other.assignedByName, assignedByName) || other.assignedByName == assignedByName)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,description,category,code,logLevel,environment,const DeepCollectionEquality().hash(_payload),responseStatus,createdAt,updatedAt,currentResponderId,currentResponderName,responseStartedAt,organizationId,assignedById,assignedByName,isMuted);

@override
String toString() {
  return 'SystemLogModel(id: $id, source: $source, description: $description, category: $category, code: $code, logLevel: $logLevel, environment: $environment, payload: $payload, responseStatus: $responseStatus, createdAt: $createdAt, updatedAt: $updatedAt, currentResponderId: $currentResponderId, currentResponderName: $currentResponderName, responseStartedAt: $responseStartedAt, organizationId: $organizationId, assignedById: $assignedById, assignedByName: $assignedByName, isMuted: $isMuted)';
}


}

/// @nodoc
abstract mixin class _$SystemLogModelCopyWith<$Res> implements $SystemLogModelCopyWith<$Res> {
  factory _$SystemLogModelCopyWith(_SystemLogModel value, $Res Function(_SystemLogModel) _then) = __$SystemLogModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String source, String? description,@JsonKey(name: 'category') LogCategory category,@JsonKey(name: 'code') String? code,@JsonKey(name: 'log_level') LogLevel logLevel,@JsonKey(name: 'environment') Environment environment, Map<String, dynamic> payload,@JsonKey(name: 'response_status', unknownEnumValue: ResponseStatus.unresponded) ResponseStatus responseStatus,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'current_responder_id') String? currentResponderId,@JsonKey(name: 'current_responder_name') String? currentResponderName,@JsonKey(name: 'response_started_at') DateTime? responseStartedAt,@JsonKey(name: 'organization_id') String? organizationId,@JsonKey(name: 'assigned_by_id') String? assignedById,@JsonKey(name: 'assigned_by_name') String? assignedByName,@JsonKey(name: 'is_muted') bool? isMuted
});




}
/// @nodoc
class __$SystemLogModelCopyWithImpl<$Res>
    implements _$SystemLogModelCopyWith<$Res> {
  __$SystemLogModelCopyWithImpl(this._self, this._then);

  final _SystemLogModel _self;
  final $Res Function(_SystemLogModel) _then;

/// Create a copy of SystemLogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? description = freezed,Object? category = null,Object? code = freezed,Object? logLevel = null,Object? environment = null,Object? payload = null,Object? responseStatus = null,Object? createdAt = null,Object? updatedAt = freezed,Object? currentResponderId = freezed,Object? currentResponderName = freezed,Object? responseStartedAt = freezed,Object? organizationId = freezed,Object? assignedById = freezed,Object? assignedByName = freezed,Object? isMuted = freezed,}) {
  return _then(_SystemLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as LogCategory,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,logLevel: null == logLevel ? _self.logLevel : logLevel // ignore: cast_nullable_to_non_nullable
as LogLevel,environment: null == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as Environment,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,responseStatus: null == responseStatus ? _self.responseStatus : responseStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentResponderId: freezed == currentResponderId ? _self.currentResponderId : currentResponderId // ignore: cast_nullable_to_non_nullable
as String?,currentResponderName: freezed == currentResponderName ? _self.currentResponderName : currentResponderName // ignore: cast_nullable_to_non_nullable
as String?,responseStartedAt: freezed == responseStartedAt ? _self.responseStartedAt : responseStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,organizationId: freezed == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String?,assignedById: freezed == assignedById ? _self.assignedById : assignedById // ignore: cast_nullable_to_non_nullable
as String?,assignedByName: freezed == assignedByName ? _self.assignedByName : assignedByName // ignore: cast_nullable_to_non_nullable
as String?,isMuted: freezed == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
