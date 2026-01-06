// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventLogModel {

 String get id; String get source;@JsonKey(name: 'event_type') EventType get eventType;@JsonKey(name: 'error_code') String? get errorCode;@JsonKey(name: 'log_level') LogLevel get logLevel; Map<String, dynamic> get payload;@JsonKey(name: 'response_status') ResponseStatus get responseStatus;@JsonKey(name: 'created_at') DateTime get createdAt;// 대응자 정보
@JsonKey(name: 'current_responder_id') String? get currentResponderId;@JsonKey(name: 'current_responder_name') String? get currentResponderName;@JsonKey(name: 'response_started_at') DateTime? get responseStartedAt;
/// Create a copy of EventLogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventLogModelCopyWith<EventLogModel> get copyWith => _$EventLogModelCopyWithImpl<EventLogModel>(this as EventLogModel, _$identity);

  /// Serializes this EventLogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.logLevel, logLevel) || other.logLevel == logLevel)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.responseStatus, responseStatus) || other.responseStatus == responseStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.currentResponderId, currentResponderId) || other.currentResponderId == currentResponderId)&&(identical(other.currentResponderName, currentResponderName) || other.currentResponderName == currentResponderName)&&(identical(other.responseStartedAt, responseStartedAt) || other.responseStartedAt == responseStartedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,eventType,errorCode,logLevel,const DeepCollectionEquality().hash(payload),responseStatus,createdAt,currentResponderId,currentResponderName,responseStartedAt);

@override
String toString() {
  return 'EventLogModel(id: $id, source: $source, eventType: $eventType, errorCode: $errorCode, logLevel: $logLevel, payload: $payload, responseStatus: $responseStatus, createdAt: $createdAt, currentResponderId: $currentResponderId, currentResponderName: $currentResponderName, responseStartedAt: $responseStartedAt)';
}


}

/// @nodoc
abstract mixin class $EventLogModelCopyWith<$Res>  {
  factory $EventLogModelCopyWith(EventLogModel value, $Res Function(EventLogModel) _then) = _$EventLogModelCopyWithImpl;
@useResult
$Res call({
 String id, String source,@JsonKey(name: 'event_type') EventType eventType,@JsonKey(name: 'error_code') String? errorCode,@JsonKey(name: 'log_level') LogLevel logLevel, Map<String, dynamic> payload,@JsonKey(name: 'response_status') ResponseStatus responseStatus,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'current_responder_id') String? currentResponderId,@JsonKey(name: 'current_responder_name') String? currentResponderName,@JsonKey(name: 'response_started_at') DateTime? responseStartedAt
});




}
/// @nodoc
class _$EventLogModelCopyWithImpl<$Res>
    implements $EventLogModelCopyWith<$Res> {
  _$EventLogModelCopyWithImpl(this._self, this._then);

  final EventLogModel _self;
  final $Res Function(EventLogModel) _then;

/// Create a copy of EventLogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? eventType = null,Object? errorCode = freezed,Object? logLevel = null,Object? payload = null,Object? responseStatus = null,Object? createdAt = null,Object? currentResponderId = freezed,Object? currentResponderName = freezed,Object? responseStartedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as EventType,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,logLevel: null == logLevel ? _self.logLevel : logLevel // ignore: cast_nullable_to_non_nullable
as LogLevel,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,responseStatus: null == responseStatus ? _self.responseStatus : responseStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,currentResponderId: freezed == currentResponderId ? _self.currentResponderId : currentResponderId // ignore: cast_nullable_to_non_nullable
as String?,currentResponderName: freezed == currentResponderName ? _self.currentResponderName : currentResponderName // ignore: cast_nullable_to_non_nullable
as String?,responseStartedAt: freezed == responseStartedAt ? _self.responseStartedAt : responseStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventLogModel].
extension EventLogModelPatterns on EventLogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventLogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventLogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventLogModel value)  $default,){
final _that = this;
switch (_that) {
case _EventLogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventLogModel value)?  $default,){
final _that = this;
switch (_that) {
case _EventLogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String source, @JsonKey(name: 'event_type')  EventType eventType, @JsonKey(name: 'error_code')  String? errorCode, @JsonKey(name: 'log_level')  LogLevel logLevel,  Map<String, dynamic> payload, @JsonKey(name: 'response_status')  ResponseStatus responseStatus, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'current_responder_id')  String? currentResponderId, @JsonKey(name: 'current_responder_name')  String? currentResponderName, @JsonKey(name: 'response_started_at')  DateTime? responseStartedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventLogModel() when $default != null:
return $default(_that.id,_that.source,_that.eventType,_that.errorCode,_that.logLevel,_that.payload,_that.responseStatus,_that.createdAt,_that.currentResponderId,_that.currentResponderName,_that.responseStartedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String source, @JsonKey(name: 'event_type')  EventType eventType, @JsonKey(name: 'error_code')  String? errorCode, @JsonKey(name: 'log_level')  LogLevel logLevel,  Map<String, dynamic> payload, @JsonKey(name: 'response_status')  ResponseStatus responseStatus, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'current_responder_id')  String? currentResponderId, @JsonKey(name: 'current_responder_name')  String? currentResponderName, @JsonKey(name: 'response_started_at')  DateTime? responseStartedAt)  $default,) {final _that = this;
switch (_that) {
case _EventLogModel():
return $default(_that.id,_that.source,_that.eventType,_that.errorCode,_that.logLevel,_that.payload,_that.responseStatus,_that.createdAt,_that.currentResponderId,_that.currentResponderName,_that.responseStartedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String source, @JsonKey(name: 'event_type')  EventType eventType, @JsonKey(name: 'error_code')  String? errorCode, @JsonKey(name: 'log_level')  LogLevel logLevel,  Map<String, dynamic> payload, @JsonKey(name: 'response_status')  ResponseStatus responseStatus, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'current_responder_id')  String? currentResponderId, @JsonKey(name: 'current_responder_name')  String? currentResponderName, @JsonKey(name: 'response_started_at')  DateTime? responseStartedAt)?  $default,) {final _that = this;
switch (_that) {
case _EventLogModel() when $default != null:
return $default(_that.id,_that.source,_that.eventType,_that.errorCode,_that.logLevel,_that.payload,_that.responseStatus,_that.createdAt,_that.currentResponderId,_that.currentResponderName,_that.responseStartedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventLogModel extends EventLogModel {
  const _EventLogModel({required this.id, required this.source, @JsonKey(name: 'event_type') this.eventType = EventType.event, @JsonKey(name: 'error_code') this.errorCode, @JsonKey(name: 'log_level') this.logLevel = LogLevel.info, final  Map<String, dynamic> payload = const {}, @JsonKey(name: 'response_status') this.responseStatus = ResponseStatus.unchecked, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'current_responder_id') this.currentResponderId, @JsonKey(name: 'current_responder_name') this.currentResponderName, @JsonKey(name: 'response_started_at') this.responseStartedAt}): _payload = payload,super._();
  factory _EventLogModel.fromJson(Map<String, dynamic> json) => _$EventLogModelFromJson(json);

@override final  String id;
@override final  String source;
@override@JsonKey(name: 'event_type') final  EventType eventType;
@override@JsonKey(name: 'error_code') final  String? errorCode;
@override@JsonKey(name: 'log_level') final  LogLevel logLevel;
 final  Map<String, dynamic> _payload;
@override@JsonKey() Map<String, dynamic> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}

@override@JsonKey(name: 'response_status') final  ResponseStatus responseStatus;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
// 대응자 정보
@override@JsonKey(name: 'current_responder_id') final  String? currentResponderId;
@override@JsonKey(name: 'current_responder_name') final  String? currentResponderName;
@override@JsonKey(name: 'response_started_at') final  DateTime? responseStartedAt;

/// Create a copy of EventLogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventLogModelCopyWith<_EventLogModel> get copyWith => __$EventLogModelCopyWithImpl<_EventLogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventLogModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.logLevel, logLevel) || other.logLevel == logLevel)&&const DeepCollectionEquality().equals(other._payload, _payload)&&(identical(other.responseStatus, responseStatus) || other.responseStatus == responseStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.currentResponderId, currentResponderId) || other.currentResponderId == currentResponderId)&&(identical(other.currentResponderName, currentResponderName) || other.currentResponderName == currentResponderName)&&(identical(other.responseStartedAt, responseStartedAt) || other.responseStartedAt == responseStartedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,eventType,errorCode,logLevel,const DeepCollectionEquality().hash(_payload),responseStatus,createdAt,currentResponderId,currentResponderName,responseStartedAt);

@override
String toString() {
  return 'EventLogModel(id: $id, source: $source, eventType: $eventType, errorCode: $errorCode, logLevel: $logLevel, payload: $payload, responseStatus: $responseStatus, createdAt: $createdAt, currentResponderId: $currentResponderId, currentResponderName: $currentResponderName, responseStartedAt: $responseStartedAt)';
}


}

/// @nodoc
abstract mixin class _$EventLogModelCopyWith<$Res> implements $EventLogModelCopyWith<$Res> {
  factory _$EventLogModelCopyWith(_EventLogModel value, $Res Function(_EventLogModel) _then) = __$EventLogModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String source,@JsonKey(name: 'event_type') EventType eventType,@JsonKey(name: 'error_code') String? errorCode,@JsonKey(name: 'log_level') LogLevel logLevel, Map<String, dynamic> payload,@JsonKey(name: 'response_status') ResponseStatus responseStatus,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'current_responder_id') String? currentResponderId,@JsonKey(name: 'current_responder_name') String? currentResponderName,@JsonKey(name: 'response_started_at') DateTime? responseStartedAt
});




}
/// @nodoc
class __$EventLogModelCopyWithImpl<$Res>
    implements _$EventLogModelCopyWith<$Res> {
  __$EventLogModelCopyWithImpl(this._self, this._then);

  final _EventLogModel _self;
  final $Res Function(_EventLogModel) _then;

/// Create a copy of EventLogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? eventType = null,Object? errorCode = freezed,Object? logLevel = null,Object? payload = null,Object? responseStatus = null,Object? createdAt = null,Object? currentResponderId = freezed,Object? currentResponderName = freezed,Object? responseStartedAt = freezed,}) {
  return _then(_EventLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as EventType,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,logLevel: null == logLevel ? _self.logLevel : logLevel // ignore: cast_nullable_to_non_nullable
as LogLevel,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,responseStatus: null == responseStatus ? _self.responseStatus : responseStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,currentResponderId: freezed == currentResponderId ? _self.currentResponderId : currentResponderId // ignore: cast_nullable_to_non_nullable
as String?,currentResponderName: freezed == currentResponderName ? _self.currentResponderName : currentResponderName // ignore: cast_nullable_to_non_nullable
as String?,responseStartedAt: freezed == responseStartedAt ? _self.responseStartedAt : responseStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
