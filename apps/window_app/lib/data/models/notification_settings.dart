import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:window_app/data/models/enums/environment.dart';
import 'package:window_app/data/models/enums/log_level.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

/// 알림 동작 타입
enum NotificationAction {
  none('none', '없음'),
  trayOnly('tray_only', '트레이'),
  foreground('foreground', '전면'),
  alwaysOnTop('always_on_top', '항상위');

  const NotificationAction(this.value, this.label);

  final String value;
  final String label;
}

/// 환경별 알림 레벨 설정
@freezed
abstract class EnvironmentNotificationSettings
    with _$EnvironmentNotificationSettings {
  const factory EnvironmentNotificationSettings({
    @Default(NotificationAction.trayOnly) NotificationAction warningAction,
    @Default(NotificationAction.foreground) NotificationAction errorAction,
    @Default(NotificationAction.alwaysOnTop) NotificationAction criticalAction,
  }) = _EnvironmentNotificationSettings;

  const EnvironmentNotificationSettings._();

  NotificationAction getActionForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return NotificationAction.none;
      case LogLevel.warning:
        return warningAction;
      case LogLevel.error:
        return errorAction;
      case LogLevel.critical:
        return criticalAction;
    }
  }

  factory EnvironmentNotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentNotificationSettingsFromJson(json);
}

/// 알림 설정
@freezed
abstract class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    /// Production 환경 알림 설정
    @Default(EnvironmentNotificationSettings()) EnvironmentNotificationSettings production,
    /// Development 환경 알림 설정 (기본: 낮은 강도)
    @Default(EnvironmentNotificationSettings(
      warningAction: NotificationAction.none,
      errorAction: NotificationAction.trayOnly,
      criticalAction: NotificationAction.foreground,
    )) EnvironmentNotificationSettings development,
    /// 헬스체크 알림 표시 여부
    @Default(false) bool showHealthCheck,
  }) = _NotificationSettings;

  const NotificationSettings._();

  /// 환경과 로그 레벨에 따른 알림 동작 반환
  NotificationAction getActionForLevel(LogLevel level, {Environment? environment}) {
    final env = environment ?? Environment.production;
    return env.isProduction
        ? production.getActionForLevel(level)
        : development.getActionForLevel(level);
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}
