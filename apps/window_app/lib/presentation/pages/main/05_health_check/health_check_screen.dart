import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/data/models/enums/environment.dart';
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
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_clockwise),
            tooltip: '새로고침',
            onPressed: () async {
              await ref.read(systemLogRealtimeServiceProvider.notifier).refresh();
            },
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
              environment: Environment.production,
              isAdmin: isAdmin,
              emptyMessage: '운영 환경 헬스체크 대기 중...',
              emptyIcon: CupertinoIcons.checkmark_shield,
            ),
            _HealthCheckGrid(
              logs: state.developmentLogs,
              state: state,
              viewModel: viewModel,
              environment: Environment.development,
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
    required this.environment,
    required this.isAdmin,
    required this.emptyMessage,
    required this.emptyIcon,
  });

  final List<SystemLogEntity> logs;
  final HealthCheckState state;
  final HealthCheckViewModel viewModel;
  final Environment environment;
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

    // source+site 조합으로 그룹화하여 최신 상태만 표시
    final groupedBySourceSite = <String, SystemLogEntity>{};
    for (final log in logs) {
      // source와 site가 같으면 source만, 다르면 source|site로 키 생성
      final key = (log.site == null || log.site == log.source)
          ? log.source
          : '${log.source}|${log.site}';
      if (!groupedBySourceSite.containsKey(key) ||
          log.createdAt.isAfter(groupedBySourceSite[key]!.createdAt)) {
        groupedBySourceSite[key] = log;
      }
    }
    final latestLogs = groupedBySourceSite.values.toList();

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
        // 요약 헤더 + 브레드크럼 + 네온 필터 + 정렬
        _SummaryHeader(
          logs: latestLogs,
          state: state,
          viewModel: viewModel,
          environment: environment,
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
          child: logs.isEmpty
              // 원본 데이터가 없는 경우
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
                        child: Icon(
                          emptyIcon,
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
                    ],
                  ),
                )
              : filteredLogs.isEmpty
                  // 필터 적용 후 데이터가 없는 경우
                  ? Center(
                      child: Text(
                        '선택된 필터에 해당하는 항목이 없습니다',
                        style: TextStyle(
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                          fontSize: 14,
                        ),
                      ),
                    )
                  : LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = _getCrossAxisCount(context);
                    final padding = 16.0;
                    final spacing = 12.0;
                    final totalSpacing = spacing * (crossAxisCount - 1);
                    final availableWidth = constraints.maxWidth - (padding * 2) - totalSpacing;
                    final cardWidth = availableWidth / crossAxisCount;
                    final filter = state.getFilterForEnvironment(environment);
                    final groupingMode = filter.groupingMode;

                    return ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(padding),
                        child: SizedBox(
                          width: double.infinity,
                          child: groupingMode == GroupingMode.none
                            ? Wrap(
                                spacing: spacing,
                                runSpacing: spacing,
                                children: filteredLogs.map((log) {
                                  // 해당 source+site 조합의 전체 로그 (히스토리용) - 생성시간 내림차순
                                  final sourceSiteLogs = logs.where((l) {
                                    if (l.source != log.source) return false;
                                    // site가 둘 다 null이거나 같으면 매칭
                                    if (l.site == null && log.site == null) return true;
                                    return l.site == log.site;
                                  }).toList()
                                    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                                  return SizedBox(
                                    width: cardWidth,
                                    child: _HealthStatusCard(
                                      entity: log,
                                      historyLogs: sourceSiteLogs,
                                      isAdmin: isAdmin,
                                    ),
                                  );
                                }).toList(),
                              )
                            : _GroupedView(
                                logs: filteredLogs,
                                allLogs: logs,
                                groupingMode: groupingMode,
                                cardWidth: cardWidth,
                                spacing: spacing,
                                isAdmin: isAdmin,
                              ),
                        ),
                      ),
                    );
                  },
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

/// 요약 헤더 + 브레드크럼 + 네온 필터 + 정렬
class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({
    required this.logs,
    required this.state,
    required this.viewModel,
    required this.environment,
    required this.selectedLevels,
    required this.onToggleLevel,
    required this.sortField,
    required this.sortOrder,
    required this.onSortFieldChanged,
    required this.onSortOrderChanged,
  });

  final List<SystemLogEntity> logs;
  final HealthCheckState state;
  final HealthCheckViewModel viewModel;
  final Environment environment;
  final Set<LogLevel> selectedLevels;
  final void Function(LogLevel) onToggleLevel;
  final SortField sortField;
  final SortOrder sortOrder;
  final void Function(SortField) onSortFieldChanged;
  final void Function(SortOrder) onSortOrderChanged;

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _showDatePicker(BuildContext context, bool isStartDate) async {
    final filter = state.getFilterForEnvironment(environment);
    final initialDate = isStartDate ? filter.startDate : filter.endDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: isStartDate ? '시작일 선택' : '종료일 선택',
      cancelText: '취소',
      confirmText: '선택',
    );

    if (picked != null) {
      if (isStartDate) {
        viewModel.setStartDate(environment, picked);
      } else {
        viewModel.setEndDate(environment, picked);
      }
    }
  }

  List<BreadCrumbItem> _buildBreadcrumbItems(BuildContext context) {
    final items = <BreadCrumbItem>[];
    final filter = state.getFilterForEnvironment(environment);

    // Source 선택
    items.add(BreadCrumbItem(
      content: _BreadcrumbChip(
        label: filter.selectedSource ?? '전체',
        icon: CupertinoIcons.device_desktop,
        isSelected: filter.selectedSource != null,
        items: filter.availableSources,
        selectedValue: filter.selectedSource,
        onSelected: (value) => viewModel.setSourceFilter(environment, value),
      ),
    ));

    // Site 선택 (Source 선택 시에만)
    if (filter.selectedSource != null && filter.availableSites.isNotEmpty) {
      items.add(BreadCrumbItem(
        content: _BreadcrumbChip(
          label: filter.selectedSite ?? '전체',
          icon: CupertinoIcons.location,
          isSelected: filter.selectedSite != null,
          items: filter.availableSites,
          selectedValue: filter.selectedSite,
          onSelected: (value) => viewModel.setSiteFilter(environment, value),
        ),
      ));
    }

    // Code 선택 (Source 선택 시에만)
    if (filter.selectedSource != null) {
      items.add(BreadCrumbItem(
        content: _BreadcrumbChip(
          label: filter.selectedCode ?? '전체',
          icon: CupertinoIcons.tag,
          isSelected: filter.selectedCode != null,
          items: filter.availableCodes,
          selectedValue: filter.selectedCode,
          onSelected: (value) => viewModel.setCodeFilter(environment, value),
        ),
      ));
    }

    return items;
  }

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 첫 번째 행: 개수 + 정렬 + 네온 필터
          Row(
            children: [
              Icon(
                CupertinoIcons.chart_bar_square,
                size: 20,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
              const SizedBox(width: 10),
              Text(
                '총 ${logs.length}개',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
              ),
              const SizedBox(width: 12),
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
                label: '심각',
                count: criticalCount,
                color: const Color(0xFFFF1744),
                isSelected: selectedLevels.contains(LogLevel.critical),
                onTap: () => onToggleLevel(LogLevel.critical),
              ),
              const SizedBox(width: 8),
              _NeonFilterChip(
                label: '오류',
                count: errorCount,
                color: const Color(0xFFFF9100),
                isSelected: selectedLevels.contains(LogLevel.error),
                onTap: () => onToggleLevel(LogLevel.error),
              ),
              const SizedBox(width: 8),
              _NeonFilterChip(
                label: '경고',
                count: warningCount,
                color: const Color(0xFFFFEA00),
                isSelected: selectedLevels.contains(LogLevel.warning),
                onTap: () => onToggleLevel(LogLevel.warning),
              ),
              const SizedBox(width: 8),
              _NeonFilterChip(
                label: '정상',
                count: okCount,
                color: const Color(0xFF00E676),
                isSelected: selectedLevels.contains(LogLevel.info),
                onTap: () => onToggleLevel(LogLevel.info),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 두 번째 행: 브레드크럼 + 기간 필터
          Builder(
            builder: (context) {
              final filter = state.getFilterForEnvironment(environment);
              return Row(
                children: [
                  Icon(
                    CupertinoIcons.arrow_right_arrow_left,
                    size: 14,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6.resolveFrom(context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: BreadCrumb(
                      items: _buildBreadcrumbItems(context),
                      divider: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          CupertinoIcons.chevron_right,
                          size: 12,
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                      overflow: ScrollableOverflow(
                        keepLastDivider: false,
                        direction: Axis.horizontal,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // 기간 필터
                  Icon(
                    CupertinoIcons.calendar,
                    size: 14,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                  const SizedBox(width: 6),
                  // 시작일
                  GestureDetector(
                    onTap: () => _showDatePicker(context, true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: filter.startDate != null
                            ? CupertinoColors.systemBlue.withValues(alpha: 0.1)
                            : CupertinoColors.systemGrey6.resolveFrom(context),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: filter.startDate != null
                              ? CupertinoColors.systemBlue.withValues(alpha: 0.3)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            filter.startDate != null ? _formatDate(filter.startDate!) : '시작일',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: filter.startDate != null ? FontWeight.w600 : FontWeight.w500,
                              color: filter.startDate != null
                                  ? CupertinoColors.systemBlue
                                  : CupertinoColors.secondaryLabel.resolveFrom(context),
                            ),
                          ),
                          if (filter.startDate != null) ...[
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => viewModel.setStartDate(environment, null),
                              child: const Icon(
                                CupertinoIcons.xmark_circle_fill,
                                size: 12,
                                color: CupertinoColors.systemBlue,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '~',
                      style: TextStyle(
                        fontSize: 11,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                  ),
                  // 종료일
                  GestureDetector(
                    onTap: () => _showDatePicker(context, false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: filter.endDate != null
                            ? CupertinoColors.systemBlue.withValues(alpha: 0.1)
                            : CupertinoColors.systemGrey6.resolveFrom(context),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: filter.endDate != null
                              ? CupertinoColors.systemBlue.withValues(alpha: 0.3)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            filter.endDate != null ? _formatDate(filter.endDate!) : '종료일',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: filter.endDate != null ? FontWeight.w600 : FontWeight.w500,
                              color: filter.endDate != null
                                  ? CupertinoColors.systemBlue
                                  : CupertinoColors.secondaryLabel.resolveFrom(context),
                            ),
                          ),
                          if (filter.endDate != null) ...[
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => viewModel.setEndDate(environment, null),
                              child: const Icon(
                                CupertinoIcons.xmark_circle_fill,
                                size: 12,
                                color: CupertinoColors.systemBlue,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          // 세 번째 행: 그룹핑 모드 선택
          Builder(
            builder: (context) {
              final filter = state.getFilterForEnvironment(environment);
              return Row(
                children: [
                  Icon(
                    CupertinoIcons.square_grid_2x2,
                    size: 14,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '보기',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CupertinoSlidingSegmentedControl<GroupingMode>(
                    groupValue: filter.groupingMode,
                    children: {
                      for (final mode in GroupingMode.values)
                        mode: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            mode.label,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                    },
                    onValueChanged: (value) {
                      if (value != null) {
                        viewModel.setGroupingMode(environment, value);
                      }
                    },
                  ),
                ],
              );
            },
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
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 동그라미에만 glow 효과
            if (isSelected)
              GlowIcon(
                CupertinoIcons.circle_fill,
                size: 10,
                color: color,
                glowColor: color,
              )
            else
              Icon(
                CupertinoIcons.circle,
                size: 10,
                color: color.withValues(alpha: 0.4),
              ),
            const SizedBox(width: 6),
            Text(
              '$label $count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : color.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 그룹핑된 뷰
class _GroupedView extends StatelessWidget {
  const _GroupedView({
    required this.logs,
    required this.allLogs,
    required this.groupingMode,
    required this.cardWidth,
    required this.spacing,
    required this.isAdmin,
  });

  final List<SystemLogEntity> logs;
  final List<SystemLogEntity> allLogs;
  final GroupingMode groupingMode;
  final double cardWidth;
  final double spacing;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    // 그룹핑 키 추출
    final Map<String, List<SystemLogEntity>> groups = {};

    for (final log in logs) {
      final key = groupingMode == GroupingMode.bySource
          ? log.source
          : (log.site ?? '(사이트 없음)');

      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(log);
    }

    // 키 정렬
    final sortedKeys = groups.keys.toList()..sort();

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sortedKeys.map((key) {
          final groupLogs = groups[key]!;
          final icon = groupingMode == GroupingMode.bySource
              ? CupertinoIcons.device_desktop
              : CupertinoIcons.location;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 그룹 헤더
              Container(
                margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5.resolveFrom(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    key,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label.resolveFrom(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${groupLogs.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.systemBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 그룹 카드들
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: groupLogs.map((log) {
                // 해당 source+site 조합의 전체 로그 (히스토리용) - 생성시간 내림차순
                final sourceSiteLogs = allLogs.where((l) {
                  if (l.source != log.source) return false;
                  if (l.site == null && log.site == null) return true;
                  return l.site == log.site;
                }).toList()
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                return SizedBox(
                  width: cardWidth,
                  child: _HealthStatusCard(
                    entity: log,
                    historyLogs: sourceSiteLogs,
                    isAdmin: isAdmin,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        );
        }).toList(),
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

/// 일별 상태 타임라인 (GitHub/Supabase 스타일)
class _DailyStatusTimeline extends StatelessWidget {
  const _DailyStatusTimeline({
    required this.historyLogs,
    required this.daysToShow,
  });

  final List<SystemLogEntity> historyLogs;
  final int daysToShow;

  /// 로그 레벨에 따른 색상 (심각도 순)
  Color _getColorForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.critical:
        return const Color(0xFFDC143C); // 진한 빨강
      case LogLevel.error:
        return CupertinoColors.systemOrange;
      case LogLevel.warning:
        return const Color(0xFFFFCC00); // 노랑
      case LogLevel.info:
        return CupertinoColors.systemGreen;
    }
  }

  /// 로그 레벨 우선순위 (높을수록 심각)
  int _getLevelPriority(LogLevel level) {
    switch (level) {
      case LogLevel.critical:
        return 4;
      case LogLevel.error:
        return 3;
      case LogLevel.warning:
        return 2;
      case LogLevel.info:
        return 1;
    }
  }

  /// 특정 날짜의 최악 상태 계산
  LogLevel? _getWorstLevelForDate(DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final logsForDay = historyLogs.where((log) {
      return log.createdAt.isAfter(dayStart) && log.createdAt.isBefore(dayEnd);
    }).toList();

    if (logsForDay.isEmpty) return null;

    return logsForDay.reduce((a, b) {
      return _getLevelPriority(a.logLevel) >= _getLevelPriority(b.logLevel) ? a : b;
    }).logLevel;
  }

  /// 날짜별 로그 레벨별 개수 (심각 > 오류 > 경고 > 정상 순으로 표시)
  String _getLogCountsByLevelForDate(DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final logsForDay = historyLogs.where((log) {
      return log.createdAt.isAfter(dayStart) && log.createdAt.isBefore(dayEnd);
    }).toList();

    if (logsForDay.isEmpty) return '';

    // 레벨별 카운트
    final counts = <LogLevel, int>{};
    for (final log in logsForDay) {
      counts[log.logLevel] = (counts[log.logLevel] ?? 0) + 1;
    }

    // 우선순위 순으로 정렬 (심각 > 오류 > 경고 > 정상)
    final orderedLevels = [
      LogLevel.critical,
      LogLevel.error,
      LogLevel.warning,
      LogLevel.info,
    ];

    final parts = <String>[];
    for (final level in orderedLevels) {
      if (counts.containsKey(level) && counts[level]! > 0) {
        parts.add('${_getLevelLabel(level)}(${counts[level]}건)');
      }
    }

    return parts.join(' ');
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  String _getLevelLabel(LogLevel? level) {
    if (level == null) return '데이터 없음';
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
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(daysToShow, (i) {
      return DateTime(now.year, now.month, now.day).subtract(Duration(days: daysToShow - 1 - i));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Row(
          children: [
            Icon(
              CupertinoIcons.chart_bar_alt_fill,
              size: 12,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
            const SizedBox(width: 4),
            Text(
              '최근 $daysToShow일',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // 타임라인 박스들
        Row(
          children: days.map((date) {
            final worstLevel = _getWorstLevelForDate(date);
            final levelCounts = _getLogCountsByLevelForDate(date);
            final color = worstLevel != null
                ? _getColorForLevel(worstLevel)
                : CupertinoColors.systemGrey4.resolveFrom(context);
            final isToday = date.day == now.day &&
                           date.month == now.month &&
                           date.year == now.year;

            return Expanded(
              child: Tooltip(
                message: '${_formatDate(date)}${levelCounts.isNotEmpty ? ' - $levelCounts' : ' - 데이터 없음'}',
                preferBelow: false,
                child: Container(
                  height: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: worstLevel != null ? 0.85 : 0.3),
                    borderRadius: BorderRadius.circular(3),
                    border: isToday
                        ? Border.all(
                            color: CupertinoColors.label.resolveFrom(context),
                            width: 1.5,
                          )
                        : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        // 범례
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _LegendItem(
              color: CupertinoColors.systemGrey4.resolveFrom(context),
              label: '없음',
            ),
            const SizedBox(width: 8),
            _LegendItem(
              color: CupertinoColors.systemGreen,
              label: '정상',
            ),
            const SizedBox(width: 8),
            _LegendItem(
              color: const Color(0xFFFFCC00),
              label: '경고',
            ),
            const SizedBox(width: 8),
            _LegendItem(
              color: CupertinoColors.systemOrange,
              label: '오류',
            ),
            const SizedBox(width: 8),
            _LegendItem(
              color: const Color(0xFFDC143C),
              label: '심각',
            ),
          ],
        ),
      ],
    );
  }
}

/// 범례 아이템
class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
      ],
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
    final readState = ref.watch(readStatusServiceProvider);
    final isRead = readState.readHealthCheckIds.contains(entity.id);

    // 안읽은 기록 개수
    final unreadCount = historyLogs
        .where((log) => !readState.readHealthCheckIds.contains(log.id))
        .length;

    // 스크롤 컨트롤러
    final scrollController = useScrollController();

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
            child: Container(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 헤더 (상태 표시)
                      Row(
                        children: [
                          // 상태 아이콘 (glow 효과)
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: levelColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: entity.needsNotification
                                  ? [
                                      BoxShadow(
                                        color: levelColor.withValues(alpha: 0.4),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              _getLevelIcon(entity.logLevel),
                              color: levelColor,
                              size: 24,
                            ),
                          ),
                        const SizedBox(width: 12),
                        // 소스 이름 & Site & 상태
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Source 표시
                              Text(
                                entity.source,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: CupertinoColors.label.resolveFrom(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Site 표시 (source와 다를 때만)
                              if (entity.site != null && entity.site != entity.source) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.location,
                                      size: 12,
                                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        entity.site!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                      // 상세 정보
                      const SizedBox(height: 14),
                      Column(
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
                              color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              entity.formattedCreatedAt,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: CupertinoColors.label.resolveFrom(context),
                              ),
                            ),
                          ],
                        ),
                        // 설명 (고정 높이, 스크롤 가능)
                        const SizedBox(height: 8),
                        Container(
                          height: 48,
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6.resolveFrom(context),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: entity.description != null && entity.description!.isNotEmpty
                              ? SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  child: Text(
                                    entity.description!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: CupertinoColors.label.resolveFrom(context),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    '설명 없음',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                                    ),
                                  ),
                                ),
                        ),
                        // 일별 상태 타임라인 (GitHub/Supabase 스타일)
                        const SizedBox(height: 12),
                        _DailyStatusTimeline(
                          historyLogs: historyLogs,
                          daysToShow: 14,
                        ),
                        // 확장 영역 (최대 높이 제한, 내용에 맞게 축소) - flutter_animate 사용
                        if (isExpanded.value)
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 180),
                            child: Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey6.resolveFrom(context),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  scrollbarTheme: ScrollbarThemeData(
                                    thumbColor: WidgetStateProperty.all(
                                      CupertinoColors.systemGrey.withValues(alpha: 0.6),
                                    ),
                                    thickness: WidgetStateProperty.all(6),
                                    radius: const Radius.circular(3),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  physics: const ClampingScrollPhysics(),
                                  padding: const EdgeInsets.only(right: 16),
                                  child: _buildExpandedContent(context),
                                ),
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
                                    size: 14,
                                    color: CupertinoColors.label.resolveFrom(context),
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: CupertinoColors.label.resolveFrom(context),
                                    ),
                                  ),
                                  // 안읽은 개수 표시
                                  if (unreadCount > 0 && !isExpanded.value) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemRed,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '$unreadCount',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: CupertinoColors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
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
        // 히스토리 헤더
        Row(
          children: [
            Icon(
              CupertinoIcons.clock_fill,
              size: 14,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
            const SizedBox(width: 6),
            Text(
              '기록 (${historyLogs.length}개)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.chevron_left_slash_chevron_right,
              size: 12,
              color: CupertinoColors.tertiaryLabel.resolveFrom(context),
            ),
            const SizedBox(width: 4),
            Text(
              '상세정보',
              style: TextStyle(
                fontSize: 11,
                color: CupertinoColors.tertiaryLabel.resolveFrom(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...historyLogs.map((log) => _HistoryItem(log: log)),
      ],
    );
  }

}

/// 히스토리 아이템 (확장 가능 - 페이로드 표시)
class _HistoryItem extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = useState(false);
    final color = _getLevelColor(log.logLevel);

    // 읽음 상태 확인
    final readState = ref.watch(readStatusServiceProvider);
    final isRead = readState.readHealthCheckIds.contains(log.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 (클릭 가능)
          GestureDetector(
            onTap: () {
              isExpanded.value = !isExpanded.value;
              // 펼치면 읽음 처리
              if (isExpanded.value && !isRead) {
                ref.read(readStatusServiceProvider.notifier).markHealthCheckAsRead(log.id);
              }
            },
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
                    fontWeight: FontWeight.w500,
                    fontFamily: 'monospace',
                    color: CupertinoColors.label.resolveFrom(context),
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
                const SizedBox(width: 6),
                // 읽음/안읽음 태그
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: isRead
                        ? CupertinoColors.systemGrey4.resolveFrom(context)
                        : CupertinoColors.systemBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isRead ? '읽음' : '안읽음',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: isRead
                          ? CupertinoColors.secondaryLabel.resolveFrom(context)
                          : CupertinoColors.systemBlue,
                    ),
                  ),
                ),
                const Spacer(),
                // 확장 아이콘
                Icon(
                  isExpanded.value
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  size: 14,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
              ],
            ),
          ),
          // 확장된 상세 정보
          if (isExpanded.value)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8, left: 14),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6.resolveFrom(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 코드
                  if (log.code != null) ...[
                    _DetailRow(
                      icon: CupertinoIcons.tag,
                      label: '코드',
                      value: log.code!,
                      context: context,
                    ),
                    const SizedBox(height: 6),
                  ],
                  // 설명
                  if (log.description != null && log.description!.isNotEmpty) ...[
                    _DetailRow(
                      icon: CupertinoIcons.doc_text,
                      label: '설명',
                      value: log.description!,
                      context: context,
                    ),
                    const SizedBox(height: 6),
                  ],
                  // 전송 데이터
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.chevron_left_slash_chevron_right,
                        size: 12,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '전송 데이터',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
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
                      log.payload.isEmpty
                          ? '{}'
                          : const JsonEncoder.withIndent('  ').convert(log.payload),
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: CupertinoColors.label.resolveFrom(context),
                      ),
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 첨부 자료
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.paperclip,
                        size: 12,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '첨부 자료',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
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
                      log.attachments.isEmpty
                          ? '{}'
                          : const JsonEncoder.withIndent('  ').convert(log.attachments),
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: CupertinoColors.label.resolveFrom(context),
                      ),
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // 복사 버튼
                  GestureDetector(
                    onTap: () {
                      final buffer = StringBuffer();
                      buffer.writeln('[${log.source}${log.site != null ? ' - ${log.site}' : ''}]');
                      buffer.writeln('시간: ${log.formattedCreatedAt}');
                      buffer.writeln('레벨: ${log.logLevel.label}');
                      if (log.code != null) buffer.writeln('코드: ${log.code}');
                      if (log.description != null && log.description!.isNotEmpty) {
                        buffer.writeln('설명: ${log.description}');
                      }
                      buffer.writeln('');
                      buffer.writeln('전송 데이터:');
                      buffer.writeln(log.payload.isEmpty
                          ? '{}'
                          : const JsonEncoder.withIndent('  ').convert(log.payload));
                      buffer.writeln('');
                      buffer.writeln('첨부 자료:');
                      buffer.writeln(log.attachments.isEmpty
                          ? '{}'
                          : const JsonEncoder.withIndent('  ').convert(log.attachments));
                      Clipboard.setData(ClipboardData(text: buffer.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(CupertinoIcons.checkmark_circle_fill, color: CupertinoColors.white, size: 16),
                              const SizedBox(width: 8),
                              const Text('복사됨', style: TextStyle(color: CupertinoColors.white)),
                            ],
                          ),
                          backgroundColor: CupertinoColors.systemGreen,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
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
                            fontWeight: FontWeight.w500,
                            color: CupertinoColors.systemBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// 상세 정보 행 위젯
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.context,
  });

  final IconData icon;
  final String label;
  final String value;
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 12,
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
        ),
      ],
    );
  }
}

/// Breadcrumb 칩 위젯 (PopupMenu 포함)
class _BreadcrumbChip extends StatelessWidget {
  const _BreadcrumbChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.items,
    this.selectedValue,
    required this.onSelected,
  });

  static const String _allValue = '__all__';

  final String label;
  final IconData? icon;
  final bool isSelected;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == _allValue) {
          onSelected(null);
        } else {
          onSelected(value);
        }
      },
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      elevation: 4,
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: _allValue,
          height: 36,
          child: Row(
            children: [
              Icon(
                selectedValue == null
                    ? CupertinoIcons.checkmark_circle_fill
                    : CupertinoIcons.circle,
                size: 14,
                color: selectedValue == null
                    ? CupertinoColors.systemBlue
                    : CupertinoColors.systemGrey,
              ),
              const SizedBox(width: 8),
              const Text('전체', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        ...items.map((item) => PopupMenuItem<String>(
              value: item,
              height: 36,
              child: Row(
                children: [
                  Icon(
                    selectedValue == item
                        ? CupertinoIcons.checkmark_circle_fill
                        : CupertinoIcons.circle,
                    size: 14,
                    color: selectedValue == item
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.systemGrey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )),
      ],
      child: SizedBox(
        width: 100, // 고정 너비
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: isSelected
                      ? CupertinoColors.systemBlue
                      : CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.label.resolveFrom(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                CupertinoIcons.chevron_down,
                size: 10,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
