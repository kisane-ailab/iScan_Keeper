// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure()';
}


}

/// @nodoc
class $AuthFailureCopyWith<$Res>  {
$AuthFailureCopyWith(AuthFailure _, $Res Function(AuthFailure) __);
}


/// Adds pattern-matching-related methods to [AuthFailure].
extension AuthFailurePatterns on AuthFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InvalidCredentials value)?  invalidCredentials,TResult Function( EmailNotConfirmed value)?  emailNotConfirmed,TResult Function( UserNotFound value)?  userNotFound,TResult Function( EmailAlreadyInUse value)?  emailAlreadyInUse,TResult Function( WeakPassword value)?  weakPassword,TResult Function( InvalidEmail value)?  invalidEmail,TResult Function( TooManyRequests value)?  tooManyRequests,TResult Function( NetworkError value)?  networkError,TResult Function( UnknownAuthFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InvalidCredentials() when invalidCredentials != null:
return invalidCredentials(_that);case EmailNotConfirmed() when emailNotConfirmed != null:
return emailNotConfirmed(_that);case UserNotFound() when userNotFound != null:
return userNotFound(_that);case EmailAlreadyInUse() when emailAlreadyInUse != null:
return emailAlreadyInUse(_that);case WeakPassword() when weakPassword != null:
return weakPassword(_that);case InvalidEmail() when invalidEmail != null:
return invalidEmail(_that);case TooManyRequests() when tooManyRequests != null:
return tooManyRequests(_that);case NetworkError() when networkError != null:
return networkError(_that);case UnknownAuthFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InvalidCredentials value)  invalidCredentials,required TResult Function( EmailNotConfirmed value)  emailNotConfirmed,required TResult Function( UserNotFound value)  userNotFound,required TResult Function( EmailAlreadyInUse value)  emailAlreadyInUse,required TResult Function( WeakPassword value)  weakPassword,required TResult Function( InvalidEmail value)  invalidEmail,required TResult Function( TooManyRequests value)  tooManyRequests,required TResult Function( NetworkError value)  networkError,required TResult Function( UnknownAuthFailure value)  unknown,}){
final _that = this;
switch (_that) {
case InvalidCredentials():
return invalidCredentials(_that);case EmailNotConfirmed():
return emailNotConfirmed(_that);case UserNotFound():
return userNotFound(_that);case EmailAlreadyInUse():
return emailAlreadyInUse(_that);case WeakPassword():
return weakPassword(_that);case InvalidEmail():
return invalidEmail(_that);case TooManyRequests():
return tooManyRequests(_that);case NetworkError():
return networkError(_that);case UnknownAuthFailure():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InvalidCredentials value)?  invalidCredentials,TResult? Function( EmailNotConfirmed value)?  emailNotConfirmed,TResult? Function( UserNotFound value)?  userNotFound,TResult? Function( EmailAlreadyInUse value)?  emailAlreadyInUse,TResult? Function( WeakPassword value)?  weakPassword,TResult? Function( InvalidEmail value)?  invalidEmail,TResult? Function( TooManyRequests value)?  tooManyRequests,TResult? Function( NetworkError value)?  networkError,TResult? Function( UnknownAuthFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case InvalidCredentials() when invalidCredentials != null:
return invalidCredentials(_that);case EmailNotConfirmed() when emailNotConfirmed != null:
return emailNotConfirmed(_that);case UserNotFound() when userNotFound != null:
return userNotFound(_that);case EmailAlreadyInUse() when emailAlreadyInUse != null:
return emailAlreadyInUse(_that);case WeakPassword() when weakPassword != null:
return weakPassword(_that);case InvalidEmail() when invalidEmail != null:
return invalidEmail(_that);case TooManyRequests() when tooManyRequests != null:
return tooManyRequests(_that);case NetworkError() when networkError != null:
return networkError(_that);case UnknownAuthFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  invalidCredentials,TResult Function()?  emailNotConfirmed,TResult Function()?  userNotFound,TResult Function()?  emailAlreadyInUse,TResult Function()?  weakPassword,TResult Function()?  invalidEmail,TResult Function()?  tooManyRequests,TResult Function()?  networkError,TResult Function( String? message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InvalidCredentials() when invalidCredentials != null:
return invalidCredentials();case EmailNotConfirmed() when emailNotConfirmed != null:
return emailNotConfirmed();case UserNotFound() when userNotFound != null:
return userNotFound();case EmailAlreadyInUse() when emailAlreadyInUse != null:
return emailAlreadyInUse();case WeakPassword() when weakPassword != null:
return weakPassword();case InvalidEmail() when invalidEmail != null:
return invalidEmail();case TooManyRequests() when tooManyRequests != null:
return tooManyRequests();case NetworkError() when networkError != null:
return networkError();case UnknownAuthFailure() when unknown != null:
return unknown(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  invalidCredentials,required TResult Function()  emailNotConfirmed,required TResult Function()  userNotFound,required TResult Function()  emailAlreadyInUse,required TResult Function()  weakPassword,required TResult Function()  invalidEmail,required TResult Function()  tooManyRequests,required TResult Function()  networkError,required TResult Function( String? message)  unknown,}) {final _that = this;
switch (_that) {
case InvalidCredentials():
return invalidCredentials();case EmailNotConfirmed():
return emailNotConfirmed();case UserNotFound():
return userNotFound();case EmailAlreadyInUse():
return emailAlreadyInUse();case WeakPassword():
return weakPassword();case InvalidEmail():
return invalidEmail();case TooManyRequests():
return tooManyRequests();case NetworkError():
return networkError();case UnknownAuthFailure():
return unknown(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  invalidCredentials,TResult? Function()?  emailNotConfirmed,TResult? Function()?  userNotFound,TResult? Function()?  emailAlreadyInUse,TResult? Function()?  weakPassword,TResult? Function()?  invalidEmail,TResult? Function()?  tooManyRequests,TResult? Function()?  networkError,TResult? Function( String? message)?  unknown,}) {final _that = this;
switch (_that) {
case InvalidCredentials() when invalidCredentials != null:
return invalidCredentials();case EmailNotConfirmed() when emailNotConfirmed != null:
return emailNotConfirmed();case UserNotFound() when userNotFound != null:
return userNotFound();case EmailAlreadyInUse() when emailAlreadyInUse != null:
return emailAlreadyInUse();case WeakPassword() when weakPassword != null:
return weakPassword();case InvalidEmail() when invalidEmail != null:
return invalidEmail();case TooManyRequests() when tooManyRequests != null:
return tooManyRequests();case NetworkError() when networkError != null:
return networkError();case UnknownAuthFailure() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class InvalidCredentials implements AuthFailure {
  const InvalidCredentials();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidCredentials);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.invalidCredentials()';
}


}




/// @nodoc


class EmailNotConfirmed implements AuthFailure {
  const EmailNotConfirmed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailNotConfirmed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.emailNotConfirmed()';
}


}




/// @nodoc


class UserNotFound implements AuthFailure {
  const UserNotFound();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserNotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.userNotFound()';
}


}




/// @nodoc


class EmailAlreadyInUse implements AuthFailure {
  const EmailAlreadyInUse();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailAlreadyInUse);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.emailAlreadyInUse()';
}


}




/// @nodoc


class WeakPassword implements AuthFailure {
  const WeakPassword();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeakPassword);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.weakPassword()';
}


}




/// @nodoc


class InvalidEmail implements AuthFailure {
  const InvalidEmail();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidEmail);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.invalidEmail()';
}


}




/// @nodoc


class TooManyRequests implements AuthFailure {
  const TooManyRequests();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TooManyRequests);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.tooManyRequests()';
}


}




/// @nodoc


class NetworkError implements AuthFailure {
  const NetworkError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.networkError()';
}


}




/// @nodoc


class UnknownAuthFailure implements AuthFailure {
  const UnknownAuthFailure([this.message]);
  

 final  String? message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownAuthFailureCopyWith<UnknownAuthFailure> get copyWith => _$UnknownAuthFailureCopyWithImpl<UnknownAuthFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownAuthFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnknownAuthFailureCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory $UnknownAuthFailureCopyWith(UnknownAuthFailure value, $Res Function(UnknownAuthFailure) _then) = _$UnknownAuthFailureCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$UnknownAuthFailureCopyWithImpl<$Res>
    implements $UnknownAuthFailureCopyWith<$Res> {
  _$UnknownAuthFailureCopyWithImpl(this._self, this._then);

  final UnknownAuthFailure _self;
  final $Res Function(UnknownAuthFailure) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(UnknownAuthFailure(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
