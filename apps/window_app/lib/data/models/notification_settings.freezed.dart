// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationSettings {

/// warning 레벨 알림 동작
 NotificationAction get warningAction;/// error 레벨 알림 동작
 NotificationAction get errorAction;/// critical 레벨 알림 동작
 NotificationAction get criticalAction;/// 헬스체크 알림 표시 여부
 bool get showHealthCheck;
/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSettingsCopyWith<NotificationSettings> get copyWith => _$NotificationSettingsCopyWithImpl<NotificationSettings>(this as NotificationSettings, _$identity);

  /// Serializes this NotificationSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSettings&&(identical(other.warningAction, warningAction) || other.warningAction == warningAction)&&(identical(other.errorAction, errorAction) || other.errorAction == errorAction)&&(identical(other.criticalAction, criticalAction) || other.criticalAction == criticalAction)&&(identical(other.showHealthCheck, showHealthCheck) || other.showHealthCheck == showHealthCheck));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,warningAction,errorAction,criticalAction,showHealthCheck);

@override
String toString() {
  return 'NotificationSettings(warningAction: $warningAction, errorAction: $errorAction, criticalAction: $criticalAction, showHealthCheck: $showHealthCheck)';
}


}

/// @nodoc
abstract mixin class $NotificationSettingsCopyWith<$Res>  {
  factory $NotificationSettingsCopyWith(NotificationSettings value, $Res Function(NotificationSettings) _then) = _$NotificationSettingsCopyWithImpl;
@useResult
$Res call({
 NotificationAction warningAction, NotificationAction errorAction, NotificationAction criticalAction, bool showHealthCheck
});




}
/// @nodoc
class _$NotificationSettingsCopyWithImpl<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._self, this._then);

  final NotificationSettings _self;
  final $Res Function(NotificationSettings) _then;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? warningAction = null,Object? errorAction = null,Object? criticalAction = null,Object? showHealthCheck = null,}) {
  return _then(_self.copyWith(
warningAction: null == warningAction ? _self.warningAction : warningAction // ignore: cast_nullable_to_non_nullable
as NotificationAction,errorAction: null == errorAction ? _self.errorAction : errorAction // ignore: cast_nullable_to_non_nullable
as NotificationAction,criticalAction: null == criticalAction ? _self.criticalAction : criticalAction // ignore: cast_nullable_to_non_nullable
as NotificationAction,showHealthCheck: null == showHealthCheck ? _self.showHealthCheck : showHealthCheck // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationSettings].
extension NotificationSettingsPatterns on NotificationSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSettings value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSettings value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NotificationAction warningAction,  NotificationAction errorAction,  NotificationAction criticalAction,  bool showHealthCheck)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
return $default(_that.warningAction,_that.errorAction,_that.criticalAction,_that.showHealthCheck);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NotificationAction warningAction,  NotificationAction errorAction,  NotificationAction criticalAction,  bool showHealthCheck)  $default,) {final _that = this;
switch (_that) {
case _NotificationSettings():
return $default(_that.warningAction,_that.errorAction,_that.criticalAction,_that.showHealthCheck);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NotificationAction warningAction,  NotificationAction errorAction,  NotificationAction criticalAction,  bool showHealthCheck)?  $default,) {final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
return $default(_that.warningAction,_that.errorAction,_that.criticalAction,_that.showHealthCheck);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationSettings extends NotificationSettings {
  const _NotificationSettings({this.warningAction = NotificationAction.trayOnly, this.errorAction = NotificationAction.foreground, this.criticalAction = NotificationAction.alwaysOnTop, this.showHealthCheck = false}): super._();
  factory _NotificationSettings.fromJson(Map<String, dynamic> json) => _$NotificationSettingsFromJson(json);

/// warning 레벨 알림 동작
@override@JsonKey() final  NotificationAction warningAction;
/// error 레벨 알림 동작
@override@JsonKey() final  NotificationAction errorAction;
/// critical 레벨 알림 동작
@override@JsonKey() final  NotificationAction criticalAction;
/// 헬스체크 알림 표시 여부
@override@JsonKey() final  bool showHealthCheck;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSettingsCopyWith<_NotificationSettings> get copyWith => __$NotificationSettingsCopyWithImpl<_NotificationSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSettings&&(identical(other.warningAction, warningAction) || other.warningAction == warningAction)&&(identical(other.errorAction, errorAction) || other.errorAction == errorAction)&&(identical(other.criticalAction, criticalAction) || other.criticalAction == criticalAction)&&(identical(other.showHealthCheck, showHealthCheck) || other.showHealthCheck == showHealthCheck));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,warningAction,errorAction,criticalAction,showHealthCheck);

@override
String toString() {
  return 'NotificationSettings(warningAction: $warningAction, errorAction: $errorAction, criticalAction: $criticalAction, showHealthCheck: $showHealthCheck)';
}


}

/// @nodoc
abstract mixin class _$NotificationSettingsCopyWith<$Res> implements $NotificationSettingsCopyWith<$Res> {
  factory _$NotificationSettingsCopyWith(_NotificationSettings value, $Res Function(_NotificationSettings) _then) = __$NotificationSettingsCopyWithImpl;
@override @useResult
$Res call({
 NotificationAction warningAction, NotificationAction errorAction, NotificationAction criticalAction, bool showHealthCheck
});




}
/// @nodoc
class __$NotificationSettingsCopyWithImpl<$Res>
    implements _$NotificationSettingsCopyWith<$Res> {
  __$NotificationSettingsCopyWithImpl(this._self, this._then);

  final _NotificationSettings _self;
  final $Res Function(_NotificationSettings) _then;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? warningAction = null,Object? errorAction = null,Object? criticalAction = null,Object? showHealthCheck = null,}) {
  return _then(_NotificationSettings(
warningAction: null == warningAction ? _self.warningAction : warningAction // ignore: cast_nullable_to_non_nullable
as NotificationAction,errorAction: null == errorAction ? _self.errorAction : errorAction // ignore: cast_nullable_to_non_nullable
as NotificationAction,criticalAction: null == criticalAction ? _self.criticalAction : criticalAction // ignore: cast_nullable_to_non_nullable
as NotificationAction,showHealthCheck: null == showHealthCheck ? _self.showHealthCheck : showHealthCheck // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
