// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_updater_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppUpdateState {

 bool get isChecking; bool get updateAvailable; bool get isDownloading; bool get isDownloaded; double get downloadProgress; String? get newVersion; String? get currentVersion; String? get errorMessage;
/// Create a copy of AppUpdateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUpdateStateCopyWith<AppUpdateState> get copyWith => _$AppUpdateStateCopyWithImpl<AppUpdateState>(this as AppUpdateState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdateState&&(identical(other.isChecking, isChecking) || other.isChecking == isChecking)&&(identical(other.updateAvailable, updateAvailable) || other.updateAvailable == updateAvailable)&&(identical(other.isDownloading, isDownloading) || other.isDownloading == isDownloading)&&(identical(other.isDownloaded, isDownloaded) || other.isDownloaded == isDownloaded)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress)&&(identical(other.newVersion, newVersion) || other.newVersion == newVersion)&&(identical(other.currentVersion, currentVersion) || other.currentVersion == currentVersion)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isChecking,updateAvailable,isDownloading,isDownloaded,downloadProgress,newVersion,currentVersion,errorMessage);

@override
String toString() {
  return 'AppUpdateState(isChecking: $isChecking, updateAvailable: $updateAvailable, isDownloading: $isDownloading, isDownloaded: $isDownloaded, downloadProgress: $downloadProgress, newVersion: $newVersion, currentVersion: $currentVersion, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AppUpdateStateCopyWith<$Res>  {
  factory $AppUpdateStateCopyWith(AppUpdateState value, $Res Function(AppUpdateState) _then) = _$AppUpdateStateCopyWithImpl;
@useResult
$Res call({
 bool isChecking, bool updateAvailable, bool isDownloading, bool isDownloaded, double downloadProgress, String? newVersion, String? currentVersion, String? errorMessage
});




}
/// @nodoc
class _$AppUpdateStateCopyWithImpl<$Res>
    implements $AppUpdateStateCopyWith<$Res> {
  _$AppUpdateStateCopyWithImpl(this._self, this._then);

  final AppUpdateState _self;
  final $Res Function(AppUpdateState) _then;

/// Create a copy of AppUpdateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isChecking = null,Object? updateAvailable = null,Object? isDownloading = null,Object? isDownloaded = null,Object? downloadProgress = null,Object? newVersion = freezed,Object? currentVersion = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isChecking: null == isChecking ? _self.isChecking : isChecking // ignore: cast_nullable_to_non_nullable
as bool,updateAvailable: null == updateAvailable ? _self.updateAvailable : updateAvailable // ignore: cast_nullable_to_non_nullable
as bool,isDownloading: null == isDownloading ? _self.isDownloading : isDownloading // ignore: cast_nullable_to_non_nullable
as bool,isDownloaded: null == isDownloaded ? _self.isDownloaded : isDownloaded // ignore: cast_nullable_to_non_nullable
as bool,downloadProgress: null == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as double,newVersion: freezed == newVersion ? _self.newVersion : newVersion // ignore: cast_nullable_to_non_nullable
as String?,currentVersion: freezed == currentVersion ? _self.currentVersion : currentVersion // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUpdateState].
extension AppUpdateStatePatterns on AppUpdateState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUpdateState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUpdateState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUpdateState value)  $default,){
final _that = this;
switch (_that) {
case _AppUpdateState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUpdateState value)?  $default,){
final _that = this;
switch (_that) {
case _AppUpdateState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isChecking,  bool updateAvailable,  bool isDownloading,  bool isDownloaded,  double downloadProgress,  String? newVersion,  String? currentVersion,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUpdateState() when $default != null:
return $default(_that.isChecking,_that.updateAvailable,_that.isDownloading,_that.isDownloaded,_that.downloadProgress,_that.newVersion,_that.currentVersion,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isChecking,  bool updateAvailable,  bool isDownloading,  bool isDownloaded,  double downloadProgress,  String? newVersion,  String? currentVersion,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _AppUpdateState():
return $default(_that.isChecking,_that.updateAvailable,_that.isDownloading,_that.isDownloaded,_that.downloadProgress,_that.newVersion,_that.currentVersion,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isChecking,  bool updateAvailable,  bool isDownloading,  bool isDownloaded,  double downloadProgress,  String? newVersion,  String? currentVersion,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _AppUpdateState() when $default != null:
return $default(_that.isChecking,_that.updateAvailable,_that.isDownloading,_that.isDownloaded,_that.downloadProgress,_that.newVersion,_that.currentVersion,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AppUpdateState implements AppUpdateState {
  const _AppUpdateState({this.isChecking = false, this.updateAvailable = false, this.isDownloading = false, this.isDownloaded = false, this.downloadProgress = 0.0, this.newVersion, this.currentVersion, this.errorMessage});
  

@override@JsonKey() final  bool isChecking;
@override@JsonKey() final  bool updateAvailable;
@override@JsonKey() final  bool isDownloading;
@override@JsonKey() final  bool isDownloaded;
@override@JsonKey() final  double downloadProgress;
@override final  String? newVersion;
@override final  String? currentVersion;
@override final  String? errorMessage;

/// Create a copy of AppUpdateState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUpdateStateCopyWith<_AppUpdateState> get copyWith => __$AppUpdateStateCopyWithImpl<_AppUpdateState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUpdateState&&(identical(other.isChecking, isChecking) || other.isChecking == isChecking)&&(identical(other.updateAvailable, updateAvailable) || other.updateAvailable == updateAvailable)&&(identical(other.isDownloading, isDownloading) || other.isDownloading == isDownloading)&&(identical(other.isDownloaded, isDownloaded) || other.isDownloaded == isDownloaded)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress)&&(identical(other.newVersion, newVersion) || other.newVersion == newVersion)&&(identical(other.currentVersion, currentVersion) || other.currentVersion == currentVersion)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isChecking,updateAvailable,isDownloading,isDownloaded,downloadProgress,newVersion,currentVersion,errorMessage);

@override
String toString() {
  return 'AppUpdateState(isChecking: $isChecking, updateAvailable: $updateAvailable, isDownloading: $isDownloading, isDownloaded: $isDownloaded, downloadProgress: $downloadProgress, newVersion: $newVersion, currentVersion: $currentVersion, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$AppUpdateStateCopyWith<$Res> implements $AppUpdateStateCopyWith<$Res> {
  factory _$AppUpdateStateCopyWith(_AppUpdateState value, $Res Function(_AppUpdateState) _then) = __$AppUpdateStateCopyWithImpl;
@override @useResult
$Res call({
 bool isChecking, bool updateAvailable, bool isDownloading, bool isDownloaded, double downloadProgress, String? newVersion, String? currentVersion, String? errorMessage
});




}
/// @nodoc
class __$AppUpdateStateCopyWithImpl<$Res>
    implements _$AppUpdateStateCopyWith<$Res> {
  __$AppUpdateStateCopyWithImpl(this._self, this._then);

  final _AppUpdateState _self;
  final $Res Function(_AppUpdateState) _then;

/// Create a copy of AppUpdateState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isChecking = null,Object? updateAvailable = null,Object? isDownloading = null,Object? isDownloaded = null,Object? downloadProgress = null,Object? newVersion = freezed,Object? currentVersion = freezed,Object? errorMessage = freezed,}) {
  return _then(_AppUpdateState(
isChecking: null == isChecking ? _self.isChecking : isChecking // ignore: cast_nullable_to_non_nullable
as bool,updateAvailable: null == updateAvailable ? _self.updateAvailable : updateAvailable // ignore: cast_nullable_to_non_nullable
as bool,isDownloading: null == isDownloading ? _self.isDownloading : isDownloading // ignore: cast_nullable_to_non_nullable
as bool,isDownloaded: null == isDownloaded ? _self.isDownloaded : isDownloaded // ignore: cast_nullable_to_non_nullable
as bool,downloadProgress: null == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as double,newVersion: freezed == newVersion ? _self.newVersion : newVersion // ignore: cast_nullable_to_non_nullable
as String?,currentVersion: freezed == currentVersion ? _self.currentVersion : currentVersion // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
