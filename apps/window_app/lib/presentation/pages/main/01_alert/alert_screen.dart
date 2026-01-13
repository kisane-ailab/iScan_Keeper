import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
import 'package:window_app/presentation/widgets/admin_label.dart';

class AlertScreen extends HookConsumerWidget {
  const AlertScreen({super.key});

  static const String path = '/alert';
  static const String name = 'alert';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(alertViewModelProvider);
    final viewModel = ref.read(alertViewModelProvider.notifier);
    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
        elevation: 0,
        title: Row(
          children: [
            const Text('이벤트'),
            const AdminLabel(),
            if (state.alertCount > 0) ...[
              const SizedBox(width: 10),
              _CupertinoBadge(
                count: state.alertCount,
                color: CupertinoColors.systemRed,
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
          _AlertTabContent(
            logs: state.productionLogs,
            state: state,
            viewModel: viewModel,
            emptyMessage: '운영중 이벤트 대기 중...',
            emptyIcon: CupertinoIcons.checkmark_shield,
            isProduction: true,
          ),
          // 개발중 탭
          _AlertTabContent(
            logs: state.developmentLogs,
            state: state,
            viewModel: viewModel,
            emptyMessage: '개발중 이벤트 대기 중...',
            emptyIcon: CupertinoIcons.hammer,
            isProduction: false,
          ),
        ],
      ),
    );
  }
}

/// 필터 섹션 (Breadcrumb + 로그레벨 + 기간)
class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.state,
    required this.viewModel,
  });

  final AlertState state;
  final AlertViewModel viewModel;

  Color _getLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.critical:
        return const Color(0xFFDC143C);
      case LogLevel.error:
        return CupertinoColors.systemOrange;
      case LogLevel.warning:
        return const Color(0xFFFFCC00);
      case LogLevel.info:
        return CupertinoColors.systemBlue;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _showDatePicker(BuildContext context, bool isStartDate) async {
    final initialDate = isStartDate ? state.startDate : state.endDate;

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
        viewModel.setStartDate(picked);
      } else {
        viewModel.setEndDate(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // 로그레벨 다중 선택 칩
          ...LogLevel.values.map((level) {
            final isSelected = state.selectedLogLevels.contains(level);
            final color = _getLevelColor(level);
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: GestureDetector(
                onTap: () => viewModel.toggleLogLevel(level),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withValues(alpha: 0.15) : CupertinoColors.systemGrey6.resolveFrom(context),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? color.withValues(alpha: 0.5) : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    level.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? color : CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                ),
              ),
            );
          }),
          // 구분선
          Container(
            width: 1,
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: CupertinoColors.separator.resolveFrom(context),
          ),
          const SizedBox(width: 8),
          // 시작일
          GestureDetector(
            onTap: () => _showDatePicker(context, true),
            child: Container(
              constraints: const BoxConstraints(minWidth: 76),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: state.startDate != null
                    ? CupertinoColors.systemBlue.withValues(alpha: 0.1)
                    : CupertinoColors.systemGrey6.resolveFrom(context),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: state.startDate != null ? CupertinoColors.systemBlue.withValues(alpha: 0.3) : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.startDate != null ? _formatDate(state.startDate!) : '시작일',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: state.startDate != null ? FontWeight.w600 : FontWeight.w500,
                      color: state.startDate != null
                          ? CupertinoColors.systemBlue
                          : CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                  if (state.startDate != null) ...[
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => viewModel.setStartDate(null),
                      child: const Icon(
                        CupertinoIcons.xmark_circle_fill,
                        size: 14,
                        color: CupertinoColors.systemBlue,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Center(
              child: Text(
                '~',
                style: TextStyle(
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ),
          ),
          // 종료일
          GestureDetector(
            onTap: () => _showDatePicker(context, false),
            child: Container(
              constraints: const BoxConstraints(minWidth: 76),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: state.endDate != null
                    ? CupertinoColors.systemBlue.withValues(alpha: 0.1)
                    : CupertinoColors.systemGrey6.resolveFrom(context),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: state.endDate != null ? CupertinoColors.systemBlue.withValues(alpha: 0.3) : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.endDate != null ? _formatDate(state.endDate!) : '종료일',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: state.endDate != null ? FontWeight.w600 : FontWeight.w500,
                      color: state.endDate != null
                          ? CupertinoColors.systemBlue
                          : CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                  if (state.endDate != null) ...[
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => viewModel.setEndDate(null),
                      child: const Icon(
                        CupertinoIcons.xmark_circle_fill,
                        size: 14,
                        color: CupertinoColors.systemBlue,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 구분선
          Container(
            width: 1,
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: CupertinoColors.separator.resolveFrom(context),
          ),
          const SizedBox(width: 8),
          // Breadcrumb (Source > Code) - 맨 뒤로
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
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  List<BreadCrumbItem> _buildBreadcrumbItems(BuildContext context) {
    final items = <BreadCrumbItem>[];

    // Source 선택 (전체 포함)
    items.add(BreadCrumbItem(
      content: _BreadcrumbChip(
        label: state.selectedSource ?? '전체',
        icon: CupertinoIcons.device_desktop,
        isSelected: state.selectedSource != null,
        items: state.availableSources,
        selectedValue: state.selectedSource,
        onSelected: viewModel.setSourceFilter,
      ),
    ));

    // Code 선택 (Source 선택 시에만 표시)
    if (state.selectedSource != null) {
      items.add(BreadCrumbItem(
        content: _BreadcrumbChip(
          label: state.selectedCode ?? '전체',
          icon: CupertinoIcons.tag,
          isSelected: state.selectedCode != null,
          items: state.availableCodes,
          selectedValue: state.selectedCode,
          onSelected: viewModel.setCodeFilter,
        ),
      ));
    }

    return items;
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

  void _showContextMenu(BuildContext context, Offset position) {
    // 선택된 값이 없으면 복사할 내용 없음
    if (selectedValue == null) return;

    // async gap 전에 ScaffoldMessenger 캡처
    final messenger = ScaffoldMessenger.of(context);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      elevation: 4,
      items: [
        PopupMenuItem<String>(
          value: 'copy',
          height: 36,
          child: const Row(
            children: [
              Icon(CupertinoIcons.doc_on_clipboard, size: 14),
              SizedBox(width: 8),
              Text('복사', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'copy' && selectedValue != null) {
        Clipboard.setData(ClipboardData(text: selectedValue!));
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  color: CupertinoColors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text('\'$selectedValue\' 복사됨'),
              ],
            ),
            backgroundColor: CupertinoColors.systemGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? CupertinoColors.systemBlue
        : CupertinoColors.label.resolveFrom(context);

    return GestureDetector(
      onSecondaryTapUp: (details) => _showContextMenu(context, details.globalPosition),
      child: PopupMenuButton<String>(
        onSelected: (value) => onSelected(value == _allValue ? null : value),
        offset: const Offset(0, 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        elevation: 4,
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: _allValue,
            height: 36,
            child: Row(
              children: [
                if (selectedValue == null)
                  const Icon(CupertinoIcons.checkmark, size: 14, color: CupertinoColors.systemBlue)
                else
                  const SizedBox(width: 14),
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
                if (selectedValue == item)
                  const Icon(CupertinoIcons.checkmark, size: 14, color: CupertinoColors.systemBlue)
                else
                  const SizedBox(width: 14),
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
        child: Container(
          constraints: const BoxConstraints(maxWidth: 160),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? CupertinoColors.systemBlue.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 12, color: color),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                CupertinoIcons.chevron_down,
                size: 10,
                color: color,
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
    required this.isProduction,
  });

  final List<SystemLogEntity> logs;
  final AlertState state;
  final AlertViewModel viewModel;
  final String emptyMessage;
  final IconData emptyIcon;
  final bool isProduction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAlwaysOnTop = ref.watch(alwaysOnTopStateProvider);
    final settings = ref.watch(notificationSettingsServiceProvider);

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
      isProduction ? e.isProduction : e.isDevelopment
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

    return Column(
      children: [
        // 필터 영역
        _FilterSection(
          state: state,
          viewModel: viewModel,
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
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final entity = logs[index];
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

/// 긴급 알림 배너 (실시간 경과시간 표시, 스크롤 가능)
class _CriticalAlertBanner extends HookWidget {
  const _CriticalAlertBanner({
    required this.entities,
    required this.onRespond,
  });

  final List<SystemLogEntity> entities;
  final void Function(SystemLogEntity) onRespond;

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

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 180),
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
          Flexible(
            child: RawScrollbar(
              thumbColor: CupertinoColors.white.withValues(alpha: 0.6),
              radius: const Radius.circular(4),
              thickness: 4,
              thumbVisibility: true,
              padding: const EdgeInsets.only(right: 4),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
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
                        // 경과 시간 타이머 (slide_countdown)
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
        ],
      ),
    );
  }
}

/// 로그 카드 (실시간 경과시간 표시) - Cupertino 스타일
class _LogCard extends HookConsumerWidget {
  const _LogCard({
    required this.entity,
    required this.onRespond,
    required this.onAbandon,
    required this.onComplete,
    this.onAssign,
  });

  final SystemLogEntity entity;
  final VoidCallback onRespond;
  final VoidCallback onAbandon;
  final VoidCallback onComplete;
  final VoidCallback? onAssign;

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

    return SelectionArea(
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
                // 더보기 메뉴 (할당 등)
                if (onAssign != null && !entity.isCompleted) ...[
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'assign') {
                        onAssign?.call();
                      }
                    },
                    offset: const Offset(0, 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    color: CupertinoColors.systemBackground.resolveFrom(context),
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context) => [
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
                    isExpanded.value ? '접기' : '페이로드 보기',
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
    );
  }

  Widget _buildPayloadSection(BuildContext context) {
    if (entity.payload.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6.resolveFrom(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '페이로드 없음',
            style: TextStyle(
              fontSize: 12,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

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
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _formatPayload(entity.payload),
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: CupertinoColors.label.resolveFrom(context),
                ),
              ),
            ),
          ],
        ),
      ),
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
