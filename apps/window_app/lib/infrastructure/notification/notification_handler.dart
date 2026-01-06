import 'package:local_notifier/local_notifier.dart';
import 'package:window_app/data/models/notification_settings.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/system_tray/tray_manager.dart';

class NotificationHandler {
  static Future<void> initialize() async {
    await localNotifier.setup(
      appName: 'iScan Keeper',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }

  /// 시스템 로그에 대한 알림 처리
  static Future<void> handleEventLog(
    SystemLogEntity entity,
    NotificationSettings settings,
  ) async {
    // 헬스체크인데 설정에서 표시 안함이면 무시
    if (entity.isHealthCheck && !settings.showHealthCheck) {
      return;
    }

    final action = settings.getActionForLevel(entity.logLevel);

    switch (action) {
      case NotificationAction.none:
        // 알림 없음
        break;
      case NotificationAction.trayOnly:
        // 트레이 알림만
        await _showTrayNotification(entity);
        break;
      case NotificationAction.foreground:
        // 트레이 알림 + 앱 전면 표시
        await _showTrayNotification(entity);
        await AppTrayManager.showWindow();
        break;
      case NotificationAction.alwaysOnTop:
        // 트레이 알림 + 앱 전면 표시 + 항상 위 (닫기 불가)
        await _showTrayNotification(entity);
        await AppTrayManager.showWindowAlwaysOnTop();
        break;
    }
  }

  /// 트레이 알림 표시
  static Future<void> _showTrayNotification(SystemLogEntity entity) async {
    final title = _getTitleForLevel(entity);
    final body = _getBodyForLog(entity);

    final notification = LocalNotification(
      identifier: entity.id,
      title: title,
      body: body,
    );

    notification.onShow = () {
      logger.i('알림 표시됨: ${entity.id}');
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
  static String _getTitleForLevel(SystemLogEntity entity) {
    switch (entity.logLevel) {
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
  static String _getBodyForLog(SystemLogEntity entity) {
    final buffer = StringBuffer();
    buffer.writeln('출처: ${entity.source}');

    if (entity.errorCode != null) {
      buffer.writeln('에러 코드: ${entity.errorCode}');
    }

    buffer.writeln('유형: ${entity.eventType.label}');
    buffer.write('시간: ${entity.formattedCreatedAt}');

    return buffer.toString();
  }

  /// 대응 시작 알림 (다른 사람이 대응 시작했을 때)
  static Future<void> showResponseStarted(SystemLogEntity entity) async {
    final responderName = entity.currentResponderName ?? '알 수 없음';
    final startedAt = entity.formattedResponseStartedAt ?? '';

    final notification = LocalNotification(
      identifier: '${entity.id}_response_started',
      title: '📋 대응 시작',
      body: '$responderName님이 대응을 시작했습니다\n${entity.issueInfo}\n$startedAt',
    );

    notification.onClick = () {
      AppTrayManager.showWindow();
    };

    await notification.show();
    logger.i('대응 시작 알림: $responderName → ${entity.source}');
  }

  /// 대응 포기 알림 (다른 사람이 대응 포기했을 때)
  static Future<void> showResponseAbandoned({
    required SystemLogEntity entity,
    required String abandonedByName,
  }) async {
    final notification = LocalNotification(
      identifier: '${entity.id}_response_abandoned',
      title: '⚠️ 대응 포기',
      body: '$abandonedByName님이 대응을 포기했습니다\n${entity.issueInfo}',
    );

    notification.onClick = () {
      AppTrayManager.showWindow();
    };

    await notification.show();
    logger.w('대응 포기 알림: $abandonedByName → ${entity.source}');
  }
}
