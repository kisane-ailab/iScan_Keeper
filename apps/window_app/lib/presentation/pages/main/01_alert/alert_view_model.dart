import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/models/event_log_model.dart';
import 'package:window_app/domain/services/event_log_realtime_service.dart';

part 'alert_view_model.freezed.dart';
part 'alert_view_model.g.dart';

/// Alert 화면 상태
@freezed
abstract class AlertState with _$AlertState {
  const factory AlertState({
    @Default([]) List<EventLogModel> logs,
    @Default(0) int alertCount,
  }) = _AlertState;
}

/// Alert ViewModel
@riverpod
class AlertViewModel extends _$AlertViewModel {
  EventLogRealtimeService get _service =>
      ref.read(eventLogRealtimeServiceProvider.notifier);

  @override
  AlertState build() {
    // 서비스의 로그 목록 구독
    final logs = ref.watch(eventLogRealtimeServiceProvider);
    final alertCount = logs
        .where((l) => l.logLevel == 'error' && l.responseStatus == 'unchecked')
        .length;

    return AlertState(
      logs: logs,
      alertCount: alertCount,
    );
  }

  /// 알림 스트림 (새 알림 발생 시)
  Stream<EventLogModel> get alertStream => _service.alertStream;

  /// 로그 모두 지우기
  void clearLogs() {
    _service.clearLogs();
  }

  /// 로그가 긴급 알림인지 확인
  bool isAlert(EventLogModel log) {
    return log.logLevel == 'error' && log.responseStatus == 'unchecked';
  }

  /// 응답 상태 라벨 반환
  String getResponseStatusLabel(String status) {
    switch (status) {
      case 'unchecked':
        return '미확인';
      case 'in_progress':
        return '처리중';
      case 'completed':
        return '완료';
      default:
        return status;
    }
  }

  /// 시간 포맷팅
  String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }
}
