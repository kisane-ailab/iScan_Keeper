import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:window_app/data/models/enums/log_level.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

/// 알림 동작 타입
enum NotificationAction {
  none('none', '알림 없음'),
  trayOnly('tray_only', '트레이 알림'),
  foreground('foreground', '전면 표시'),
  alwaysOnTop('always_on_top', '항상 위');

  const NotificationAction(this.value, this.label);

  final String value;
  final String label;
}

/// 알림 설정
@freezed
abstract class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    /// warning 레벨 알림 동작
    @Default(NotificationAction.trayOnly) NotificationAction warningAction,
    /// error 레벨 알림 동작
    @Default(NotificationAction.foreground) NotificationAction errorAction,
    /// critical 레벨 알림 동작
    @Default(NotificationAction.alwaysOnTop) NotificationAction criticalAction,
    /// 헬스체크 알림 표시 여부
    @Default(false) bool showHealthCheck,
  }) = _NotificationSettings;

  const NotificationSettings._();

  /// 로그 레벨에 따른 알림 동작 반환
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

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}
