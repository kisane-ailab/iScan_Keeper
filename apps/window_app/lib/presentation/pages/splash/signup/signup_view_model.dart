import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/domain/failures/auth_failure.dart';
import 'package:window_app/domain/services/auth_service.dart';

part 'signup_view_model.freezed.dart';
part 'signup_view_model.g.dart';

/// 회원가입 화면 상태
@freezed
abstract class SignupState with _$SignupState {
  const factory SignupState({
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _SignupState;
}

/// 회원가입 ViewModel
@riverpod
class SignupViewModel extends _$SignupViewModel {
  AuthService get _authService => ref.read(authServiceProvider.notifier);

  @override
  SignupState build() {
    return const SignupState();
  }

  /// 회원가입
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authService.signUp(
      email: email,
      password: password,
      name: name,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        // 인증 대기 이메일 저장
        ref.read(pendingVerificationEmailProvider.notifier).setEmail(email);
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
