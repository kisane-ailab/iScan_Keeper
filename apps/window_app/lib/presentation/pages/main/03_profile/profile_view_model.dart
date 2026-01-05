import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/domain/services/auth_service.dart';

part 'profile_view_model.freezed.dart';
part 'profile_view_model.g.dart';

/// Profile 화면 상태
@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
  }) = _ProfileState;
}

/// Profile ViewModel
@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  AuthService get _authService => ref.read(authServiceProvider.notifier);

  @override
  ProfileState build() {
    return const ProfileState();
  }

  /// 로그아웃
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await _authService.signOut();
    state = state.copyWith(isLoading: false);
  }
}
