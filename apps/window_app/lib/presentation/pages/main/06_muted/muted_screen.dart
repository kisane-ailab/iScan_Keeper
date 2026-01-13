import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/data/models/mute_rule_model.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/domain/services/mute_rule_service.dart';
import 'package:window_app/presentation/pages/main/06_muted/muted_view_model.dart';

class MutedScreen extends HookConsumerWidget {
  const MutedScreen({super.key});

  static const String path = '/muted';
  static const String name = 'muted';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mutedViewModelProvider);
    final viewModel = ref.read(mutedViewModelProvider.notifier);
    final muteRules = ref.watch(muteRuleServiceProvider);
    final tabController = useTabController(initialLength: 2);

    final hasLogs = state.logs.isNotEmpty;
    final hasRules = muteRules.isNotEmpty;
    final isEmpty = !hasLogs && !hasRules && !state.isLoading;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          // 헤더
          CupertinoSliverNavigationBar(
            largeTitle: const Text('숨긴 알림'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => viewModel.loadMutedLogs(),
              child: const Icon(CupertinoIcons.refresh),
            ),
          ),
          // 로딩 상태
          if (state.isLoading)
            const SliverFillRemaining(
              child: Center(child: CupertinoActivityIndicator()),
            )
          // 에러 상태
          else if (state.error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_triangle,
                      size: 48,
                      color: CupertinoColors.systemRed.resolveFrom(context),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.error!,
                      style: TextStyle(
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      onPressed: () => viewModel.loadMutedLogs(),
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
            )
          // 빈 상태
          else if (isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.bell_slash,
                      size: 64,
                      color: CupertinoColors.systemGrey.resolveFrom(context),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '숨긴 알림이 없습니다',
                      style: TextStyle(
                        fontSize: 17,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '알림을 숨기면 여기에 표시됩니다',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                      ),
                    ),
                  ],
                ),
              ),
            )
          // 콘텐츠 (탭)
          else ...[
            // 탭바
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        color: CupertinoColors.systemGrey.withOpacity(0.2),
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
                          const Text('개별 알림'),
                          if (hasLogs) ...[
                            const SizedBox(width: 6),
                            _Badge(count: state.logs.length),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      height: 40,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('숨김 규칙'),
                          if (hasRules) ...[
                            const SizedBox(width: 6),
                            _Badge(count: muteRules.length),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 탭 콘텐츠
            SliverFillRemaining(
              child: TabBarView(
                controller: tabController,
                children: [
                  // 개별 알림 탭
                  _MutedLogsTab(
                    logs: state.logs,
                    onUnmute: (id) async {
                      final success = await viewModel.unmuteLogs(id);
                      if (success && context.mounted) {
                        _showToast(context, '알림이 다시 표시됩니다');
                      }
                    },
                  ),
                  // 숨김 규칙 탭
                  _MuteRulesTab(
                    rules: muteRules,
                    onDelete: (id) async {
                      await ref.read(muteRuleServiceProvider.notifier).removeRule(id);
                      if (context.mounted) {
                        _showToast(context, '규칙이 삭제되었습니다');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: CupertinoColors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message,
                style: const TextStyle(color: CupertinoColors.white),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}

/// 뱃지 위젯
class _Badge extends StatelessWidget {
  const _Badge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// 개별 숨긴 알림 탭
class _MutedLogsTab extends StatelessWidget {
  const _MutedLogsTab({
    required this.logs,
    required this.onUnmute,
  });

  final List<SystemLogEntity> logs;
  final Function(String id) onUnmute;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.bell_slash,
              size: 48,
              color: CupertinoColors.systemGrey.resolveFrom(context),
            ),
            const SizedBox(height: 12),
            Text(
              '개별 숨긴 알림이 없습니다',
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _MutedLogCard(
            log: log,
            onUnmute: () => onUnmute(log.id),
          ),
        );
      },
    );
  }
}

/// 숨김 규칙 탭
class _MuteRulesTab extends StatelessWidget {
  const _MuteRulesTab({
    required this.rules,
    required this.onDelete,
  });

  final List<MuteRule> rules;
  final Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    if (rules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.slider_horizontal_3,
              size: 48,
              color: CupertinoColors.systemGrey.resolveFrom(context),
            ),
            const SizedBox(height: 12),
            Text(
              '숨김 규칙이 없습니다',
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '알림 메뉴에서 "이 종류의 알림 숨기기"로 추가',
              style: TextStyle(
                fontSize: 13,
                color: CupertinoColors.tertiaryLabel.resolveFrom(context),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rules.length,
      itemBuilder: (context, index) {
        final rule = rules[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _MuteRuleCard(
            rule: rule,
            onDelete: () => onDelete(rule.id),
          ),
        );
      },
    );
  }
}

/// 숨긴 로그 카드
class _MutedLogCard extends StatelessWidget {
  const _MutedLogCard({
    required this.log,
    required this.onUnmute,
  });

  final SystemLogEntity log;
  final VoidCallback onUnmute;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator.resolveFrom(context),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 로그 레벨 아이콘
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getLevelColor(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getLevelIcon(),
                color: _getLevelColor(context),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // 로그 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getLevelColor(context).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          log.logLevel.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getLevelColor(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          log.source,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (log.code != null)
                    Text(
                      log.code!,
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    log.formattedCreatedAt,
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                    ),
                  ),
                ],
              ),
            ),
            // 숨김 해제 버튼
            CupertinoButton(
              padding: const EdgeInsets.all(8),
              onPressed: onUnmute,
              child: Icon(
                CupertinoIcons.eye,
                color: CupertinoColors.systemBlue.resolveFrom(context),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getLevelIcon() {
    switch (log.logLevel.name) {
      case 'critical':
        return CupertinoIcons.exclamationmark_octagon_fill;
      case 'error':
        return CupertinoIcons.xmark_circle_fill;
      case 'warning':
        return CupertinoIcons.exclamationmark_triangle_fill;
      default:
        return CupertinoIcons.info_circle_fill;
    }
  }

  Color _getLevelColor(BuildContext context) {
    switch (log.logLevel.name) {
      case 'critical':
        return CupertinoColors.systemPurple.resolveFrom(context);
      case 'error':
        return CupertinoColors.systemRed.resolveFrom(context);
      case 'warning':
        return CupertinoColors.systemOrange.resolveFrom(context);
      default:
        return CupertinoColors.systemBlue.resolveFrom(context);
    }
  }
}

/// 숨김 규칙 카드
class _MuteRuleCard extends StatelessWidget {
  const _MuteRuleCard({
    required this.rule,
    required this.onDelete,
  });

  final MuteRule rule;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator.resolveFrom(context),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 아이콘
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5.resolveFrom(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                CupertinoIcons.bell_slash_fill,
                color: CupertinoColors.systemGrey.resolveFrom(context),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // 규칙 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (rule.source != null) ...[
                    Row(
                      children: [
                        Text(
                          'Source: ',
                          style: TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.secondaryLabel.resolveFrom(context),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            rule.source!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                  ],
                  if (rule.code != null) ...[
                    Row(
                      children: [
                        Text(
                          'Code: ',
                          style: TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.secondaryLabel.resolveFrom(context),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            rule.code!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (rule.source == null && rule.code == null)
                    Text(
                      '모든 알림',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                ],
              ),
            ),
            // 삭제 버튼
            CupertinoButton(
              padding: const EdgeInsets.all(8),
              onPressed: onDelete,
              child: Icon(
                CupertinoIcons.trash,
                color: CupertinoColors.systemRed.resolveFrom(context),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
