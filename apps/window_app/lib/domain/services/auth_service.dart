import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_app/data/errors/auth_error.dart';
import 'package:window_app/domain/failures/auth_failure.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';

part 'auth_service.freezed.dart';
part 'auth_service.g.dart';

/// 인증 상태
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(true) bool isLoading,
    User? user,
  }) = _AuthState;
}

/// 인증 서비스
@Riverpod(keepAlive: true)
class AuthService extends _$AuthService {
  SupabaseClient get _client => ref.read(supabaseClientProvider);

  @override
  AuthState build() {
    // 인증 상태 변화 구독
    final subscription = _client.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      final event = data.event;
      logger.d('인증 상태 변경: $event - ${user?.email ?? "로그아웃"}');

      // 세션이 있으면 온라인으로 설정
      if (user != null) {
        _setUserOnline(user.id);
      }

      state = AuthState(isLoading: false, user: user);
    });

    ref.onDispose(() {
      subscription.cancel();
    });

    // 초기 상태는 로딩 중
    return const AuthState(isLoading: true);
  }

  /// 사용자를 온라인 상태로 설정
  Future<void> _setUserOnline(String userId) async {
    try {
      await _client.from('users').update({
        'status': 'online',
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
      logger.i('사용자 상태 online으로 변경: $userId');
    } catch (e) {
      logger.e('사용자 상태 변경 실패', error: e);
    }
  }

  /// 현재 로그인 여부
  bool get isLoggedIn => state.user != null;

  /// 회원가입
  Future<Either<AuthFailure, Unit>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    logger.i('회원가입 시도: $email');

    return TaskEither<AuthFailure, AuthResponse>.tryCatch(
      () async {
        // 1. Supabase Auth로 회원가입
        final response = await _client.auth.signUp(
          email: email,
          password: password,
        );

        if (response.user == null) {
          throw Exception('회원가입 응답 없음');
        }

        return response;
      },
      _handleAuthError,
    )
        .flatMap((response) => TaskEither.tryCatch(
              () async {
                // 2. users 테이블에 사용자 정보 저장
                await _client.from('users').insert({
                  'id': response.user!.id,
                  'email': email,
                  'name': name,
                  'status': 'offline',
                });

                logger.i('회원가입 완료: ${response.user!.id}');
                return unit;
              },
              _handleAuthError,
            ))
        .run();
  }

  /// 로그인
  Future<Either<AuthFailure, Unit>> signIn({
    required String email,
    required String password,
  }) async {
    logger.i('로그인 시도: $email');

    return TaskEither<AuthFailure, Unit>.tryCatch(
      () async {
        final response = await _client.auth.signInWithPassword(
          email: email,
          password: password,
        );

        if (response.user == null) {
          throw Exception('로그인 응답 없음');
        }

        // onAuthStateChange에서 online 상태 설정됨
        logger.i('로그인 완료: ${response.user!.id}');
        return unit;
      },
      _handleAuthError,
    ).run();
  }

  /// 로그아웃
  Future<Either<AuthFailure, Unit>> signOut() async {
    return TaskEither<AuthFailure, Unit>.tryCatch(
      () async {
        final userId = state.user?.id;

        if (userId != null) {
          // 로그아웃 시 상태를 offline으로 변경
          await _client.from('users').update({
            'status': 'offline',
            'updated_at': DateTime.now().toIso8601String(),
          }).eq('id', userId);
        }

        await _client.auth.signOut();
        logger.i('로그아웃 완료');
        return unit;
      },
      _handleAuthError,
    ).run();
  }

  /// 에러 핸들링 (AuthException → AuthFailure)
  AuthFailure _handleAuthError(Object error, StackTrace stackTrace) {
    logger.e('인증 오류', error: error, stackTrace: stackTrace);

    if (error is AuthException) {
      final code = mapAuthException(error);
      return authFailureFromErrorCode(code, error.message);
    }

    if (error is AuthFailure) {
      return error;
    }

    final code = mapGeneralException(error);
    return authFailureFromErrorCode(code, error.toString());
  }
}

/// 인증 로딩 상태 Provider
@riverpod
bool isAuthLoading(Ref ref) {
  final authState = ref.watch(authServiceProvider);
  return authState.isLoading;
}

/// 로그인 상태 Provider
@riverpod
bool isLoggedIn(Ref ref) {
  final authState = ref.watch(authServiceProvider);
  return authState.user != null;
}

/// 현재 사용자 Provider
@riverpod
User? currentUser(Ref ref) {
  final authState = ref.watch(authServiceProvider);
  return authState.user;
}

/// 이메일 인증 완료 여부 Provider
@riverpod
bool isEmailConfirmed(Ref ref) {
  final authState = ref.watch(authServiceProvider);
  final user = authState.user;
  if (user == null) return false;
  return user.emailConfirmedAt != null;
}

/// 인증 대기 중인 이메일 (회원가입 직후 사용)
@Riverpod(keepAlive: true)
class PendingVerificationEmail extends _$PendingVerificationEmail {
  @override
  String? build() => null;

  void setEmail(String email) {
    state = email;
  }

  void clear() {
    state = null;
  }
}
