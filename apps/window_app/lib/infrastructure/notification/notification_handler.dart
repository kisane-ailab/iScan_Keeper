import 'package:local_notifier/local_notifier.dart';
import 'package:window_app/data/models/event_log_model.dart';
import 'package:window_app/data/models/notification_settings.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/system_tray/tray_manager.dart';

class NotificationHandler {
  static Future<void> initialize() async {
    await localNotifier.setup(
      appName: 'iScan Keeper',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }

  /// 이벤트 로그에 대한 알림 처리
  static Future<void> handleEventLog(
    EventLogModel log,
    NotificationSettings settings,
  ) async {
    // 헬스체크인데 설정에서 표시 안함이면 무시
    if (log.isHealthCheck && !settings.showHealthCheck) {
      return;
    }

    final action = settings.getActionForLevel(log.logLevel);

    switch (action) {
      case NotificationAction.none:
        // 알림 없음
        break;
      case NotificationAction.trayOnly:
        // 트레이 알림만
        await _showTrayNotification(log);
        break;
      case NotificationAction.foreground:
        // 트레이 알림 + 앱 전면 표시
        await _showTrayNotification(log);
        await AppTrayManager.showWindow();
        break;
      case NotificationAction.alwaysOnTop:
        // 트레이 알림 + 앱 전면 표시 + 항상 위 (닫기 불가)
        await _showTrayNotification(log);
        await AppTrayManager.showWindowAlwaysOnTop();
        break;
    }
  }

  /// 트레이 알림 표시
  static Future<void> _showTrayNotification(EventLogModel log) async {
    final title = _getTitleForLevel(log);
    final body = _getBodyForLog(log);

    final notification = LocalNotification(
      identifier: log.id,
      title: title,
      body: body,
    );

    notification.onShow = () {
      logger.i('알림 표시됨: ${log.id}');
    };

    notification.onClose = (reason) {
      logger.d('알림 닫힘: $reason');
    };

    notification.onClick = () {
      AppTrayManager.showWindow();
    };

    await notification.show();
  }

  /// 로그 레벨에 따른 알림 제목
  static String _getTitleForLevel(EventLogModel log) {
    switch (log.logLevel) {
      case final level when level.value == 'critical':
        return '🚨 긴급! 심각한 오류 발생';
      case final level when level.value == 'error':
        return '❌ 오류 발생';
      case final level when level.value == 'warning':
        return '⚠️ 경고';
      default:
        return 'ℹ️ 알림';
    }
  }

  /// 로그 본문 생성
  static String _getBodyForLog(EventLogModel log) {
    final buffer = StringBuffer();
    buffer.writeln('출처: ${log.source}');

    if (log.errorCode != null) {
      buffer.writeln('에러 코드: ${log.errorCode}');
    }

    buffer.writeln('유형: ${log.eventType.label}');
    buffer.write('시간: ${_formatTime(log.createdAt)}');

    return buffer.toString();
  }

  static String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }
}
