import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/data/models/mute_rule_model.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/domain/services/mute_rule_service.dart';
import 'package:window_app/domain/services/system_log_realtime_service.dart';
import 'package:window_app/presentation/pages/main/06_muted/muted_view_model.dart';
import 'package:window_app/presentation/widgets/admin_label.dart';

class MutedScreen extends HookConsumerWidget {
  const MutedScreen({super.key});

  static const String path = '/muted';
  static const String name = 'muted';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mutedViewModelProvider);
    final viewModel = ref.read(mutedViewModelProvider.notifier);
    final muteRules = ref.watch(muteRuleServiceProvider);
    final allLogs = ref.watch(systemLogRealtimeServiceProvider);
    final tabController = useTabController(initialLength: 2);

    final hasLogs = state.logs.isNotEmpty;
    final hasRules = muteRules.isNotEmpty;

    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
        elevation: 0,
        title: const Row(
          children: [
            Text('숨긴 알림'),
            AdminLabel(),
          ],
        ),
        actions: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () => viewModel.loadMutedLogs(),
            child: const Icon(CupertinoIcons.refresh, size: 22),
          ),
        ],
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
                      const Text('개별 알림'),
                      if (hasLogs) ...[
                        const SizedBox(width: 6),
                        _CupertinoBadge(
                          count: state.logs.length,
                          color: CupertinoColors.systemGrey,
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
                      const Text('숨김 규칙'),
                      if (hasRules) ...[
                        const SizedBox(width: 6),
                        _CupertinoBadge(
                          count: muteRules.length,
                          color: CupertinoColors.systemGrey,
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
          // 개별 알림 탭
          _MutedLogsTab(
            logs: state.logs,
            isLoading: state.isLoading,
            error: state.error,
            onUnmute: (id) async {
              final success = await viewModel.unmuteLogs(id);
              if (success && context.mounted) {
                _showToast(context, '알림이 다시 표시됩니다');
              }
            },
            onRefresh: () => viewModel.loadMutedLogs(),
          ),
          // 숨김 규칙 탭
          _MuteRulesTab(
            rules: muteRules,
            allLogs: allLogs,
            onDelete: (id) async {
              await ref.read(muteRuleServiceProvider.notifier).removeRule(id);
              if (context.mounted) {
                _showToast(context, '규칙이 삭제되었습니다');
              }
            },
          ),
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
                color: CupertinoColors.black.withValues(alpha: 0.8),
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
        horizontal: small ? 5 : 8,
        vertical: small ? 1 : 2,
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

/// 개별 숨긴 알림 탭
class _MutedLogsTab extends StatelessWidget {
  const _MutedLogsTab({
    required this.logs,
    required this.isLoading,
    required this.error,
    required this.onUnmute,
    required this.onRefresh,
  });

  final List<SystemLogEntity> logs;
  final bool isLoading;
  final String? error;
  final Function(String id) onUnmute;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    if (error != null) {
      return Center(
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
              error!,
              style: TextStyle(
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              onPressed: onRefresh,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (logs.isEmpty) {
      return Center(
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
              child: Icon(
                CupertinoIcons.bell_slash,
                size: 40,
                color: CupertinoColors.systemGrey,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '개별 숨긴 알림이 없습니다',
              style: TextStyle(
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '알림 메뉴에서 "이 알림 숨기기"로 숨길 수 있습니다',
              style: TextStyle(
                color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                fontSize: 13,
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
    required this.allLogs,
    required this.onDelete,
  });

  final List<MuteRule> rules;
  final List<SystemLogEntity> allLogs;
  final Function(String id) onDelete;

  /// 규칙에 매칭되는 로그 목록 반환
  List<SystemLogEntity> _getMatchingLogs(MuteRule rule) {
    return allLogs.where((log) {
      return rule.matches(logSource: log.source, logCode: log.code);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (rules.isEmpty) {
      return Center(
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
              child: Icon(
                CupertinoIcons.slider_horizontal_3,
                size: 40,
                color: CupertinoColors.systemGrey,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '숨김 규칙이 없습니다',
              style: TextStyle(
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '알림 메뉴에서 "이 종류의 알림 숨기기"로 추가',
              style: TextStyle(
                color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                fontSize: 13,
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
        final matchingLogs = _getMatchingLogs(rule);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _MuteRuleCard(
            rule: rule,
            matchingLogs: matchingLogs,
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
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // 로그 레벨 아이콘
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getLevelColor(context).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
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
                          color: _getLevelColor(context).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          log.logLevel.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _getLevelColor(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '[${log.source}]',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (log.code != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      log.code!,
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    log.formattedCreatedAt,
                    style: TextStyle(
                      fontSize: 11,
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.eye,
                      color: CupertinoColors.systemBlue.resolveFrom(context),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '해제',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.systemBlue.resolveFrom(context),
                      ),
                    ),
                  ],
                ),
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
        return CupertinoIcons.exclamationmark_triangle_fill;
      case 'error':
        return CupertinoIcons.xmark_circle_fill;
      case 'warning':
        return CupertinoIcons.exclamationmark_circle_fill;
      default:
        return CupertinoIcons.info_circle_fill;
    }
  }

  Color _getLevelColor(BuildContext context) {
    switch (log.logLevel.name) {
      case 'critical':
        return const Color(0xFFDC143C);
      case 'error':
        return CupertinoColors.systemOrange;
      case 'warning':
        return const Color(0xFFFFCC00);
      default:
        return CupertinoColors.systemBlue;
    }
  }
}

/// 숨김 규칙 카드 (확장 가능)
class _MuteRuleCard extends StatefulWidget {
  const _MuteRuleCard({
    required this.rule,
    required this.matchingLogs,
    required this.onDelete,
  });

  final MuteRule rule;
  final List<SystemLogEntity> matchingLogs;
  final VoidCallback onDelete;

  @override
  State<_MuteRuleCard> createState() => _MuteRuleCardState();
}

class _MuteRuleCardState extends State<_MuteRuleCard> {
  bool _isExpanded = false;

  Color _getLevelColor(SystemLogEntity log) {
    switch (log.logLevel.name) {
      case 'critical':
        return const Color(0xFFDC143C);
      case 'error':
        return CupertinoColors.systemOrange;
      case 'warning':
        return const Color(0xFFFFCC00);
      default:
        return CupertinoColors.systemBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLogs = widget.matchingLogs.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 헤더 (탭 가능)
          GestureDetector(
            onTap: hasLogs ? () => setState(() => _isExpanded = !_isExpanded) : null,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // 아이콘
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey5.resolveFrom(context),
                      borderRadius: BorderRadius.circular(10),
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
                        if (widget.rule.source != null)
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
                                  widget.rule.source!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        if (widget.rule.code != null) ...[
                          if (widget.rule.source != null) const SizedBox(height: 2),
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
                                  widget.rule.code!,
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
                        if (widget.rule.source == null && widget.rule.code == null)
                          Text(
                            '모든 알림',
                            style: TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            ),
                          ),
                        // 매칭 개수
                        const SizedBox(height: 4),
                        Text(
                          hasLogs ? '${widget.matchingLogs.length}개의 알림이 숨겨짐' : '숨겨진 알림 없음',
                          style: TextStyle(
                            fontSize: 11,
                            color: hasLogs
                                ? CupertinoColors.systemBlue.resolveFrom(context)
                                : CupertinoColors.tertiaryLabel.resolveFrom(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 확장 아이콘
                  if (hasLogs) ...[
                    Icon(
                      _isExpanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
                      size: 16,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                    const SizedBox(width: 8),
                  ],
                  // 삭제 버튼
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    onPressed: widget.onDelete,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.trash,
                            color: CupertinoColors.systemRed.resolveFrom(context),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '삭제',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.systemRed.resolveFrom(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 확장 콘텐츠 (매칭된 로그 목록)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6.resolveFrom(context),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    height: 1,
                    color: CupertinoColors.separator.resolveFrom(context),
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: widget.matchingLogs.length,
                      itemBuilder: (context, index) {
                        return _buildLogItem(context, widget.matchingLogs[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(BuildContext context, SystemLogEntity log) {
    final levelColor = _getLevelColor(log);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          // 레벨 표시
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: levelColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          // 로그 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: levelColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        log.logLevel.label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: levelColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '[${log.source}]',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (log.code != null)
                  Text(
                    log.code!,
                    style: TextStyle(
                      fontSize: 11,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          // 시간
          Text(
            log.formattedCreatedAt,
            style: TextStyle(
              fontSize: 10,
              color: CupertinoColors.tertiaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}
