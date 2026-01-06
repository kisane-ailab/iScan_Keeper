import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/data/models/enums/response_status.dart';
import 'package:window_app/data/models/event_log_model.dart';
import 'package:window_app/domain/services/auth_service.dart';
import 'package:window_app/domain/services/event_response_service.dart';
import 'package:window_app/infrastructure/system_tray/tray_manager.dart';
import 'package:window_app/presentation/layout/base_page.dart';
import 'package:window_app/presentation/pages/main/01_alert/alert_view_model.dart';

class AlertScreen extends BasePage {
  const AlertScreen({super.key});

  static const String path = '/alert';
  static const String name = 'alert';

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

    // 미확인 critical 로그 찾기
    final uncheckedCriticalLogs =
        state.logs.where((log) => log.isCriticalUnchecked).toList();

    return Column(
      children: [
        // 항상 위 모드 배너 (미확인 critical이 있을 때)
        if (AppTrayManager.isAlwaysOnTop && uncheckedCriticalLogs.isNotEmpty)
          _CriticalAlertBanner(
            logs: uncheckedCriticalLogs,
            onRespond: (log) => _showResponseDialog(context, ref, log),
          ),

        // 메인 콘텐츠
        Expanded(
          child: state.logs.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none,
                          size: 64, color: Colors.grey),
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
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.logs.length,
                  itemBuilder: (context, index) {
                    final log = state.logs[index];
                    return _LogCard(
                      log: log,
                      formatTime: viewModel.formatTime,
                      onRespond: () => _showResponseDialog(context, ref, log),
                      onAbandon: () => _abandonResponse(context, ref, log),
                      onComplete: () =>
                          _showCompleteDialog(context, ref, log),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _showResponseDialog(
      BuildContext context, WidgetRef ref, EventLogModel log) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('대응 시작'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('소스: ${log.source}'),
            if (log.errorCode != null) Text('에러 코드: ${log.errorCode}'),
            Text('레벨: ${log.logLevel.label}'),
            const SizedBox(height: 16),
            const Text('이 알림에 대응을 시작하시겠습니까?'),
            const Text(
              '대응을 시작하면 다른 담당자에게 알림이 가지 않습니다.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('대응 시작'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(eventResponseServiceProvider.notifier);
      final success = await service.startResponse(log);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '대응을 시작했습니다' : '대응 시작에 실패했습니다'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          ref.invalidate(alertViewModelProvider);
        }
      }
    }
  }

  Future<void> _abandonResponse(
      BuildContext context, WidgetRef ref, EventLogModel log) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('대응 포기'),
        content: const Text(
          '대응을 포기하시겠습니까?\n다른 담당자에게 다시 알림이 전송됩니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('포기'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(eventResponseServiceProvider.notifier);
      final success = await service.abandonResponse(log);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '대응을 포기했습니다' : '대응 포기에 실패했습니다'),
            backgroundColor: success ? Colors.orange : Colors.red,
          ),
        );

        if (success) {
          ref.invalidate(alertViewModelProvider);
        }
      }
    }
  }

  Future<void> _showCompleteDialog(
      BuildContext context, WidgetRef ref, EventLogModel log) async {
    final memoController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('대응 완료'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('조치 내역을 입력해주세요:'),
            const SizedBox(height: 12),
            TextField(
              controller: memoController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '조치 내역...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('완료'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(eventResponseServiceProvider.notifier);
      final success =
          await service.completeResponse(log, memoController.text);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '대응을 완료했습니다' : '대응 완료에 실패했습니다'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          ref.invalidate(alertViewModelProvider);
        }
      }
    }

    memoController.dispose();
  }

  @override
  bool get wrapWithSafeArea => false;
}

/// 긴급 알림 배너
class _CriticalAlertBanner extends StatelessWidget {
  const _CriticalAlertBanner({
    required this.logs,
    required this.onRespond,
  });

  final List<EventLogModel> logs;
  final void Function(EventLogModel) onRespond;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  '긴급 알림 - 대응이 필요합니다',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...logs.map((log) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '[${log.source}] ${log.errorCode ?? '알림'}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => onRespond(log),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('대응하기'),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

/// 로그 카드
class _LogCard extends ConsumerWidget {
  const _LogCard({
    required this.log,
    required this.formatTime,
    required this.onRespond,
    required this.onAbandon,
    required this.onComplete,
  });

  final EventLogModel log;
  final String Function(DateTime) formatTime;
  final VoidCallback onRespond;
  final VoidCallback onAbandon;
  final VoidCallback onComplete;

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

  String _formatStartTime(DateTime startTime) {
    final hour = startTime.hour.toString().padLeft(2, '0');
    final minute = startTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute 시작';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelColor = _getLevelColor(log.logLevel);
    final isUnchecked = log.responseStatus == ResponseStatus.unchecked;
    final isInProgress = log.responseStatus == ResponseStatus.inProgress;

    // 현재 사용자가 대응 중인지 확인
    final authState = ref.watch(authServiceProvider);
    final isMyResponse = log.currentResponderId == authState.user?.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isUnchecked && log.logLevel.needsNotification
          ? levelColor.withOpacity(0.1)
          : isInProgress
              ? Colors.blue.withOpacity(0.05)
              : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Icon(
                  _getLevelIcon(log.logLevel),
                  color: levelColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '[${log.source}]',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  log.isHealthCheck ? Colors.green : Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              log.eventType.label,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ),
                          if (log.logLevel == LogLevel.critical) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '긴급',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (log.errorCode != null)
                        Text(
                          '에러 코드: ${log.errorCode}',
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                ),
                Text(
                  formatTime(log.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 상태 및 대응자 정보
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isUnchecked
                        ? Colors.orange.withOpacity(0.2)
                        : isInProgress
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    log.responseStatus.label,
                    style: TextStyle(
                      fontSize: 11,
                      color: isUnchecked
                          ? Colors.orange
                          : isInProgress
                              ? Colors.blue
                              : Colors.green,
                    ),
                  ),
                ),
                // 대응자 정보
                if (isInProgress && log.currentResponderName != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.person, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${log.currentResponderName}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (log.responseStartedAt != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      _formatStartTime(log.responseStartedAt!),
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ],
              ],
            ),

            // 액션 버튼
            if (isUnchecked || (isInProgress && isMyResponse)) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isUnchecked)
                    ElevatedButton.icon(
                      onPressed: onRespond,
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('대응하기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: levelColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  if (isInProgress && isMyResponse) ...[
                    OutlinedButton.icon(
                      onPressed: onAbandon,
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('포기'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: onComplete,
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('완료'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
