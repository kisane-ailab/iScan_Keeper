import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/data/models/user_model.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/domain/services/event_response_service.dart';
import 'package:window_app/domain/services/mute_rule_service.dart';
import 'package:window_app/domain/services/read_status_service.dart';
import 'package:window_app/domain/services/system_log_realtime_service.dart';
import 'package:window_app/presentation/pages/main/05_health_check/health_check_view_model.dart';
import 'package:window_app/presentation/widgets/admin_label.dart';
import 'package:window_app/presentation/widgets/mute_rule_dialog.dart';

/// 정렬 필드
enum SortField {
  createdAt('생성시간'),
  updatedAt('업데이트시간');

  final String label;
  const SortField(this.label);
}

/// 정렬 순서
enum SortOrder {
  desc('최신순'),
  asc('오래된순');

  final String label;
  const SortOrder(this.label);
}

class HealthCheckScreen extends HookConsumerWidget {
  const HealthCheckScreen({super.key});

  static const String path = '/health-check';
  static const String name = 'health-check';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(healthCheckViewModelProvider);
    final viewModel = ref.read(healthCheckViewModelProvider.notifier);
    final tabController = useTabController(initialLength: 2);

    // 관리자 여부 확인
    final currentUserAsync = ref.watch(currentUserDetailProvider);
    final isAdmin = currentUserAsync.when(
      data: (user) => user?.isAdmin ?? false,
      loading: () => false,
      error: (e, s) => false,
    );

    // 읽음 상태 - 안읽은 개수 계산 (탭별 표시용)
    final readState = ref.watch(readStatusServiceProvider);
    final productionUnreadCount = state.productionLogs
        .where((log) => !readState.readHealthCheckIds.contains(log.id))
        .length;
    final developmentUnreadCount = state.developmentLogs
        .where((log) => !readState.readHealthCheckIds.contains(log.id))
        .length;

    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
        elevation: 0,
        title: const Row(
          children: [
            Text('헬스체크'),
            AdminLabel(),
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
                      const Icon(CupertinoIcons.circle_fill, size: 8, color: CupertinoColors.systemGreen),
                      const SizedBox(width: 6),
                      const Text('운영중'),
                      if (productionUnreadCount > 0) ...[
                        const SizedBox(width: 6),
                        _StatusBadge(
                          count: productionUnreadCount,
                          color: CupertinoColors.systemOrange,
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
                      const Icon(CupertinoIcons.circle_fill, size: 8, color: CupertinoColors.systemYellow),
                      const SizedBox(width: 6),
                      const Text('개발중'),
                      if (developmentUnreadCount > 0) ...[
                        const SizedBox(width: 6),
                        _StatusBadge(
                          count: developmentUnreadCount,
                          color: CupertinoColors.systemYellow,
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
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: TabBarView(
          controller: tabController,
          children: [
            _HealthCheckGrid(
              logs: state.productionLogs,
              state: state,
              viewModel: viewModel,
              isAdmin: isAdmin,
              emptyMessage: '운영 환경 헬스체크 대기 중...',
              emptyIcon: CupertinoIcons.checkmark_shield,
            ),
            _HealthCheckGrid(
              logs: state.developmentLogs,
              state: state,
              viewModel: viewModel,
              isAdmin: isAdmin,
              emptyMessage: '개발 환경 헬스체크 대기 중...',
              emptyIcon: CupertinoIcons.hammer,
            ),
          ],
        ),
      ),
    );
  }
}

/// 상태 뱃지
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
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

/// 헬스체크 그리드 뷰
class _HealthCheckGrid extends HookConsumerWidget {
  const _HealthCheckGrid({
    required this.logs,
    required this.state,
    required this.viewModel,
    required this.isAdmin,
    required this.emptyMessage,
    required this.emptyIcon,
  });

  final List<SystemLogEntity> logs;
  final HealthCheckState state;
  final HealthCheckViewModel viewModel;
  final bool isAdmin;
  final String emptyMessage;
  final IconData emptyIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 필터 상태 (기본값: 모두 선택)
    final selectedLevels = useState<Set<LogLevel>>(Set.from(LogLevel.values));
    // 정렬 상태
    final sortField = useState(SortField.createdAt);
    final sortOrder = useState(SortOrder.desc);

    if (logs.isEmpty) {
      return _EmptyState(message: emptyMessage, icon: emptyIcon);
    }

    // 소스별로 그룹화하여 최신 상태만 표시
    final groupedBySource = <String, SystemLogEntity>{};
    for (final log in logs) {
      if (!groupedBySource.containsKey(log.source) ||
          log.createdAt.isAfter(groupedBySource[log.source]!.createdAt)) {
        groupedBySource[log.source] = log;
      }
    }
    final latestLogs = groupedBySource.values.toList();

    // 필터 적용
    final filteredLogs = latestLogs
        .where((log) => selectedLevels.value.contains(log.logLevel))
        .toList();

    // 정렬 적용
    filteredLogs.sort((a, b) {
      final aTime = sortField.value == SortField.createdAt
          ? a.createdAt
          : a.updatedAt;
      final bTime = sortField.value == SortField.createdAt
          ? b.createdAt
          : b.updatedAt;
      return sortOrder.value == SortOrder.desc
          ? bTime.compareTo(aTime)
          : aTime.compareTo(bTime);
    });

    return Column(
      children: [
        // 요약 헤더 + 네온 필터 + 정렬
        _SummaryHeader(
          logs: latestLogs,
          selectedLevels: selectedLevels.value,
          onToggleLevel: (level) {
            final newSet = Set<LogLevel>.from(selectedLevels.value);
            if (newSet.contains(level)) {
              newSet.remove(level);
            } else {
              newSet.add(level);
            }
            selectedLevels.value = newSet;
          },
          sortField: sortField.value,
          sortOrder: sortOrder.value,
          onSortFieldChanged: (field) => sortField.value = field,
          onSortOrderChanged: (order) => sortOrder.value = order,
        ),
        // 그리드 (각 카드 독립적 높이)
        Expanded(
          child: filteredLogs.isEmpty
              ? Center(
                  child: Text(
                    '선택된 필터에 해당하는 항목이 없습니다',
                    style: TextStyle(
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      fontSize: 14,
                    ),
                  ),
                )
              : ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: MasonryGridView.count(
                    crossAxisCount: _getCrossAxisCount(context),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      final log = filteredLogs[index];
                      // 해당 소스의 전체 로그 (히스토리용)
                      final sourceLogs = logs.where((l) => l.source == log.source).toList();
                      return _HealthStatusCard(
                        entity: log,
                        historyLogs: sourceLogs,
                        isAdmin: isAdmin,
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 900) return 3;
    if (width > 600) return 2;
    return 1;
  }
}

/// 요약 헤더 + 네온 필터 + 정렬
class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({
    required this.logs,
    required this.selectedLevels,
    required this.onToggleLevel,
    required this.sortField,
    required this.sortOrder,
    required this.onSortFieldChanged,
    required this.onSortOrderChanged,
  });

  final List<SystemLogEntity> logs;
  final Set<LogLevel> selectedLevels;
  final void Function(LogLevel) onToggleLevel;
  final SortField sortField;
  final SortOrder sortOrder;
  final void Function(SortField) onSortFieldChanged;
  final void Function(SortOrder) onSortOrderChanged;

  @override
  Widget build(BuildContext context) {
    final criticalCount = logs.where((l) => l.logLevel == LogLevel.critical).length;
    final errorCount = logs.where((l) => l.logLevel == LogLevel.error).length;
    final warningCount = logs.where((l) => l.logLevel == LogLevel.warning).length;
    final okCount = logs.where((l) => l.logLevel == LogLevel.info).length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.chart_bar_square,
            size: 20,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
          const SizedBox(width: 10),
          Text(
            '총 ${logs.length}개 소스',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
          const SizedBox(width: 16),
          // 정렬 UI
          _SortSelector(
            sortField: sortField,
            sortOrder: sortOrder,
            onSortFieldChanged: onSortFieldChanged,
            onSortOrderChanged: onSortOrderChanged,
          ),
          const Spacer(),
          // 네온 필터 칩들
          _NeonFilterChip(
            label: 'Critical',
            count: criticalCount,
            color: const Color(0xFFFF1744),
            isSelected: selectedLevels.contains(LogLevel.critical),
            onTap: () => onToggleLevel(LogLevel.critical),
          ),
          const SizedBox(width: 8),
          _NeonFilterChip(
            label: 'Error',
            count: errorCount,
            color: const Color(0xFFFF9100),
            isSelected: selectedLevels.contains(LogLevel.error),
            onTap: () => onToggleLevel(LogLevel.error),
          ),
          const SizedBox(width: 8),
          _NeonFilterChip(
            label: 'Warning',
            count: warningCount,
            color: const Color(0xFFFFEA00),
            isSelected: selectedLevels.contains(LogLevel.warning),
            onTap: () => onToggleLevel(LogLevel.warning),
          ),
          const SizedBox(width: 8),
          _NeonFilterChip(
            label: 'OK',
            count: okCount,
            color: const Color(0xFF00E676),
            isSelected: selectedLevels.contains(LogLevel.info),
            onTap: () => onToggleLevel(LogLevel.info),
          ),
        ],
      ),
    );
  }
}

/// 정렬 선택기
class _SortSelector extends StatelessWidget {
  const _SortSelector({
    required this.sortField,
    required this.sortOrder,
    required this.onSortFieldChanged,
    required this.onSortOrderChanged,
  });

  final SortField sortField;
  final SortOrder sortOrder;
  final void Function(SortField) onSortFieldChanged;
  final void Function(SortOrder) onSortOrderChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 정렬 필드 선택
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6.resolveFrom(context),
            borderRadius: BorderRadius.circular(6),
          ),
          child: PopupMenuButton<SortField>(
            tooltip: '정렬 기준',
            initialValue: sortField,
            onSelected: onSortFieldChanged,
            offset: const Offset(0, 32),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.arrow_up_arrow_down,
                  size: 12,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
                const SizedBox(width: 4),
                Text(
                  sortField.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  CupertinoIcons.chevron_down,
                  size: 10,
                  color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                ),
              ],
            ),
            itemBuilder: (context) => SortField.values
                .map((field) => PopupMenuItem<SortField>(
                      value: field,
                      height: 36,
                      child: Text(
                        field.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: field == sortField ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(width: 6),
        // 정렬 순서 토글
        GestureDetector(
          onTap: () => onSortOrderChanged(
            sortOrder == SortOrder.desc ? SortOrder.asc : SortOrder.desc,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6.resolveFrom(context),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  sortOrder == SortOrder.desc
                      ? CupertinoIcons.arrow_down
                      : CupertinoIcons.arrow_up,
                  size: 12,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
                const SizedBox(width: 4),
                Text(
                  sortOrder.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 네온 필터 칩
class _NeonFilterChip extends StatelessWidget {
  const _NeonFilterChip({
    required this.label,
    required this.count,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.6),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              GlowIcon(
                CupertinoIcons.circle_fill,
                size: 8,
                color: color,
                glowColor: color,
              )
            else
              Icon(
                CupertinoIcons.circle,
                size: 8,
                color: color.withValues(alpha: 0.4),
              ),
            const SizedBox(width: 6),
            Text(
              '$label $count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : color.withValues(alpha: 0.5),
                shadows: isSelected
                    ? [
                        Shadow(
                          color: color.withValues(alpha: 0.8),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 요약 칩 (기존 - 미사용)
class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// 빈 상태 위젯
class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.message,
    required this.icon,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey5.resolveFrom(context),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              size: 48,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '시스템에서 헬스체크 로그를 수신하면 여기에 표시됩니다',
            style: TextStyle(
              color: CupertinoColors.tertiaryLabel.resolveFrom(context),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// 헬스 상태 카드
class _HealthStatusCard extends HookConsumerWidget {
  const _HealthStatusCard({
    required this.entity,
    required this.historyLogs,
    required this.isAdmin,
  });

  final SystemLogEntity entity;
  final List<SystemLogEntity> historyLogs;
  final bool isAdmin;

  Color _getLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.critical:
        return const Color(0xFFDC143C);
      case LogLevel.error:
        return CupertinoColors.systemOrange;
      case LogLevel.warning:
        return const Color(0xFFFFCC00);
      case LogLevel.info:
        return CupertinoColors.systemGreen;
    }
  }

  IconData _getLevelIcon(LogLevel level) {
    switch (level) {
      case LogLevel.critical:
        return CupertinoIcons.exclamationmark_triangle_fill;
      case LogLevel.error:
        return CupertinoIcons.xmark_circle_fill;
      case LogLevel.warning:
        return CupertinoIcons.exclamationmark_circle_fill;
      case LogLevel.info:
        return CupertinoIcons.checkmark_circle_fill;
    }
  }

  String _getLevelText(LogLevel level) {
    switch (level) {
      case LogLevel.critical:
        return '심각';
      case LogLevel.error:
        return '오류';
      case LogLevel.warning:
        return '경고';
      case LogLevel.info:
        return '정상';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelColor = _getLevelColor(entity.logLevel);
    final isExpanded = useState(false);

    // 읽음 상태
    final readStatusService = ref.read(readStatusServiceProvider.notifier);
    final readState = ref.watch(readStatusServiceProvider);
    final isRead = readState.readHealthCheckIds.contains(entity.id);

    // 확장 시 읽음 처리
    useEffect(() {
      if (isExpanded.value && !isRead) {
        readStatusService.markHealthCheckAsRead(entity.id);
      }
      return null;
    }, [isExpanded.value]);

    // Mute 애니메이션
    final isMuting = useState(false);
    final isMuteComplete = useState(false);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final fadeAnimation = useAnimation(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    Future<void> performMute({required bool isSingle, MuteRuleDialogResult? ruleResult}) async {
      isMuting.value = true;
      await animationController.forward();
      isMuteComplete.value = true;
      await Future.delayed(const Duration(milliseconds: 200));

      if (isSingle) {
        await ref.read(systemLogRealtimeServiceProvider.notifier)
            .setLogMuted(entity.id, true);
      } else if (ruleResult != null) {
        await ref.read(muteRuleServiceProvider.notifier).addRule(
          source: ruleResult.effectiveSource,
          code: ruleResult.effectiveCode,
        );
      }
    }

    return ClipRect(
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        alignment: Alignment.topCenter,
        heightFactor: isMuteComplete.value ? 0.0 : 1.0,
        child: AnimatedOpacity(
          opacity: isMuting.value ? (1.0 - fadeAnimation) : 1.0,
          duration: const Duration(milliseconds: 50),
          child: GestureDetector(
            onTap: () => isExpanded.value = !isExpanded.value,
            child: Opacity(
              opacity: isRead ? 0.6 : 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: levelColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: levelColor.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 헤더 (상태 표시)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: levelColor.withValues(alpha: 0.08),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    child: Row(
                      children: [
                        // 상태 아이콘
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: levelColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getLevelIcon(entity.logLevel),
                            color: levelColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 소스 이름 & 상태
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entity.source,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                                  color: isRead
                                      ? CupertinoColors.secondaryLabel.resolveFrom(context)
                                      : CupertinoColors.label.resolveFrom(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: levelColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _getLevelText(entity.logLevel),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: levelColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // 메뉴 (관리자 전용)
                        if (isAdmin)
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'mute_single') {
                                await performMute(isSingle: true);
                              } else if (value == 'mute_rule') {
                                final result = await MuteRuleDialog.show(
                                  context: context,
                                  source: entity.source,
                                  code: entity.code,
                                );
                                if (result != null) {
                                  await performMute(isSingle: false, ruleResult: result);
                                }
                              }
                            },
                            offset: const Offset(0, 40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: CupertinoColors.systemBackground.resolveFrom(context),
                            elevation: 4,
                            itemBuilder: (context) => [
                              PopupMenuItem<String>(
                                value: 'mute_single',
                                height: 40,
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.bell_slash, size: 16, color: CupertinoColors.systemGrey),
                                    const SizedBox(width: 8),
                                    const Text('이 알림 숨기기', style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'mute_rule',
                                height: 40,
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.bell_slash_fill, size: 16, color: CupertinoColors.systemGrey),
                                    const SizedBox(width: 8),
                                    const Text('이 종류의 알림 숨기기...', style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ),
                            ],
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                CupertinoIcons.ellipsis,
                                size: 16,
                                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // 상세 정보
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 코드 & 시간
                        Row(
                          children: [
                            if (entity.code != null) ...[
                              Icon(
                                CupertinoIcons.tag,
                                size: 14,
                                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  entity.code!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                    fontFamily: 'monospace',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ] else
                              const Spacer(),
                            const SizedBox(width: 8),
                            Icon(
                              CupertinoIcons.clock,
                              size: 14,
                              color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              entity.formattedCreatedAt,
                              style: TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                              ),
                            ),
                          ],
                        ),
                        // 설명 (기본 1줄, 펼치면 전체)
                        if (entity.description != null && entity.description!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            entity.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            ),
                            maxLines: isExpanded.value ? 10 : 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        // 확장 영역 (고정 높이, 스크롤 가능) - flutter_animate 사용
                        if (isExpanded.value)
                          Container(
                            height: 180,
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey6.resolveFrom(context),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                child: _buildExpandedContent(context),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 250.ms, curve: Curves.easeOut)
                              .slideY(
                                begin: -0.1,
                                end: 0,
                                duration: 300.ms,
                                curve: Curves.easeOutCubic,
                              )
                              .scaleY(
                                begin: 0.95,
                                end: 1.0,
                                alignment: Alignment.topCenter,
                                duration: 250.ms,
                                curve: Curves.easeOut,
                              ),
                        // 하단 버튼 영역
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 상세보기 토글
                            GestureDetector(
                              onTap: () => isExpanded.value = !isExpanded.value,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CupertinoIcons.chevron_down,
                                    size: 12,
                                    color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                                  )
                                      .animate(target: isExpanded.value ? 1 : 0)
                                      .rotate(
                                        begin: 0,
                                        end: 0.5,
                                        duration: 200.ms,
                                        curve: Curves.easeInOut,
                                      ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isExpanded.value ? '접기' : '상세보기',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // 복사 버튼
                            GestureDetector(
                              onTap: () => _copyToClipboard(context),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CupertinoIcons.doc_on_clipboard,
                                    size: 12,
                                    color: CupertinoColors.systemBlue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '복사',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: CupertinoColors.systemBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 히스토리
        if (historyLogs.length > 1) ...[
          Row(
            children: [
              Icon(
                CupertinoIcons.clock_fill,
                size: 14,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
              const SizedBox(width: 6),
              Text(
                '최근 기록 (${historyLogs.length}개)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...historyLogs.take(3).map((log) => _HistoryItem(log: log)),
          if (historyLogs.length > 3)
            Text(
              '외 ${historyLogs.length - 3}개 더...',
              style: TextStyle(
                fontSize: 11,
                color: CupertinoColors.tertiaryLabel.resolveFrom(context),
              ),
            ),
        ],
        // 페이로드
        if (entity.payload.isNotEmpty) ...[
          if (historyLogs.length > 1) const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                CupertinoIcons.doc_text,
                size: 14,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
              const SizedBox(width: 6),
              Text(
                'Payload',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: CupertinoColors.separator.resolveFrom(context),
                width: 0.5,
              ),
            ),
            child: Text(
              const JsonEncoder.withIndent('  ').convert(entity.payload),
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'monospace',
                color: CupertinoColors.label.resolveFrom(context),
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  void _copyToClipboard(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln('=== 헬스체크 상태 ===');
    buffer.writeln('소스: ${entity.source}');
    buffer.writeln('상태: ${_getLevelText(entity.logLevel)}');
    buffer.writeln('시간: ${entity.formattedCreatedAt}');
    if (entity.code != null) {
      buffer.writeln('코드: ${entity.code}');
    }
    if (entity.description != null && entity.description!.isNotEmpty) {
      buffer.writeln('설명: ${entity.description}');
    }
    if (entity.payload.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('=== Payload ===');
      buffer.writeln(const JsonEncoder.withIndent('  ').convert(entity.payload));
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(CupertinoIcons.checkmark_circle_fill, color: CupertinoColors.white, size: 18),
            SizedBox(width: 8),
            Text('클립보드에 복사됨'),
          ],
        ),
        backgroundColor: CupertinoColors.systemGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

/// 히스토리 아이템
class _HistoryItem extends StatelessWidget {
  const _HistoryItem({required this.log});

  final SystemLogEntity log;

  Color _getLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.critical:
        return const Color(0xFFDC143C);
      case LogLevel.error:
        return CupertinoColors.systemOrange;
      case LogLevel.warning:
        return const Color(0xFFFFCC00);
      case LogLevel.info:
        return CupertinoColors.systemGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getLevelColor(log.logLevel);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            log.formattedCreatedAt,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              log.logLevel.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
