import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/domain/services/system_log_realtime_service.dart';

part 'health_check_view_model.freezed.dart';
part 'health_check_view_model.g.dart';

/// HealthCheck 화면 상태
@freezed
abstract class HealthCheckState with _$HealthCheckState {
  const factory HealthCheckState({
    @Default([]) List<SystemLogEntity> productionLogs,
    @Default([]) List<SystemLogEntity> developmentLogs,
    @Default(0) int productionAlertCount,
    @Default(0) int developmentAlertCount,
  }) = _HealthCheckState;
}

extension HealthCheckStateX on HealthCheckState {
  /// 전체 알림 개수 (뱃지용)
  int get alertCount => productionAlertCount + developmentAlertCount;
}

/// HealthCheck ViewModel
@riverpod
class HealthCheckViewModel extends _$HealthCheckViewModel {
  @override
  HealthCheckState build() {
    // 서비스의 로그 목록 구독 (health_check만 필터링)
    final allLogs = ref.watch(systemLogRealtimeServiceProvider);
    final healthCheckLogs =
        allLogs.where((entity) => entity.isHealthCheck).toList();

    // Production/Development 분리
    final productionLogs =
        healthCheckLogs.where((entity) => entity.isProduction).toList();
    final developmentLogs =
        healthCheckLogs.where((entity) => entity.isDevelopment).toList();

    // 미확인 상태이고 알림이 필요한 로그 개수
    final productionAlertCount =
        productionLogs.where((entity) => entity.needsNotification).length;
    final developmentAlertCount =
        developmentLogs.where((entity) => entity.needsNotification).length;

    return HealthCheckState(
      productionLogs: productionLogs,
      developmentLogs: developmentLogs,
      productionAlertCount: productionAlertCount,
      developmentAlertCount: developmentAlertCount,
    );
  }
}
