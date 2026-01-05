import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/data/models/event_log_model.dart';
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

    // 알림 스트림 구독 (log_level error + unchecked)
    final subscription = viewModel.alertStream.listen((log) {
      // Windows 알림 표시
      NotificationHandler.showEventLogAlert(log);

      // 인앱 스낵바 표시
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '긴급! [${log.source}] ${log.errorCode ?? '오류 발생'}',
            ),
            backgroundColor: Colors.red,
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
              'log_level error + unchecked 로그 발생 시 알림',
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
          isAlert: viewModel.isAlert(log),
          formatTime: viewModel.formatTime,
          getResponseStatusLabel: viewModel.getResponseStatusLabel,
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
    required this.isAlert,
    required this.formatTime,
    required this.getResponseStatusLabel,
  });

  final EventLogModel log;
  final bool isAlert;
  final String Function(DateTime) formatTime;
  final String Function(String) getResponseStatusLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isAlert ? Colors.red.shade50 : null,
      child: ListTile(
        leading: Icon(
          isAlert ? Icons.error : Icons.info_outline,
          color: isAlert ? Colors.red : Colors.blue,
          size: 32,
        ),
        title: Text(
          '[${log.source}] ${log.errorCode ?? 'N/A'}',
          style: TextStyle(
            fontWeight: isAlert ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('로그 레벨: ${log.logLevel}'),
            Text(
              '응답 상태: ${getResponseStatusLabel(log.responseStatus)}',
              style: TextStyle(
                color:
                    log.responseStatus == 'unchecked' ? Colors.orange : Colors.green,
              ),
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
            if (isAlert)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
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
