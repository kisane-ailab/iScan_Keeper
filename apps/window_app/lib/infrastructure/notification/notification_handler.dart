import 'package:local_notifier/local_notifier.dart';
import 'package:window_app/data/models/event_log_model.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/system_tray/tray_manager.dart';

class NotificationHandler {
  static Future<void> initialize() async {
    await localNotifier.setup(
      appName: 'iScan Keeper',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }

  static Future<void> showEventLogAlert(EventLogModel log) async {
    final notification = LocalNotification(
      identifier: log.id,
      title: '긴급 알림 - 오류 발생!',
      body: '출처: ${log.source}\n'
          '에러 코드: ${log.errorCode ?? 'N/A'}\n'
          '시간: ${_formatTime(log.createdAt)}',
    );

    notification.onShow = () {
      logger.i('알림 표시됨: ${log.id}');
    };

    notification.onClose = (reason) {
      logger.d('알림 닫힘: $reason');
    };

    notification.onClick = () {
      // 알림 클릭 시 창 표시
      AppTrayManager.showWindow();
    };

    await notification.show();
  }

  static String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }
}
