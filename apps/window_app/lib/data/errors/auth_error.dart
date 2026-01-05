import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase 인증 관련 에러 코드
enum AuthErrorCode {
  invalidCredentials,
  emailNotConfirmed,
  userNotFound,
  emailAlreadyInUse,
  weakPassword,
  invalidEmail,
  tooManyRequests,
  networkError,
  unknown,
}

/// Supabase AuthException을 AuthErrorCode로 변환
AuthErrorCode mapAuthException(AuthException exception) {
  final message = exception.message.toLowerCase();
  final statusCode = exception.statusCode;

  // AuthApiException의 code 필드 확인
  if (exception is AuthApiException) {
    final code = exception.code?.toLowerCase() ?? '';

    if (code == 'email_not_confirmed') {
      return AuthErrorCode.emailNotConfirmed;
    }
    if (code == 'invalid_credentials') {
      return AuthErrorCode.invalidCredentials;
    }
    if (code == 'user_already_exists') {
      return AuthErrorCode.emailAlreadyInUse;
    }
    if (code == 'weak_password') {
      return AuthErrorCode.weakPassword;
    }
    if (code == 'validation_failed' && message.contains('email')) {
      return AuthErrorCode.invalidEmail;
    }
    if (code == 'over_request_rate_limit') {
      return AuthErrorCode.tooManyRequests;
    }
  }

  // 상태 코드 기반 매핑 (fallback)
  if (statusCode == '400') {
    if (message.contains('invalid login credentials') ||
        message.contains('invalid credentials')) {
      return AuthErrorCode.invalidCredentials;
    }
    if (message.contains('email not confirmed')) {
      return AuthErrorCode.emailNotConfirmed;
    }
    if (message.contains('user already registered') ||
        message.contains('already been registered')) {
      return AuthErrorCode.emailAlreadyInUse;
    }
    if (message.contains('password')) {
      return AuthErrorCode.weakPassword;
    }
  }

  if (statusCode == '422') {
    if (message.contains('email')) {
      return AuthErrorCode.invalidEmail;
    }
    if (message.contains('password')) {
      return AuthErrorCode.weakPassword;
    }
  }

  if (statusCode == '429') {
    return AuthErrorCode.tooManyRequests;
  }

  if (statusCode == '404') {
    return AuthErrorCode.userNotFound;
  }

  // 메시지 기반 매핑
  if (message.contains('network') || message.contains('connection')) {
    return AuthErrorCode.networkError;
  }

  return AuthErrorCode.unknown;
}

/// 일반 Exception을 AuthErrorCode로 변환
AuthErrorCode mapGeneralException(Object exception) {
  final message = exception.toString().toLowerCase();

  if (message.contains('network') ||
      message.contains('connection') ||
      message.contains('socket')) {
    return AuthErrorCode.networkError;
  }

  return AuthErrorCode.unknown;
}
