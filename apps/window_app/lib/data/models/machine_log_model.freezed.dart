// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'machine_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MachineLogModel {

 String get id;@JsonKey(name: 'ip_address') String get ipAddress;@JsonKey(name: 'port_number') int get portNumber;@JsonKey(name: 'status_code') int get statusCode;@JsonKey(name: 'response_status') String get responseStatus;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of MachineLogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MachineLogModelCopyWith<MachineLogModel> get copyWith => _$MachineLogModelCopyWithImpl<MachineLogModel>(this as MachineLogModel, _$identity);

  /// Serializes this MachineLogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MachineLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.portNumber, portNumber) || other.portNumber == portNumber)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.responseStatus, responseStatus) || other.responseStatus == responseStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ipAddress,portNumber,statusCode,responseStatus,createdAt);

@override
String toString() {
  return 'MachineLogModel(id: $id, ipAddress: $ipAddress, portNumber: $portNumber, statusCode: $statusCode, responseStatus: $responseStatus, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MachineLogModelCopyWith<$Res>  {
  factory $MachineLogModelCopyWith(MachineLogModel value, $Res Function(MachineLogModel) _then) = _$MachineLogModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'ip_address') String ipAddress,@JsonKey(name: 'port_number') int portNumber,@JsonKey(name: 'status_code') int statusCode,@JsonKey(name: 'response_status') String responseStatus,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$MachineLogModelCopyWithImpl<$Res>
    implements $MachineLogModelCopyWith<$Res> {
  _$MachineLogModelCopyWithImpl(this._self, this._then);

  final MachineLogModel _self;
  final $Res Function(MachineLogModel) _then;

/// Create a copy of MachineLogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ipAddress = null,Object? portNumber = null,Object? statusCode = null,Object? responseStatus = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ipAddress: null == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String,portNumber: null == portNumber ? _self.portNumber : portNumber // ignore: cast_nullable_to_non_nullable
as int,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,responseStatus: null == responseStatus ? _self.responseStatus : responseStatus // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MachineLogModel].
extension MachineLogModelPatterns on MachineLogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MachineLogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MachineLogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MachineLogModel value)  $default,){
final _that = this;
switch (_that) {
case _MachineLogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MachineLogModel value)?  $default,){
final _that = this;
switch (_that) {
case _MachineLogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'ip_address')  String ipAddress, @JsonKey(name: 'port_number')  int portNumber, @JsonKey(name: 'status_code')  int statusCode, @JsonKey(name: 'response_status')  String responseStatus, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MachineLogModel() when $default != null:
return $default(_that.id,_that.ipAddress,_that.portNumber,_that.statusCode,_that.responseStatus,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'ip_address')  String ipAddress, @JsonKey(name: 'port_number')  int portNumber, @JsonKey(name: 'status_code')  int statusCode, @JsonKey(name: 'response_status')  String responseStatus, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _MachineLogModel():
return $default(_that.id,_that.ipAddress,_that.portNumber,_that.statusCode,_that.responseStatus,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'ip_address')  String ipAddress, @JsonKey(name: 'port_number')  int portNumber, @JsonKey(name: 'status_code')  int statusCode, @JsonKey(name: 'response_status')  String responseStatus, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MachineLogModel() when $default != null:
return $default(_that.id,_that.ipAddress,_that.portNumber,_that.statusCode,_that.responseStatus,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MachineLogModel implements MachineLogModel {
  const _MachineLogModel({required this.id, @JsonKey(name: 'ip_address') required this.ipAddress, @JsonKey(name: 'port_number') required this.portNumber, @JsonKey(name: 'status_code') required this.statusCode, @JsonKey(name: 'response_status') required this.responseStatus, @JsonKey(name: 'created_at') required this.createdAt});
  factory _MachineLogModel.fromJson(Map<String, dynamic> json) => _$MachineLogModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'ip_address') final  String ipAddress;
@override@JsonKey(name: 'port_number') final  int portNumber;
@override@JsonKey(name: 'status_code') final  int statusCode;
@override@JsonKey(name: 'response_status') final  String responseStatus;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of MachineLogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MachineLogModelCopyWith<_MachineLogModel> get copyWith => __$MachineLogModelCopyWithImpl<_MachineLogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MachineLogModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MachineLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.portNumber, portNumber) || other.portNumber == portNumber)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.responseStatus, responseStatus) || other.responseStatus == responseStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ipAddress,portNumber,statusCode,responseStatus,createdAt);

@override
String toString() {
  return 'MachineLogModel(id: $id, ipAddress: $ipAddress, portNumber: $portNumber, statusCode: $statusCode, responseStatus: $responseStatus, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MachineLogModelCopyWith<$Res> implements $MachineLogModelCopyWith<$Res> {
  factory _$MachineLogModelCopyWith(_MachineLogModel value, $Res Function(_MachineLogModel) _then) = __$MachineLogModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'ip_address') String ipAddress,@JsonKey(name: 'port_number') int portNumber,@JsonKey(name: 'status_code') int statusCode,@JsonKey(name: 'response_status') String responseStatus,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$MachineLogModelCopyWithImpl<$Res>
    implements _$MachineLogModelCopyWith<$Res> {
  __$MachineLogModelCopyWithImpl(this._self, this._then);

  final _MachineLogModel _self;
  final $Res Function(_MachineLogModel) _then;

/// Create a copy of MachineLogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ipAddress = null,Object? portNumber = null,Object? statusCode = null,Object? responseStatus = null,Object? createdAt = null,}) {
  return _then(_MachineLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ipAddress: null == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String,portNumber: null == portNumber ? _self.portNumber : portNumber // ignore: cast_nullable_to_non_nullable
as int,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,responseStatus: null == responseStatus ? _self.responseStatus : responseStatus // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
