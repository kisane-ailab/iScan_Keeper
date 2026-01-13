import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/models/system_log_model.dart';
import 'package:window_app/data/repositories/system_log_repository_impl.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';

part 'muted_view_model.freezed.dart';
part 'muted_view_model.g.dart';

/// 숨긴 알림 화면 상태
@freezed
abstract class MutedState with _$MutedState {
  const factory MutedState({
    @Default([]) List<SystemLogEntity> logs,
    @Default(false) bool isLoading,
    String? error,
  }) = _MutedState;
}

/// 숨긴 알림 ViewModel
@riverpod
class MutedViewModel extends _$MutedViewModel {
  @override
  MutedState build() {
    // 초기 로드
    Future.microtask(() => loadMutedLogs());
    return const MutedState(isLoading: true);
  }

  /// 숨긴 로그 목록 로드
  Future<void> loadMutedLogs() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(systemLogRepositoryProvider);
      final result = await repository.getMutedLogs();

      final entities = result.map((json) {
        final model = SystemLogModel.fromJson(json);
        return SystemLogEntity.fromModel(model);
      }).toList();

      state = state.copyWith(logs: entities, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '숨긴 로그를 불러오는데 실패했습니다: $e',
      );
    }
  }

  /// 로그 숨김 해제 (unmute)
  Future<bool> unmuteLogs(String id) async {
    try {
      final repository = ref.read(systemLogRepositoryProvider);
      await repository.setLogMuted(id, false);

      // 목록에서 제거
      state = state.copyWith(
        logs: state.logs.where((log) => log.id != id).toList(),
      );

      return true;
    } catch (e) {
      state = state.copyWith(error: '숨김 해제에 실패했습니다: $e');
      return false;
    }
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }
}
