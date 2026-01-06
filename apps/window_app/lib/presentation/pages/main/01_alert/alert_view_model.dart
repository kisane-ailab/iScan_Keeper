import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/domain/services/system_log_realtime_service.dart';

part 'alert_view_model.freezed.dart';
part 'alert_view_model.g.dart';

/// Alert 화면 상태
@freezed
abstract class AlertState with _$AlertState {
  const factory AlertState({
    @Default([]) List<SystemLogEntity> logs,
    @Default(0) int alertCount,
  }) = _AlertState;
}

/// Alert ViewModel
@riverpod
class AlertViewModel extends _$AlertViewModel {
  SystemLogRealtimeService get _service =>
      ref.read(systemLogRealtimeServiceProvider.notifier);

  @override
  AlertState build() {
    // 서비스의 로그 목록 구독
    final logs = ref.watch(systemLogRealtimeServiceProvider);
    // 미확인 상태이고 알림이 필요한 로그 개수
    final alertCount = logs.where((entity) => entity.needsNotification).length;

    return AlertState(
      logs: logs,
      alertCount: alertCount,
    );
  }

  /// 알림 스트림 (새 알림 발생 시)
  Stream<SystemLogEntity> get alertStream => _service.alertStream;

  /// 로그 모두 지우기
  void clearLogs() {
    _service.clearLogs();
  }

  /// 로그가 긴급 알림인지 확인
  bool isAlert(SystemLogEntity entity) {
    return entity.needsNotification;
  }
}
