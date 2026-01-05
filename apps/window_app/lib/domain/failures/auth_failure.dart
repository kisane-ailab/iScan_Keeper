import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:window_app/data/errors/auth_error.dart';

part 'auth_failure.freezed.dart';

/// 인증 실패 타입
@freezed
sealed class AuthFailure with _$AuthFailure {
  /// 잘못된 로그인 정보 (이메일 또는 비밀번호 불일치)
  const factory AuthFailure.invalidCredentials() = InvalidCredentials;

  /// 이메일 미인증
  const factory AuthFailure.emailNotConfirmed() = EmailNotConfirmed;

  /// 사용자를 찾을 수 없음
  const factory AuthFailure.userNotFound() = UserNotFound;

  /// 이미 사용 중인 이메일
  const factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;

  /// 약한 비밀번호
  const factory AuthFailure.weakPassword() = WeakPassword;

  /// 잘못된 이메일 형식
  const factory AuthFailure.invalidEmail() = InvalidEmail;

  /// 너무 많은 요청
  const factory AuthFailure.tooManyRequests() = TooManyRequests;

  /// 네트워크 오류
  const factory AuthFailure.networkError() = NetworkError;

  /// 알 수 없는 오류
  const factory AuthFailure.unknown([String? message]) = UnknownAuthFailure;
}

/// AuthErrorCode를 AuthFailure로 변환
AuthFailure authFailureFromErrorCode(AuthErrorCode code, [String? message]) {
  return switch (code) {
    AuthErrorCode.invalidCredentials => const AuthFailure.invalidCredentials(),
    AuthErrorCode.emailNotConfirmed => const AuthFailure.emailNotConfirmed(),
    AuthErrorCode.userNotFound => const AuthFailure.userNotFound(),
    AuthErrorCode.emailAlreadyInUse => const AuthFailure.emailAlreadyInUse(),
    AuthErrorCode.weakPassword => const AuthFailure.weakPassword(),
    AuthErrorCode.invalidEmail => const AuthFailure.invalidEmail(),
    AuthErrorCode.tooManyRequests => const AuthFailure.tooManyRequests(),
    AuthErrorCode.networkError => const AuthFailure.networkError(),
    AuthErrorCode.unknown => AuthFailure.unknown(message),
  };
}

/// AuthFailure를 사용자에게 표시할 메시지로 변환
extension AuthFailureMessage on AuthFailure {
  String get message => when(
        invalidCredentials: () => '이메일 또는 비밀번호가 올바르지 않습니다.',
        emailNotConfirmed: () => '이메일 인증이 완료되지 않았습니다. 메일함을 확인해주세요.',
        userNotFound: () => '등록되지 않은 사용자입니다.',
        emailAlreadyInUse: () => '이미 사용 중인 이메일입니다.',
        weakPassword: () => '비밀번호가 너무 약합니다. 6자 이상 입력해주세요.',
        invalidEmail: () => '올바른 이메일 형식이 아닙니다.',
        tooManyRequests: () => '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.',
        networkError: () => '네트워크 연결을 확인해주세요.',
        unknown: (msg) => msg ?? '알 수 없는 오류가 발생했습니다.',
      );
}
