import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/data/models/enums/response_status.dart';
import 'package:window_app/data/models/event_log_model.dart';
import 'package:window_app/domain/services/notification_settings_service.dart';
import 'package:window_app/infrastructure/notification/notification_handler.dart';
import 'package:window_app/presentation/layout/base_page.dart';
import 'package:window_app/presentation/pages/main/01_alert/alert_view_model.dart';

class AlertScreen extends BasePage {
  const AlertScreen({super.key});

  static const String path = '/alert';
  static const String name = 'alert';

  @override
  void onInit(
    BuildContext context,
    WidgetRef ref, [
    List<StreamSubscription>? subscriptions,
  ]) {
    final viewModel = ref.read(alertViewModelProvider.notifier);

    // 알림 스트림 구독
    final subscription = viewModel.alertStream.listen((log) {
      // 알림 설정에 따라 처리
      final settings = ref.read(notificationSettingsServiceProvider);
      NotificationHandler.handleEventLog(log, settings);

      // 인앱 스낵바 표시 (warning 이상일 때)
      if (context.mounted && log.logLevel.needsNotification) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '[${log.logLevel.label}] ${log.source} - ${log.errorCode ?? '알림'}',
            ),
            backgroundColor: _getColorForLevel(log.logLevel),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: '확인',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    });

    subscriptions?.add(subscription);
  }

  Color _getColorForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.critical:
        return Colors.purple;
      case LogLevel.error:
        return Colors.red;
      case LogLevel.warning:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    final state = ref.watch(alertViewModelProvider);
    final viewModel = ref.read(alertViewModelProvider.notifier);

    return AppBar(
      title: Row(
        children: [
          const Text('알림 센터'),
          if (state.alertCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${state.alertCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: '알림 모두 지우기',
          onPressed: () => viewModel.clearLogs(),
        ),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final state = ref.watch(alertViewModelProvider);
    final viewModel = ref.read(alertViewModelProvider.notifier);

    if (state.logs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '실시간 알림 대기 중...',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '설정에서 알림 레벨별 동작을 변경할 수 있습니다',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.logs.length,
      itemBuilder: (context, index) {
        final log = state.logs[index];
        return _LogCard(
          log: log,
          formatTime: viewModel.formatTime,
        );
      },
    );
  }

  @override
  bool get wrapWithSafeArea => false;
}

class _LogCard extends StatelessWidget {
  const _LogCard({
    required this.log,
    required this.formatTime,
  });

  final EventLogModel log;
  final String Function(DateTime) formatTime;

  Color _getLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.critical:
        return Colors.purple;
      case LogLevel.error:
        return Colors.red;
      case LogLevel.warning:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getLevelIcon(LogLevel level) {
    switch (level) {
      case LogLevel.critical:
        return Icons.dangerous;
      case LogLevel.error:
        return Icons.error;
      case LogLevel.warning:
        return Icons.warning;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = _getLevelColor(log.logLevel);
    final isUnchecked = log.responseStatus == ResponseStatus.unchecked;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isUnchecked && log.logLevel.needsNotification
          ? levelColor.withOpacity(0.1)
          : null,
      child: ListTile(
        leading: Icon(
          _getLevelIcon(log.logLevel),
          color: levelColor,
          size: 32,
        ),
        title: Row(
          children: [
            Text(
              '[${log.source}]',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: log.isHealthCheck ? Colors.green : Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                log.eventType.label,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (log.errorCode != null)
              Text('에러 코드: ${log.errorCode}'),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: levelColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    log.logLevel.label,
                    style: TextStyle(fontSize: 11, color: levelColor),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  log.responseStatus.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnchecked ? Colors.orange : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatTime(log.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (log.logLevel == LogLevel.critical)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '긴급',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
