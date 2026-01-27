import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/data/models/enums/environment.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/data/models/enums/user_status.dart';
import 'package:window_app/data/models/notification_settings.dart';
import 'package:window_app/data/models/user_model.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/domain/services/auth_service.dart';
import 'package:window_app/domain/services/event_response_service.dart';
import 'package:window_app/domain/services/notification_settings_service.dart';
import 'package:window_app/domain/services/system_log_realtime_service.dart';
import 'package:window_app/infrastructure/system_tray/tray_manager.dart';
import 'package:window_app/presentation/pages/main/01_alert/alert_view_model.dart';
import 'package:window_app/presentation/pages/main/05_health_check/health_check_view_model.dart'
    show GroupingMode;
import 'package:window_app/presentation/widgets/admin_label.dart';
import 'package:window_app/presentation/widgets/mute_rule_dialog.dart';
import 'package:window_app/domain/services/mute_rule_service.dart';
import 'package:window_app/domain/services/read_status_service.dart';
import 'package:window_app/domain/services/system_log_realtime_service.dart' show systemLogRealtimeServiceProvider;

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

class AlertScreen extends HookConsumerWidget {
  const AlertScreen({super.key});

  static const String path = '/alert';
  static const String name = 'alert';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(alertViewModelProvider);
    final viewModel = ref.read(alertViewModelProvider.notifier);
    final tabController = useTabController(initialLength: 2);

    // 읽음 상태 - 안읽은 개수 계산 (탭별 표시용)
    final readState = ref.watch(readStatusServiceProvider);
    final productionUnreadCount = state.productionLogs
        .where((log) => !readState.readEventIds.contains(log.id))
        .length;
    final developmentUnreadCount = state.developmentLogs
        .where((log) => !readState.readEventIds.contains(log.id))
        .length;

    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
        elevation: 0,
        title: const Row(
          children: [
            Text('이벤트'),
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
                      const Text('운영중'),
                      if (productionUnreadCount > 0) ...[
                        const SizedBox(width: 6),
                        _CupertinoBadge(
                          count: productionUnreadCount,
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
                      if (developmentUnreadCount > 0) ...[
                        const SizedBox(width: 6),
                        _CupertinoBadge(
                          count: developmentUnreadCount,
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
          _AlertTabContent(
            logs: state.productionLogs,
            state: state,
            viewModel: viewModel,
            emptyMessage: '운영중 이벤트 대기 중...',
            emptyIcon: CupertinoIcons.checkmark_shield,
            environment: Environment.production,
          ),
          // 개발중 탭
          _AlertTabContent(
            logs: state.developmentLogs,
            state: state,
            viewModel: viewModel,
            emptyMessage: '개발중 이벤트 대기 중...',
            emptyIcon: CupertinoIcons.hammer,
            environment: Environment.development,
          ),
        ],
      ),
    );
  }
}

/// 요약 헤더 (개수 + 정렬 + 네온 필터 + 브레드크럼)
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
  final AlertState state;
  final AlertViewModel viewModel;
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
    final infoCount = logs.where((l) => l.logLevel == LogLevel.info).length;

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
                label: '정보',
                count: infoCount,
                color: const Color(0xFF2196F3),
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
class _AlertTabContent extends HookConsumerWidget {
  const _AlertTabContent({
    required this.logs,
    required this.state,
    required this.viewModel,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.environment,
  });

  final List<SystemLogEntity> logs;
  final AlertState state;
  final AlertViewModel viewModel;
  final String emptyMessage;
  final IconData emptyIcon;
  final Environment environment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAlwaysOnTop = ref.watch(alwaysOnTopStateProvider);
    final settings = ref.watch(notificationSettingsServiceProvider);

    // 정렬 상태
    final sortField = useState(SortField.createdAt);
    final sortOrder = useState(SortOrder.desc);

    // 로그 레벨 필터 상태 (기본: 모두 선택)
    final selectedLevels = useState<Set<LogLevel>>(Set.from(LogLevel.values));

    // 현재 유저 정보 (관리자 여부 확인)
    final currentUserAsync = ref.watch(currentUserDetailProvider);
    final isAdmin = currentUserAsync.when(
      data: (user) => user?.isAdmin ?? false,
      loading: () => false,
      error: (e, s) => false,
    );

    // 전체 로그에서 필터 상관없이 긴급 알림 가져오기
    final allLogs = ref.watch(systemLogRealtimeServiceProvider);
    final allEventLogs = allLogs.where((e) => e.isEvent).toList();
    final environmentLogs = allEventLogs.where((e) =>
      environment == Environment.production ? e.isProduction : e.isDevelopment
    ).toList();

    // 항상위 모드가 필요한 미대응 로그 찾기 (필터 적용 전 전체 기준)
    final alwaysOnTopLogs = environmentLogs.where((entity) {
      if (!entity.isUnchecked) return false;
      final action = settings.getActionForLevel(
        entity.logLevel,
        environment: entity.environment,
      );
      return action == NotificationAction.alwaysOnTop;
    }).toList();

    // 로그 레벨 필터 적용
    final filteredLogs = logs
        .where((log) => selectedLevels.value.contains(log.logLevel))
        .toList();

    // 정렬 적용
    final sortedLogs = List<SystemLogEntity>.from(filteredLogs);
    sortedLogs.sort((a, b) {
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
        // 요약 헤더 (개수 + 정렬 + 네온 필터 + 브레드크럼 + 기간)
        _SummaryHeader(
          logs: logs,
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

        // 항상 위 모드 배너 (항상위 필요 로그가 있을 때)
        if (isAlwaysOnTop && alwaysOnTopLogs.isNotEmpty)
          _CriticalAlertBanner(
            entities: alwaysOnTopLogs,
            onRespond: (entity) => _showResponseDialog(context, ref, entity),
          ),

        // 메인 콘텐츠
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
                      const SizedBox(height: 8),
                      Text(
                        '설정에서 알림 레벨별 동작을 변경할 수 있습니다',
                        style: TextStyle(
                          color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              : sortedLogs.isEmpty
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
                  : Builder(
                  builder: (context) {
                    final filter = state.getFilterForEnvironment(environment);
                    final groupingMode = filter.groupingMode;
                    final service = ref.read(systemLogRealtimeServiceProvider.notifier);
                    final hasMore = service.hasMoreData;
                    final isLoadingMore = service.isLoadingMore;

                    // 무한 스크롤 핸들러
                    bool handleScrollNotification(ScrollNotification notification) {
                      if (notification is ScrollEndNotification) {
                        final metrics = notification.metrics;
                        // 스크롤이 80% 이상 내려가면 추가 로딩
                        if (metrics.pixels >= metrics.maxScrollExtent * 0.8 && hasMore && !isLoadingMore) {
                          service.loadMore(
                            environment: environment == Environment.production ? 'production' : 'development',
                          );
                        }
                      }
                      return false;
                    }

                    if (groupingMode == GroupingMode.none) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: handleScrollNotification,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: sortedLogs.length + (hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            // 로딩 인디케이터
                            if (index == sortedLogs.length) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                  child: isLoadingMore
                                      ? const CupertinoActivityIndicator()
                                      : CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () => service.loadMore(
                                            environment: environment == Environment.production ? 'production' : 'development',
                                          ),
                                          child: const Text('더 보기'),
                                        ),
                                ),
                              );
                            }

                            final entity = sortedLogs[index];
                            return _LogCard(
                              entity: entity,
                              onRespond: () =>
                                  _showResponseDialog(context, ref, entity),
                              onAbandon: () => _abandonResponse(context, ref, entity),
                              onComplete: () =>
                                  _showCompleteDialog(context, ref, entity),
                              onAssign: isAdmin
                                  ? () => _showAssignDialog(context, ref, entity)
                                  : null,
                              onDelete: isAdmin
                                  ? () => _deleteLog(context, ref, entity)
                                  : null,
                              isAdmin: isAdmin,
                            );
                          },
                        ),
                      );
                    }

                    // 그룹핑 모드
                    return _AlertGroupedView(
                      logs: sortedLogs,
                      groupingMode: groupingMode,
                      isAdmin: isAdmin,
                      hasMore: hasMore,
                      isLoadingMore: isLoadingMore,
                      onLoadMore: () => service.loadMore(
                        environment: environment == Environment.production ? 'production' : 'development',
                      ),
                      onRespond: (entity) => _showResponseDialog(context, ref, entity),
                      onAbandon: (entity) => _abandonResponse(context, ref, entity),
                      onComplete: (entity) => _showCompleteDialog(context, ref, entity),
                      onAssign: isAdmin ? (entity) => _showAssignDialog(context, ref, entity) : null,
                      onDeleteGroup: isAdmin ? (logs) => _deleteGroupLogs(context, ref, logs) : null,
                      onDeleteLog: isAdmin ? (entity) => _deleteLog(context, ref, entity) : null,
                    );
                  },
                ),
        ),
      ],
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
                '이 알림에 대응을 시작하시겠습니까?\n대응을 시작하면 다른 담당자에게 알림이 가지 않습니다.',
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
          child: Text(
            '대응을 포기하시겠습니까?\n다른 담당자에게 다시 알림이 전송됩니다.',
          ),
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

  Future<void> _deleteLog(
      BuildContext context, WidgetRef ref, SystemLogEntity entity) async {
    try {
      final service = ref.read(systemLogRealtimeServiceProvider.notifier);
      await service.deleteLog(entity.id);

      if (context.mounted) {
        _showCupertinoToast(context, '이벤트가 삭제되었습니다', true);
      }
    } catch (e) {
      if (context.mounted) {
        final errorMsg = e.toString().toLowerCase();
        if (errorMsg.contains('in_progress') || errorMsg.contains('responder') || errorMsg.contains('대응')) {
          _showCupertinoToast(context, '대응 중인 이벤트는 삭제할 수 없습니다', false);
        } else {
          _showCupertinoToast(context, '삭제에 실패했습니다', false);
        }
      }
    }
  }

  Future<void> _deleteGroupLogs(
      BuildContext context, WidgetRef ref, List<SystemLogEntity> logs) async {
    try {
      final service = ref.read(systemLogRealtimeServiceProvider.notifier);
      final ids = logs.map((e) => e.id).toList();
      await service.deleteLogs(ids);

      if (context.mounted) {
        _showCupertinoToast(context, '${logs.length}건의 이벤트가 삭제되었습니다', true);
      }
    } catch (e) {
      if (context.mounted) {
        final errorMsg = e.toString().toLowerCase();
        if (errorMsg.contains('in_progress') || errorMsg.contains('responder') || errorMsg.contains('대응')) {
          _showCupertinoToast(context, '대응 중인 이벤트가 포함되어 삭제할 수 없습니다', false);
        } else {
          _showCupertinoToast(context, '삭제에 실패했습니다', false);
        }
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

  Future<void> _showAssignDialog(
      BuildContext context, WidgetRef ref, SystemLogEntity entity) async {
    final orgUsersAsync = ref.read(organizationUsersProvider.future);
    final users = await orgUsersAsync;

    if (!context.mounted) return;

    if (users.isEmpty) {
      _showCupertinoToast(context, '할당 가능한 팀원이 없습니다', false);
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AssignBottomSheet(
        entity: entity,
        users: users,
        onAssign: (user) async {
          Navigator.pop(context);
          final service = ref.read(eventResponseServiceProvider.notifier);
          final success = await service.assignResponse(entity, user);

          if (context.mounted) {
            _showCupertinoToast(
              context,
              success
                  ? '${user.name}님에게 [${entity.source}] 이슈를 할당했습니다'
                  : '할당에 실패했습니다',
              success,
            );
          }
        },
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

/// 할당 바텀시트
class _AssignBottomSheet extends StatelessWidget {
  const _AssignBottomSheet({
    required this.entity,
    required this.users,
    required this.onAssign,
  });

  final SystemLogEntity entity;
  final List<UserModel> users;
  final void Function(UserModel user) onAssign;

  Color _getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.online:
        return CupertinoColors.systemGreen;
      case UserStatus.offline:
        return CupertinoColors.systemGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: CupertinoColors.separator.resolveFrom(context),
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.person_badge_plus,
                  color: CupertinoColors.systemBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '담당자 할당',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '[${entity.source}] ${entity.code ?? ""}',
                        style: TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey5.resolveFrom(context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      CupertinoIcons.xmark,
                      size: 16,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 유저 목록
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final statusColor = _getStatusColor(user.status);
                final canAssign = user.status != UserStatus.offline;

                return InkWell(
                  onTap: canAssign ? () => onAssign(user) : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: CupertinoColors.separator.resolveFrom(context).withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // 상태 표시 원
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 유저 정보
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: canAssign
                                      ? CupertinoColors.label.resolveFrom(context)
                                      : CupertinoColors.tertiaryLabel.resolveFrom(context),
                                ),
                              ),
                              Text(
                                user.email,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 상태 뱃지
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            user.status.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                        if (canAssign) ...[
                          const SizedBox(width: 8),
                          Icon(
                            CupertinoIcons.chevron_right,
                            size: 16,
                            color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // 안내 문구
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              '오프라인 상태인 팀원에게는 할당할 수 없습니다',
              style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.tertiaryLabel.resolveFrom(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 긴급 알림 배너 (실시간 경과시간 표시, 스크롤 가능, 투명도/크기 조절)
class _CriticalAlertBanner extends HookWidget {
  const _CriticalAlertBanner({
    required this.entities,
    required this.onRespond,
  });

  final List<SystemLogEntity> entities;
  final void Function(SystemLogEntity) onRespond;

  static const double _minHeight = 120.0;
  static const double _maxHeight = 400.0;
  static const double _defaultHeight = 180.0;

  @override
  Widget build(BuildContext context) {
    // 1초마다 리빌드하여 경과시간 업데이트
    final tick = useState(0);
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        tick.value++;
      });
      return timer.cancel;
    }, []);

    // 배너 높이 상태
    final bannerHeight = useState(_defaultHeight);
    // 투명도 상태
    final opacity = useState(1.0);

    return Opacity(
      opacity: opacity.value,
      child: Container(
        width: double.infinity,
        height: bannerHeight.value,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFDC143C),
              const Color(0xFFB91C3C),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDC143C).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더 (고정)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      CupertinoIcons.exclamationmark_triangle_fill,
                      color: CupertinoColors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '긴급 알림 ${entities.length}건',
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  // 투명도 슬라이더
                  Icon(
                    CupertinoIcons.sun_min,
                    color: CupertinoColors.white.withValues(alpha: 0.7),
                    size: 14,
                  ),
                  SizedBox(
                    width: 80,
                    height: 20,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 3,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                        activeTrackColor: CupertinoColors.white,
                        inactiveTrackColor: CupertinoColors.white.withValues(alpha: 0.3),
                        thumbColor: CupertinoColors.white,
                        overlayColor: CupertinoColors.white.withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: opacity.value,
                        min: 0.3,
                        max: 1.0,
                        onChanged: (value) => opacity.value = value,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '대응 필요',
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 알림 목록 (스크롤 가능, 흰색 스크롤바)
            Expanded(
              child: RawScrollbar(
                thumbColor: CupertinoColors.white.withValues(alpha: 0.6),
                radius: const Radius.circular(4),
                thickness: 4,
                thumbVisibility: true,
                padding: const EdgeInsets.only(right: 4),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  itemCount: entities.length,
                  itemBuilder: (context, index) {
                    final entity = entities[index];
                    return SelectionArea(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                        children: [
                          // 번호 뱃지
                          Container(
                            width: 26,
                            height: 26,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: CupertinoColors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          // 소스 & 코드
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '[${entity.source}]',
                                  style: const TextStyle(
                                    color: CupertinoColors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (entity.code != null)
                                  Text(
                                    entity.code!,
                                    style: TextStyle(
                                      color: CupertinoColors.white.withValues(alpha: 0.8),
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          // 경과 시간 타이머
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: CupertinoColors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: CupertinoColors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              entity.formattedCreatedElapsedTime,
                              style: const TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // 대응 버튼
                          CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(8),
                            minSize: 0,
                            onPressed: () => onRespond(entity),
                            child: const Text(
                              '대응',
                              style: TextStyle(
                                color: Color(0xFFDC143C),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // 리사이즈 핸들
            GestureDetector(
              onVerticalDragUpdate: (details) {
                final newHeight = bannerHeight.value + details.delta.dy;
                bannerHeight.value = newHeight.clamp(_minHeight, _maxHeight);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeRow,
                child: Container(
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: CupertinoColors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 로그 카드 (실시간 경과시간 표시) - Cupertino 스타일
class _LogCard extends HookConsumerWidget {
  const _LogCard({
    super.key,
    required this.entity,
    required this.onRespond,
    required this.onAbandon,
    required this.onComplete,
    this.onAssign,
    this.onDelete,
    this.isAdmin = false,
  });

  final SystemLogEntity entity;
  final VoidCallback onRespond;
  final VoidCallback onAbandon;
  final VoidCallback onComplete;
  final VoidCallback? onAssign;
  final VoidCallback? onDelete;
  final bool isAdmin;

  Color _getLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.critical:
        return const Color(0xFFDC143C);
      case LogLevel.error:
        return CupertinoColors.systemOrange;
      case LogLevel.warning:
        return const Color(0xFFFFCC00);
      default:
        return CupertinoColors.systemBlue;
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
      default:
        return CupertinoIcons.info_circle_fill;
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

    // 확장 상태
    final isExpanded = useState(false);

    // 읽음 상태
    final readStatusService = ref.read(readStatusServiceProvider.notifier);
    final readState = ref.watch(readStatusServiceProvider);
    final isRead = readState.readEventIds.contains(entity.id);

    // 확장 시 읽음 처리
    useEffect(() {
      if (isExpanded.value && !isRead) {
        readStatusService.markEventAsRead(entity.id);
      }
      return null;
    }, [isExpanded.value]);

    // Mute 애니메이션 상태
    final isMuting = useState(false);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final fadeAnimation = useAnimation(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
    final scaleAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      ),
    );

    // Mute 완료 상태 (높이 축소용)
    final isMuteComplete = useState(false);

    // Mute 실행 함수
    Future<void> performMute({required bool isSingle, MuteRuleDialogResult? ruleResult}) async {
      isMuting.value = true;
      await animationController.forward();

      // 애니메이션 완료 후 높이 축소
      isMuteComplete.value = true;

      // 약간의 딜레이 후 실제 mute 처리
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
          child: Transform.scale(
            scale: isMuting.value ? scaleAnimation : 1.0,
            child: SelectionArea(
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
                    _getLevelIcon(entity.logLevel),
                    color: levelColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '[${entity.source}]',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: entity.isHealthCheck
                                  ? CupertinoColors.systemGreen.withValues(alpha: 0.15)
                                  : CupertinoColors.systemBlue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              entity.category.label,
                              style: TextStyle(
                                color: entity.isHealthCheck
                                    ? CupertinoColors.systemGreen
                                    : CupertinoColors.systemBlue,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (entity.code != null)
                        Text(
                          entity.code!,
                          style: TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.secondaryLabel.resolveFrom(context),
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
                // 더보기 메뉴 (할당, mute 등)
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'assign') {
                      onAssign?.call();
                    } else if (value == 'mute_single') {
                      // 개별 mute (애니메이션 적용)
                      await performMute(isSingle: true);
                    } else if (value == 'mute_rule') {
                      // 규칙 기반 mute
                      final result = await MuteRuleDialog.show(
                        context: context,
                        source: entity.source,
                        code: entity.code,
                      );
                      if (result != null) {
                        // 애니메이션 적용 후 mute
                        await performMute(isSingle: false, ruleResult: result);
                      }
                    } else if (value == 'delete') {
                      // 삭제 확인 다이얼로그
                      final confirmed = await showCupertinoDialog<bool>(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text('이벤트 삭제'),
                          content: const Text('이 이벤트를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('취소'),
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('삭제'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        onDelete?.call();
                      }
                    }
                  },
                  offset: const Offset(0, 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  elevation: 4,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    // 할당하기 (관리자 전용, 완료되지 않은 경우)
                    if (onAssign != null && !entity.isCompleted)
                      PopupMenuItem<String>(
                        value: 'assign',
                        height: 40,
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.person_badge_plus,
                              size: 16,
                              color: CupertinoColors.systemBlue,
                            ),
                            const SizedBox(width: 8),
                            const Text('할당하기', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    // 구분선 (관리자 전용)
                    if (isAdmin && (onAssign != null && !entity.isCompleted))
                      const PopupMenuDivider(height: 1),
                    // 이 알림 숨기기 (관리자 전용)
                    if (isAdmin)
                      PopupMenuItem<String>(
                        value: 'mute_single',
                        height: 40,
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.bell_slash,
                              size: 16,
                              color: CupertinoColors.systemGrey,
                            ),
                            const SizedBox(width: 8),
                            const Text('이 알림 숨기기', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    // 이 종류의 알림 숨기기 (관리자 전용)
                    if (isAdmin)
                      PopupMenuItem<String>(
                        value: 'mute_rule',
                        height: 40,
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.bell_slash_fill,
                              size: 16,
                              color: CupertinoColors.systemGrey,
                            ),
                            const SizedBox(width: 8),
                            const Text('이 종류의 알림 숨기기...', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    // 삭제 (관리자 전용)
                    if (onDelete != null) ...[
                      const PopupMenuDivider(height: 1),
                      PopupMenuItem<String>(
                        value: 'delete',
                        height: 40,
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.trash,
                              size: 16,
                              color: CupertinoColors.destructiveRed,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '삭제',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.destructiveRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6.resolveFrom(context),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      CupertinoIcons.ellipsis,
                      size: 16,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
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
                const SizedBox(width: 8),
                // 읽음/안읽음 뱃지
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isRead
                        ? CupertinoColors.systemGrey.withValues(alpha: 0.15)
                        : CupertinoColors.systemPurple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isRead ? '읽음' : '안읽음',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isRead
                          ? CupertinoColors.systemGrey
                          : CupertinoColors.systemPurple,
                    ),
                  ),
                ),
                // 대응자 정보 + 경과시간
                if (entity.isBeingResponded &&
                    entity.currentResponderName != null) ...[
                  const SizedBox(width: 12),
                  Icon(
                    entity.isAssigned
                        ? CupertinoIcons.person_badge_plus_fill
                        : CupertinoIcons.person_fill,
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
                  // 할당 여부 표시
                  if (entity.isAssigned) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemIndigo.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '할당',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.systemIndigo,
                        ),
                      ),
                    ),
                  ],
                  // 시작 시간
                  if (entity.formattedResponseStartedAt != null) ...[
                    const SizedBox(width: 10),
                    Icon(
                      CupertinoIcons.clock,
                      size: 14,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entity.formattedResponseStartedAt!,
                      style: TextStyle(
                        fontSize: 11,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                  ],
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

            // 액션 버튼 (정보/경고 레벨은 대응하기 버튼 제외)
            if ((entity.isUnchecked && (entity.logLevel == LogLevel.critical || entity.logLevel == LogLevel.error)) ||
                (entity.isBeingResponded && isMyResponse)) ...[
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (entity.isUnchecked && (entity.logLevel == LogLevel.critical || entity.logLevel == LogLevel.error))
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: levelColor,
                      borderRadius: BorderRadius.circular(10),
                      minSize: 0,
                      onPressed: onRespond,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            CupertinoIcons.play_fill,
                            size: 14,
                            color: CupertinoColors.white,
                          ),
                          const SizedBox(width: 6),
                          const Text(
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

            // 페이로드 섹션 (확장 시 표시)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildPayloadSection(context),
              crossFadeState: isExpanded.value
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),

            // 확장 힌트
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isExpanded.value
                        ? CupertinoIcons.chevron_up
                        : CupertinoIcons.chevron_down,
                    size: 14,
                    color: CupertinoColors.tertiaryLabel.resolveFrom(context),
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
          ],
          ),
        ),
      ),
      ),
      ),
      ),
        ),
      ),
    );
  }

  Widget _buildPayloadSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6.resolveFrom(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CupertinoColors.separator.resolveFrom(context),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 소스 정보
            _buildDetailRow(
              context,
              icon: CupertinoIcons.device_desktop,
              label: '소스',
              value: entity.source,
            ),
            const SizedBox(height: 8),
            // 사이트 정보
            if (entity.site != null) ...[
              _buildDetailRow(
                context,
                icon: CupertinoIcons.location,
                label: '사이트',
                value: entity.site!,
              ),
              const SizedBox(height: 8),
            ],
            // 코드 정보
            if (entity.code != null) ...[
              _buildDetailRow(
                context,
                icon: CupertinoIcons.tag,
                label: '코드',
                value: entity.code!,
              ),
              const SizedBox(height: 8),
            ],
            // 시간 정보
            _buildDetailRow(
              context,
              icon: CupertinoIcons.clock,
              label: '발생 시간',
              value: entity.formattedCreatedAt,
            ),
            const SizedBox(height: 8),
            // 설명
            if (entity.description != null && entity.description!.isNotEmpty) ...[
              _buildDetailRow(
                context,
                icon: CupertinoIcons.doc_text,
                label: '설명',
                value: entity.description!,
              ),
              const SizedBox(height: 8),
            ],
            // 전송 데이터 (Payload)
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  CupertinoIcons.paperclip,
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
                entity.payload.isEmpty
                    ? '{}'
                    : _formatPayload(entity.payload),
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
            // 첨부 자료 (Attachments)
            Row(
              children: [
                Icon(
                  CupertinoIcons.folder,
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
                entity.attachments.isEmpty
                    ? '{}'
                    : _formatPayload(entity.attachments),
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
                buffer.writeln('[${entity.source}${entity.site != null ? ' - ${entity.site}' : ''}]');
                buffer.writeln('시간: ${entity.formattedCreatedAt}');
                buffer.writeln('레벨: ${entity.logLevel.label}');
                buffer.writeln('상태: ${entity.responseStatus.label}');
                if (entity.code != null) buffer.writeln('코드: ${entity.code}');
                if (entity.description != null && entity.description!.isNotEmpty) {
                  buffer.writeln('설명: ${entity.description}');
                }
                buffer.writeln('');
                buffer.writeln('전송 데이터:');
                buffer.writeln(entity.payload.isEmpty
                    ? '{}'
                    : _formatPayload(entity.payload));
                buffer.writeln('');
                buffer.writeln('첨부 자료:');
                buffer.writeln(entity.attachments.isEmpty
                    ? '{}'
                    : _formatPayload(entity.attachments));
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
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
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

  String _formatPayload(Map<String, dynamic> payload) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(payload);
    } catch (e) {
      return payload.toString();
    }
  }
}

/// 그룹핑된 뷰 (Alert용)
class _AlertGroupedView extends StatefulWidget {
  const _AlertGroupedView({
    required this.logs,
    required this.groupingMode,
    required this.isAdmin,
    required this.onRespond,
    required this.onAbandon,
    required this.onComplete,
    this.onAssign,
    this.onDeleteGroup,
    this.onDeleteLog,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  final List<SystemLogEntity> logs;
  final GroupingMode groupingMode;
  final bool isAdmin;
  final void Function(SystemLogEntity) onRespond;
  final void Function(SystemLogEntity) onAbandon;
  final void Function(SystemLogEntity) onComplete;
  final void Function(SystemLogEntity)? onAssign;
  final void Function(List<SystemLogEntity> logs)? onDeleteGroup;
  final void Function(SystemLogEntity)? onDeleteLog;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  @override
  State<_AlertGroupedView> createState() => _AlertGroupedViewState();
}

class _AlertGroupedViewState extends State<_AlertGroupedView> {
  final Set<String> _collapsedGroups = {};

  // 그룹별 표시 개수 (lazy loading)
  final Map<String, int> _visibleCountPerGroup = {};
  static const int _initialVisibleCount = 10;
  static const int _loadMoreCount = 20;

  // 캐시된 그룹 데이터
  Map<String, List<SystemLogEntity>> _cachedGroups = {};
  List<String> _cachedSortedKeys = [];
  int _lastLogsLength = 0;
  GroupingMode? _lastGroupingMode;

  void _toggleCollapse(String key) {
    setState(() {
      if (_collapsedGroups.contains(key)) {
        _collapsedGroups.remove(key);
      } else {
        _collapsedGroups.add(key);
        // 펼칠 때 초기 개수로 설정
        _visibleCountPerGroup[key] = _initialVisibleCount;
      }
    });
  }

  void _loadMoreInGroup(String key, int totalCount) {
    setState(() {
      final current = _visibleCountPerGroup[key] ?? _initialVisibleCount;
      _visibleCountPerGroup[key] = (current + _loadMoreCount).clamp(0, totalCount);
    });
  }

  void _updateGroupsIfNeeded() {
    // logs나 groupingMode가 변경된 경우에만 재계산
    if (widget.logs.length != _lastLogsLength ||
        widget.groupingMode != _lastGroupingMode) {
      _cachedGroups = {};
      for (final log in widget.logs) {
        final key = widget.groupingMode == GroupingMode.bySource
            ? log.source
            : (log.site ?? '(사이트 없음)');
        if (!_cachedGroups.containsKey(key)) {
          _cachedGroups[key] = [];
        }
        _cachedGroups[key]!.add(log);
      }
      _cachedSortedKeys = _cachedGroups.keys.toList()..sort();
      _lastLogsLength = widget.logs.length;
      _lastGroupingMode = widget.groupingMode;
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      // 스크롤이 80% 이상 내려가면 추가 로딩
      if (metrics.pixels >= metrics.maxScrollExtent * 0.8 &&
          widget.hasMore &&
          !widget.isLoadingMore &&
          widget.onLoadMore != null) {
        widget.onLoadMore!();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // 필요시에만 그룹 재계산
    _updateGroupsIfNeeded();

    final groups = _cachedGroups;
    final sortedKeys = _cachedSortedKeys;

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedKeys.length + (widget.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // 로딩 인디케이터
          if (index == sortedKeys.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: widget.isLoadingMore
                    ? const CupertinoActivityIndicator()
                    : CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: widget.onLoadMore,
                        child: const Text('더 보기'),
                      ),
              ),
            );
          }

          final key = sortedKeys[index];
          final groupLogs = groups[key]!;
          final icon = widget.groupingMode == GroupingMode.bySource
            ? CupertinoIcons.device_desktop
            : CupertinoIcons.location;
        final isCollapsed = _collapsedGroups.contains(key);

        return RepaintBoundary(
          key: ValueKey('group_$key'),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // 그룹 헤더 (전체 클릭 가능)
              GestureDetector(
                onTap: () => _toggleCollapse(key),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5.resolveFrom(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 접기/펼치기 아이콘
                      AnimatedRotation(
                        turns: isCollapsed ? -0.25 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          CupertinoIcons.chevron_down,
                          size: 14,
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        icon,
                        size: 16,
                        color: CupertinoColors.label.resolveFrom(context),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        key,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.label.resolveFrom(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${groupLogs.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.systemBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 접기/펼치기 힌트 텍스트
                      Text(
                        isCollapsed ? '펼치기' : '접기',
                        style: TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                      // 관리자 전용 삭제 버튼 (접힌 상태에서만 표시)
                      if (widget.isAdmin && isCollapsed && widget.onDeleteGroup != null) ...[
                        const SizedBox(width: 12),
                        Builder(
                          builder: (btnContext) => GestureDetector(
                            onTap: () => _showGroupMenu(btnContext, groupLogs),
                            child: Icon(
                              CupertinoIcons.ellipsis,
                              size: 18,
                              color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // 그룹 카드들 (접히지 않은 경우에만 표시, lazy loading)
              if (!isCollapsed) ...[
                ...() {
                  final visibleCount = _visibleCountPerGroup[key] ?? _initialVisibleCount;
                  final logsToShow = groupLogs.take(visibleCount).toList();
                  return logsToShow.map((entity) => _LogCard(
                    key: ValueKey('log_${entity.id}'),
                    entity: entity,
                    onRespond: () => widget.onRespond(entity),
                    onAbandon: () => widget.onAbandon(entity),
                    onComplete: () => widget.onComplete(entity),
                    onAssign: widget.onAssign != null ? () => widget.onAssign!(entity) : null,
                    onDelete: (widget.isAdmin && widget.onDeleteLog != null)
                        ? () => widget.onDeleteLog!(entity)
                        : null,
                    isAdmin: widget.isAdmin,
                  ));
                }(),
                // 더 보기 버튼 (더 있을 경우에만)
                if (groupLogs.length > (_visibleCountPerGroup[key] ?? _initialVisibleCount))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () => _loadMoreInGroup(key, groupLogs.length),
                        child: Text(
                          '더 보기 (${groupLogs.length - (_visibleCountPerGroup[key] ?? _initialVisibleCount)}개 남음)',
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: 20),
              ],
            ),
          ),
        );
        },
      ),
    );
  }

  void _showGroupMenu(BuildContext btnContext, List<SystemLogEntity> groupLogs) {
    final RenderBox button = btnContext.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(btnContext).overlay!.context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu<String>(
      context: btnContext,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height,
        position.dx + button.size.width,
        position.dy,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                CupertinoIcons.trash,
                size: 16,
                color: CupertinoColors.destructiveRed,
              ),
              const SizedBox(width: 8),
              Text(
                '전체 삭제 (${groupLogs.length}건)',
                style: const TextStyle(
                  color: CupertinoColors.destructiveRed,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'delete' && btnContext.mounted) {
        _confirmDeleteGroup(btnContext, groupLogs);
      }
    });
  }

  Future<void> _confirmDeleteGroup(
      BuildContext context, List<SystemLogEntity> groupLogs) async {
      final confirmed = await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('그룹 삭제'),
          content: Text('${groupLogs.length}건의 이벤트를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context, true),
              child: const Text('삭제'),
            ),
          ],
        ),
      );

    if (confirmed == true) {
      widget.onDeleteGroup?.call(groupLogs);
    }
  }
}
