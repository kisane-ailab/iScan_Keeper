import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/presentation/layout/base_shell.dart';
import 'package:window_app/presentation/pages/main/01_alert/alert_view_model.dart';
import 'package:window_app/presentation/pages/main/05_health_check/health_check_view_model.dart';

/// 레일 표시 상태를 관리하는 Notifier
class RailVisibleNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final railVisibleProvider = NotifierProvider<RailVisibleNotifier, bool>(
  RailVisibleNotifier.new,
);

/// 메인 쉘 레이아웃
/// 좌측에 NavigationRail 메뉴가 있고, 우측에 콘텐츠가 표시됨
class MainShell extends BaseShell {
  const MainShell({
    super.key,
    required super.navigationShell,
  });

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    final isRailVisible = ref.watch(railVisibleProvider);

    return Row(
      children: [
        // 좌측 네비게이션 메뉴 (쿠퍼티노 스타일)
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: isRailVisible ? 88 : 0,
          child: isRailVisible
              ? _CupertinoNavigationRail(
                  selectedIndex: currentIndex,
                  onDestinationSelected: onDestinationSelected,
                  leading: buildLeading(context, ref),
                  destinations: buildDestinations(context, ref),
                )
              : null,
        ),
        // 토글 버튼
        _RailToggleButton(isVisible: isRailVisible),
        // 우측 콘텐츠 영역
        Expanded(
          child: navigationShell,
        ),
      ],
    );
  }

  /// NavigationRail 상단 위젯
  @protected
  Widget? buildLeading(BuildContext context, WidgetRef ref) {
    return null;
  }

  /// NavigationRail 목적지 목록
  @protected
  List<_CupertinoNavDestination> buildDestinations(
    BuildContext context,
    WidgetRef ref,
  ) {
    // 이벤트/헬스체크 알림 개수 가져오기
    final alertState = ref.watch(alertViewModelProvider);
    final healthCheckState = ref.watch(healthCheckViewModelProvider);

    return [
      _CupertinoNavDestination(
        icon: CupertinoIcons.bell,
        selectedIcon: CupertinoIcons.bell_fill,
        label: '이벤트',
        badgeCount: alertState.alertCount,
        badgeColor: CupertinoColors.systemRed,
      ),
      _CupertinoNavDestination(
        icon: CupertinoIcons.heart,
        selectedIcon: CupertinoIcons.heart_fill,
        label: '헬스체크',
        badgeCount: healthCheckState.alertCount,
        badgeColor: CupertinoColors.systemOrange,
      ),
      const _CupertinoNavDestination(
        icon: CupertinoIcons.square_grid_2x2,
        selectedIcon: CupertinoIcons.square_grid_2x2_fill,
        label: '대시보드',
      ),
      const _CupertinoNavDestination(
        icon: CupertinoIcons.person,
        selectedIcon: CupertinoIcons.person_fill,
        label: '프로필',
      ),
      const _CupertinoNavDestination(
        icon: CupertinoIcons.gear,
        selectedIcon: CupertinoIcons.gear_alt_fill,
        label: '설정',
      ),
    ];
  }
}

/// 레일 토글 버튼
class _RailToggleButton extends ConsumerWidget {
  const _RailToggleButton({required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          ref.read(railVisibleProvider.notifier).toggle();
        },
        child: Container(
          width: 16,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: CupertinoColors.separator.resolveFrom(context),
                width: 0.5,
              ),
            ),
          ),
          child: Center(
            child: Container(
              width: 16,
              height: 48,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6.resolveFrom(context),
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(4),
                ),
              ),
              child: Icon(
                isVisible
                    ? CupertinoIcons.chevron_left
                    : CupertinoIcons.chevron_right,
                size: 10,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 쿠퍼티노 스타일 네비게이션 목적지
class _CupertinoNavDestination {
  const _CupertinoNavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badgeCount = 0,
    this.badgeColor = CupertinoColors.systemRed,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int badgeCount;
  final Color badgeColor;
}

/// 쿠퍼티노 스타일 네비게이션 레일
class _CupertinoNavigationRail extends StatelessWidget {
  const _CupertinoNavigationRail({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.leading,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<_CupertinoNavDestination> destinations;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        border: Border(
          right: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          if (leading != null) leading!,
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final dest = destinations[index];
                final isSelected = index == selectedIndex;
                return _CupertinoNavItem(
                  icon: isSelected ? dest.selectedIcon : dest.icon,
                  label: dest.label,
                  isSelected: isSelected,
                  badgeCount: dest.badgeCount,
                  badgeColor: dest.badgeColor,
                  onTap: () => onDestinationSelected(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 쿠퍼티노 스타일 네비게이션 아이템
class _CupertinoNavItem extends StatelessWidget {
  const _CupertinoNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeCount = 0,
    this.badgeColor = CupertinoColors.systemRed,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int badgeCount;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    final selectedColor = CupertinoColors.systemBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 아이콘 + 뱃지
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: isSelected
                        ? selectedColor
                        : CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: badgeColor.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(minWidth: 18),
                        child: Text(
                          badgeCount > 99 ? '99+' : '$badgeCount',
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              // 라벨
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? selectedColor
                      : CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
