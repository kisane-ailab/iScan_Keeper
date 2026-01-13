import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/domain/services/auth_service.dart';
import 'package:window_app/domain/services/event_response_service.dart';
import 'package:window_app/presentation/pages/main/05_health_check/health_check_view_model.dart';

class HealthCheckScreen extends HookConsumerWidget {
  const HealthCheckScreen({super.key});

  static const String path = '/health-check';
  static const String name = 'health-check';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(healthCheckViewModelProvider);
    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
        elevation: 0,
        title: Row(
          children: [
            const Text('헬스체크'),
            if (state.alertCount > 0) ...[
              const SizedBox(width: 10),
              _CupertinoBadge(
                count: state.alertCount,
                color: CupertinoColors.systemOrange,
              ),
            ],
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey5.resolveFrom(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(4),
              dividerColor: Colors.transparent,
              labelColor: CupertinoColors.label.resolveFrom(context),
              unselectedLabelColor: CupertinoColors.secondaryLabel.resolveFrom(context),
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              tabs: [
                Tab(
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('운영중'),
                      if (state.productionAlertCount > 0) ...[
                        const SizedBox(width: 6),
                        _CupertinoBadge(
                          count: state.productionAlertCount,
                          color: CupertinoColors.systemRed,
                          small: true,
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('개발중'),
                      if (state.developmentAlertCount > 0) ...[
                        const SizedBox(width: 6),
                        _CupertinoBadge(
                          count: state.developmentAlertCount,
                          color: CupertinoColors.systemOrange,
                          small: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // 운영 탭
          _HealthCheckTabContent(
            logs: state.productionLogs,
            emptyMessage: '운영중 헬스체크 대기 중...',
          ),
          // 개발중 탭
          _HealthCheckTabContent(
            logs: state.developmentLogs,
            emptyMessage: '개발중 헬스체크 대기 중...',
          ),
        ],
      ),
    );
  }
}

/// Cupertino 스타일 뱃지
class _CupertinoBadge extends StatelessWidget {
  const _CupertinoBadge({
    required this.count,
    required this.color,
    this.small = false,
  });

  final int count;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(small ? 8 : 10),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: CupertinoColors.white,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// 탭 콘텐츠 (Production/Development 공용)
class _HealthCheckTabContent extends HookConsumerWidget {
  const _HealthCheckTabContent({
    required this.logs,
    required this.emptyMessage,
  });

  final List<SystemLogEntity> logs;
  final String emptyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return logs.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5.resolveFrom(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    CupertinoIcons.heart_circle,
                    size: 40,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  emptyMessage,
                  style: TextStyle(
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '기기에서 상태 점검 로그를 수신합니다',
                  style: TextStyle(
                    color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final entity = logs[index];
              return _HealthCheckCard(
                entity: entity,
                onRespond: () => _showResponseDialog(context, ref, entity),
                onAbandon: () => _abandonResponse(context, ref, entity),
                onComplete: () => _showCompleteDialog(context, ref, entity),
              );
            },
          );
  }

  Future<void> _showResponseDialog(
      BuildContext context, WidgetRef ref, SystemLogEntity entity) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('대응 시작'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              _InfoRow(label: '소스', value: entity.source),
              if (entity.code != null)
                _InfoRow(label: '코드', value: entity.code!),
              _InfoRow(label: '레벨', value: entity.logLevel.label),
              _InfoRow(label: '환경', value: entity.environment.label),
              const SizedBox(height: 12),
              const Text(
                '이 헬스체크 알림에 대응을 시작하시겠습니까?',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('대응 시작'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(eventResponseServiceProvider.notifier);
      final success = await service.startResponse(entity);

      if (context.mounted) {
        _showCupertinoToast(
          context,
          success ? '대응을 시작했습니다' : '대응 시작에 실패했습니다',
          success,
        );
      }
    }
  }

  Future<void> _abandonResponse(
      BuildContext context, WidgetRef ref, SystemLogEntity entity) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('대응 포기'),
        content: const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text('대응을 포기하시겠습니까?'),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('포기'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(eventResponseServiceProvider.notifier);
      final success = await service.abandonResponse(entity);

      if (context.mounted) {
        _showCupertinoToast(
          context,
          success ? '대응을 포기했습니다' : '대응 포기에 실패했습니다',
          success,
        );
      }
    }
  }

  Future<void> _showCompleteDialog(
      BuildContext context, WidgetRef ref, SystemLogEntity entity) async {
    final memoController = TextEditingController();

    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('대응 완료'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              const Text('조치 내역을 입력해주세요:'),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: memoController,
                placeholder: '조치 내역...',
                maxLines: 3,
                padding: const EdgeInsets.all(12),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('완료'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(eventResponseServiceProvider.notifier);
      final success =
          await service.completeResponse(entity, memoController.text);

      if (context.mounted) {
        _showCupertinoToast(
          context,
          success ? '대응을 완료했습니다' : '대응 완료에 실패했습니다',
          success,
        );
      }
    }

    memoController.dispose();
  }

  void _showCupertinoToast(BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success
                  ? CupertinoIcons.checkmark_circle_fill
                  : CupertinoIcons.xmark_circle_fill,
              color: CupertinoColors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor:
            success ? CupertinoColors.systemGreen : CupertinoColors.systemRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

/// 정보 행 위젯
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

/// 헬스체크 카드 (실시간 경과시간 표시) - Cupertino 스타일
class _HealthCheckCard extends HookConsumerWidget {
  const _HealthCheckCard({
    required this.entity,
    required this.onRespond,
    required this.onAbandon,
    required this.onComplete,
  });

  final SystemLogEntity entity;
  final VoidCallback onRespond;
  final VoidCallback onAbandon;
  final VoidCallback onComplete;

  Color _getLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.critical:
        return const Color(0xFFDC143C);
      case LogLevel.error:
        return CupertinoColors.systemOrange;
      case LogLevel.warning:
        return const Color(0xFFFFCC00);
      default:
        return CupertinoColors.systemGreen;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelColor = _getLevelColor(entity.logLevel);

    // 현재 사용자가 대응 중인지 확인
    final authState = ref.watch(authServiceProvider);
    final isMyResponse = entity.currentResponderId == authState.user?.id;

    // 1초마다 리빌드하여 경과시간 업데이트 (발생 후 경과시간 + 대응 경과시간)
    final tick = useState(0);
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        tick.value++;
      });
      return timer.cancel;
    }, []);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(14),
        border: entity.needsNotification
            ? Border.all(color: levelColor.withValues(alpha: 0.5), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: entity.needsNotification
                ? levelColor.withValues(alpha: 0.15)
                : CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: levelColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    CupertinoIcons.heart_circle_fill,
                    color: levelColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '[${entity.source}]',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      if (entity.description != null &&
                          entity.description!.isNotEmpty)
                        Text(
                          entity.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      entity.formattedCreatedAt,
                      style: TextStyle(
                        fontSize: 11,
                        color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5.resolveFrom(context),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        entity.formattedCreatedElapsedTime,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 상태 및 대응자 정보
            Row(
              children: [
                // 레벨 뱃지
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: levelColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    entity.logLevel.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: levelColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // 상태 뱃지
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: entity.isUnchecked
                        ? CupertinoColors.systemOrange.withValues(alpha: 0.15)
                        : entity.isBeingResponded
                            ? CupertinoColors.systemBlue.withValues(alpha: 0.15)
                            : CupertinoColors.systemGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    entity.responseStatus.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: entity.isUnchecked
                          ? CupertinoColors.systemOrange
                          : entity.isBeingResponded
                              ? CupertinoColors.systemBlue
                              : CupertinoColors.systemGreen,
                    ),
                  ),
                ),
                // 대응자 정보 + 경과시간
                if (entity.isBeingResponded &&
                    entity.currentResponderName != null) ...[
                  const SizedBox(width: 12),
                  const Icon(
                    CupertinoIcons.person_fill,
                    size: 16,
                    color: CupertinoColors.systemBlue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    entity.currentResponderName!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.systemBlue,
                    ),
                  ),
                  // 경과 시간 (실시간)
                  if (entity.formattedElapsedTime != null) ...[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: CupertinoColors.systemBlue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            CupertinoIcons.timer,
                            size: 13,
                            color: CupertinoColors.systemBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            entity.formattedElapsedTime!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                              color: CupertinoColors.systemBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ),

            // 액션 버튼
            if (entity.isUnchecked ||
                (entity.isBeingResponded && isMyResponse)) ...[
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (entity.isUnchecked)
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: levelColor,
                      borderRadius: BorderRadius.circular(10),
                      minSize: 0,
                      onPressed: onRespond,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.play_fill,
                            size: 14,
                            color: CupertinoColors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '대응하기',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (entity.isBeingResponded && isMyResponse) ...[
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      color: CupertinoColors.systemRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      minSize: 0,
                      onPressed: onAbandon,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.xmark,
                            size: 14,
                            color: CupertinoColors.systemRed,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '포기',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.systemRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      color: CupertinoColors.systemGreen,
                      borderRadius: BorderRadius.circular(10),
                      minSize: 0,
                      onPressed: onComplete,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.checkmark,
                            size: 14,
                            color: CupertinoColors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '완료',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ],
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
