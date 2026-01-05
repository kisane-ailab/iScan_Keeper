import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/domain/failures/auth_failure.dart';
import 'package:window_app/domain/services/auth_service.dart';

part 'splash_view_model.freezed.dart';
part 'splash_view_model.g.dart';

/// 스플래시(로그인) 화면 상태
@freezed
abstract class SplashState with _$SplashState {
  const factory SplashState({
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _SplashState;
}

/// 스플래시 ViewModel
@riverpod
class SplashViewModel extends _$SplashViewModel {
  AuthService get _authService => ref.read(authServiceProvider.notifier);

  @override
  SplashState build() {
    return const SplashState();
  }

  /// 로그인
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authService.signIn(email: email, password: password);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
    );
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
