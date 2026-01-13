import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/data/models/notification_settings.dart';
import 'package:window_app/domain/services/app_updater_service.dart';
import 'package:window_app/domain/services/notification_settings_service.dart';
import 'package:window_app/presentation/layout/base_page.dart';
import 'package:window_app/presentation/widgets/admin_label.dart';

class SettingsScreen extends BasePage {
  const SettingsScreen({super.key});

  static const String path = '/settings';
  static const String name = 'settings';

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const AppBarTitleWithLabel(title: '설정'),
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      elevation: 0,
      actions: [
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          onPressed: () {
            ref.read(notificationSettingsServiceProvider.notifier).resetToDefault();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('기본값으로 초기화되었습니다'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          child: const Text('초기화'),
        ),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsServiceProvider);

    return Container(
      color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // 알림 설정 섹션 (탭 포함)
          const _CupertinoSectionHeader(title: '알림 설정'),
          _NotificationSettingsCard(settings: settings),

          const SizedBox(height: 24),

          // 기타 설정
          const _CupertinoSectionHeader(title: '기타 설정'),
          _CupertinoCard(
            children: [
              _CupertinoSwitchTile(
                title: '헬스체크 알림 표시',
                subtitle: '주기적인 헬스체크 로그도 알림으로 표시',
                value: settings.showHealthCheck,
                onChanged: ref.read(notificationSettingsServiceProvider.notifier).setShowHealthCheck,
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 앱 정보 및 업데이트
          const _CupertinoSectionHeader(title: '앱 정보'),
          _CupertinoAppUpdateCard(),
        ],
      ),
    );
  }

  @override
  bool get wrapWithSafeArea => false;
}

/// 알림 설정 카드 (탭 포함)
class _NotificationSettingsCard extends HookConsumerWidget {
  const _NotificationSettingsCard({required this.settings});

  final NotificationSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final settingsService = ref.read(notificationSettingsServiceProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
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
          // 탭 바 (운영중/개발중)
          Container(
            margin: const EdgeInsets.all(12),
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
                  height: 36,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: CupertinoColors.systemRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text('운영중'),
                    ],
                  ),
                ),
                Tab(
                  height: 36,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: CupertinoColors.systemBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text('개발중'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 탭 콘텐츠
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: tabController,
              children: [
                // 프로덕션 설정
                _NotificationLevelSettings(
                  warningAction: settings.production.warningAction,
                  errorAction: settings.production.errorAction,
                  criticalAction: settings.production.criticalAction,
                  onWarningChanged: settingsService.setProductionWarningAction,
                  onErrorChanged: settingsService.setProductionErrorAction,
                  onCriticalChanged: settingsService.setProductionCriticalAction,
                ),
                // 개발 설정
                _NotificationLevelSettings(
                  warningAction: settings.development.warningAction,
                  errorAction: settings.development.errorAction,
                  criticalAction: settings.development.criticalAction,
                  onWarningChanged: settingsService.setDevelopmentWarningAction,
                  onErrorChanged: settingsService.setDevelopmentErrorAction,
                  onCriticalChanged: settingsService.setDevelopmentCriticalAction,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 알림 레벨별 설정 (버튼 방식)
class _NotificationLevelSettings extends StatelessWidget {
  const _NotificationLevelSettings({
    required this.warningAction,
    required this.errorAction,
    required this.criticalAction,
    required this.onWarningChanged,
    required this.onErrorChanged,
    required this.onCriticalChanged,
  });

  final NotificationAction warningAction;
  final NotificationAction errorAction;
  final NotificationAction criticalAction;
  final Future<void> Function(NotificationAction) onWarningChanged;
  final Future<void> Function(NotificationAction) onErrorChanged;
  final Future<void> Function(NotificationAction) onCriticalChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          _NotificationLevelRow(
            label: '경고',
            icon: CupertinoIcons.exclamationmark_circle_fill,
            color: CupertinoColors.systemOrange,
            currentAction: warningAction,
            onChanged: onWarningChanged,
          ),
          const SizedBox(height: 12),
          _NotificationLevelRow(
            label: '에러',
            icon: CupertinoIcons.xmark_circle_fill,
            color: CupertinoColors.systemRed,
            currentAction: errorAction,
            onChanged: onErrorChanged,
          ),
          const SizedBox(height: 12),
          _NotificationLevelRow(
            label: '심각',
            icon: CupertinoIcons.exclamationmark_triangle_fill,
            color: const Color(0xFFDC143C),
            currentAction: criticalAction,
            onChanged: onCriticalChanged,
          ),
        ],
      ),
    );
  }
}

/// 알림 레벨 행 (라벨 + 버튼 4개)
class _NotificationLevelRow extends StatelessWidget {
  const _NotificationLevelRow({
    required this.label,
    required this.icon,
    required this.color,
    required this.currentAction,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final Color color;
  final NotificationAction currentAction;
  final Future<void> Function(NotificationAction) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6.resolveFrom(context),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 레벨 라벨
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 액션 버튼들
          Row(
            children: NotificationAction.values.map((action) {
              final isSelected = action == currentAction;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: action != NotificationAction.values.last ? 6 : 0,
                  ),
                  child: _ActionButton(
                    action: action,
                    isSelected: isSelected,
                    onTap: () => onChanged(action),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// 액션 버튼
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.action,
    required this.isSelected,
    required this.onTap,
  });

  final NotificationAction action;
  final bool isSelected;
  final VoidCallback onTap;

  Color _getActionColor() {
    switch (action) {
      case NotificationAction.none:
        return CupertinoColors.systemGrey;
      case NotificationAction.trayOnly:
        return CupertinoColors.systemBlue;
      case NotificationAction.foreground:
        return CupertinoColors.systemOrange;
      case NotificationAction.alwaysOnTop:
        return CupertinoColors.systemRed;
    }
  }

  IconData _getActionIcon() {
    switch (action) {
      case NotificationAction.none:
        return CupertinoIcons.bell_slash;
      case NotificationAction.trayOnly:
        return CupertinoIcons.tray;
      case NotificationAction.foreground:
        return CupertinoIcons.app_badge;
      case NotificationAction.alwaysOnTop:
        return CupertinoIcons.pin_fill;
    }
  }

  String _getShortLabel() {
    switch (action) {
      case NotificationAction.none:
        return '없음';
      case NotificationAction.trayOnly:
        return '트레이';
      case NotificationAction.foreground:
        return '전면';
      case NotificationAction.alwaysOnTop:
        return '항상위';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getActionColor();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : CupertinoColors.systemGrey4.resolveFrom(context),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getActionIcon(),
              size: 18,
              color: isSelected ? color : CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
            const SizedBox(height: 4),
            Text(
              _getShortLabel(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cupertino 스타일 섹션 헤더
class _CupertinoSectionHeader extends StatelessWidget {
  const _CupertinoSectionHeader({
    required this.title,
    this.trailing,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
              letterSpacing: 0.5,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Cupertino 스타일 카드
class _CupertinoCard extends StatelessWidget {
  const _CupertinoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

/// Cupertino 스타일 스위치 타일
class _CupertinoSwitchTile extends StatelessWidget {
  const _CupertinoSwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  final String title;
  final String subtitle;
  final bool value;
  final Future<void> Function(bool) onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoSwitch(
                value: value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 16),
      ],
    );
  }
}

/// Cupertino 스타일 앱 업데이트 카드
class _CupertinoAppUpdateCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateState = ref.watch(appUpdaterServiceProvider);
    final updaterService = ref.read(appUpdaterServiceProvider.notifier);

    return _CupertinoCard(
      children: [
        // 현재 버전
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  CupertinoIcons.app_badge,
                  color: CupertinoColors.systemBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '현재 버전',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                updateState.currentVersion ?? '로딩 중...',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemBlue,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, indent: 64),
        // 업데이트 상태
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: updateState.updateAvailable
                      ? CupertinoColors.systemGreen.withValues(alpha: 0.15)
                      : CupertinoColors.systemGrey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  updateState.updateAvailable
                      ? CupertinoIcons.arrow_down_circle_fill
                      : CupertinoIcons.checkmark_circle_fill,
                  color: updateState.updateAvailable
                      ? CupertinoColors.systemGreen
                      : CupertinoColors.systemGrey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '업데이트 확인',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getUpdateStatusText(updateState),
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                  ],
                ),
              ),
              _buildUpdateAction(context, updateState, updaterService),
            ],
          ),
        ),

        // 다운로드 진행률
        if (updateState.isDownloading) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: updateState.downloadProgress,
                    backgroundColor: CupertinoColors.systemGrey5,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      CupertinoColors.systemBlue,
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(updateState.downloadProgress * 100).toStringAsFixed(0)}% 다운로드 중...',
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
        ],

        // 에러 메시지
        if (updateState.errorMessage != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CupertinoColors.systemRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.exclamationmark_circle,
                    color: CupertinoColors.systemRed,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      updateState.errorMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemRed,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 24,
                    onPressed: updaterService.clearError,
                    child: const Icon(
                      CupertinoIcons.xmark,
                      size: 16,
                      color: CupertinoColors.systemRed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _getUpdateStatusText(AppUpdateState state) {
    if (state.isChecking) return '확인 중...';
    if (state.isDownloading) return '다운로드 중...';
    if (state.updateAvailable) return '새 버전 ${state.newVersion} 사용 가능';
    return '최신 버전입니다';
  }

  Widget _buildUpdateAction(
    BuildContext context,
    AppUpdateState state,
    AppUpdaterService service,
  ) {
    if (state.isChecking) {
      return const CupertinoActivityIndicator();
    }

    if (state.isDownloading) {
      return const SizedBox.shrink();
    }

    if (state.isDownloaded) {
      return CupertinoButton.filled(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minSize: 32,
        onPressed: () => service.restartApp(),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.restart, size: 16),
            SizedBox(width: 6),
            Text('재시작', style: TextStyle(fontSize: 13)),
          ],
        ),
      );
    }

    if (state.updateAvailable) {
      return CupertinoButton.filled(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minSize: 32,
        onPressed: () => service.startUpdate(),
        child: const Text('업데이트', style: TextStyle(fontSize: 13)),
      );
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 32,
      onPressed: () => service.checkForUpdates(),
      child: const Icon(
        CupertinoIcons.refresh,
        color: CupertinoColors.systemBlue,
      ),
    );
  }
}
