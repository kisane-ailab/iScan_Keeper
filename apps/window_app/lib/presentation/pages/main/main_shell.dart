import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/data/models/user_model.dart';
import 'package:window_app/domain/services/event_response_service.dart';
import 'package:window_app/domain/services/read_status_service.dart';
import 'package:window_app/presentation/layout/base_shell.dart';
import 'package:window_app/presentation/pages/main/01_alert/alert_view_model.dart';
import 'package:window_app/presentation/pages/main/05_health_check/health_check_view_model.dart';

/// 레일 상태 (고정 여부)
class RailPinnedNotifier extends Notifier<bool> {
  @override
  bool build() => true; // 기본값: 고정됨

  void toggle() => state = !state;
  void pin() => state = true;
  void unpin() => state = false;
}

final railPinnedProvider = NotifierProvider<RailPinnedNotifier, bool>(
  RailPinnedNotifier.new,
);

/// 레일 호버 상태
class RailHoveredNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setHovered(bool value) => state = value;
}

final railHoveredProvider = NotifierProvider<RailHoveredNotifier, bool>(
  RailHoveredNotifier.new,
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
    final isPinned = ref.watch(railPinnedProvider);
    final isHovered = ref.watch(railHoveredProvider);
    final isRailVisible = isPinned || isHovered;

    return Stack(
      children: [
        // 메인 콘텐츠 영역
        Row(
          children: [
            // 고정된 레일 공간 (고정 시에만 공간 차지)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: isPinned ? 88 : 0,
            ),
            // 우측 콘텐츠 영역
            Expanded(
              child: navigationShell,
            ),
          ],
        ),
        // 호버 트리거 영역 (레일이 숨겨져 있을 때만 활성화)
        if (!isPinned)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: MouseRegion(
              onEnter: (_) {
                ref.read(railHoveredProvider.notifier).setHovered(true);
              },
              child: Container(
                width: 8,
                color: Colors.transparent,
              ),
            ),
          ),
        // 슬라이딩 레일
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: MouseRegion(
            onExit: (_) {
              if (!isPinned) {
                ref.read(railHoveredProvider.notifier).setHovered(false);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: isRailVisible ? 88 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: isRailVisible ? 1.0 : 0.0,
                child: _CupertinoNavigationRail(
                  selectedIndex: currentIndex,
                  onDestinationSelected: onDestinationSelected,
                  leading: buildLeading(context, ref),
                  destinations: buildDestinations(context, ref),
                  isPinned: isPinned,
                  showShadow: !isPinned && isHovered,
                ),
              ),
            ),
          ),
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
  List<_CupertinoNavDestination> buildDestinations( // ignore: library_private_types_in_public_api
    BuildContext context,
    WidgetRef ref,
  ) {
    // 이벤트/헬스체크 상태 가져오기
    final alertState = ref.watch(alertViewModelProvider);
    final healthCheckState = ref.watch(healthCheckViewModelProvider);

    // 읽음 상태 - 운영중만 안읽은 개수 계산
    final readState = ref.watch(readStatusServiceProvider);
    final eventUnreadCount = alertState.productionLogs
        .where((log) => !readState.readEventIds.contains(log.id))
        .length;
    final healthCheckUnreadCount = healthCheckState.productionLogs
        .where((log) => !readState.readHealthCheckIds.contains(log.id))
        .length;

    // 관리자 여부 확인
    final currentUserAsync = ref.watch(currentUserDetailProvider);
    final isAdmin = currentUserAsync.when(
      data: (user) => user?.isAdmin ?? false,
      loading: () => false,
      error: (e, s) => false,
    );

    return [
      _CupertinoNavDestination(
        icon: CupertinoIcons.bell,
        selectedIcon: CupertinoIcons.bell_fill,
        label: '이벤트',
        badgeCount: eventUnreadCount,
        badgeColor: CupertinoColors.systemRed,
      ),
      _CupertinoNavDestination(
        icon: CupertinoIcons.heart,
        selectedIcon: CupertinoIcons.heart_fill,
        label: '헬스체크',
        badgeCount: healthCheckUnreadCount,
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
      const _CupertinoNavDestination(
        icon: CupertinoIcons.doc_text,
        selectedIcon: CupertinoIcons.doc_text_fill,
        label: 'API 문서',
      ),
      // 숨긴 알림 (관리자 전용)
      if (isAdmin)
        const _CupertinoNavDestination(
          icon: CupertinoIcons.bell_slash,
          selectedIcon: CupertinoIcons.bell_slash_fill,
          label: '숨긴 알림',
        ),
    ];
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
class _CupertinoNavigationRail extends ConsumerStatefulWidget {
  const _CupertinoNavigationRail({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.leading,
    this.isPinned = true,
    this.showShadow = false,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<_CupertinoNavDestination> destinations;
  final Widget? leading;
  final bool isPinned;
  final bool showShadow;

  @override
  ConsumerState<_CupertinoNavigationRail> createState() =>
      _CupertinoNavigationRailState();
}

class _CupertinoNavigationRailState
    extends ConsumerState<_CupertinoNavigationRail> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        width: 88,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          border: Border(
            right: BorderSide(
              color: CupertinoColors.separator.resolveFrom(context),
              width: 0.5,
            ),
          ),
          // 호버로 나타났을 때 그림자 효과
          boxShadow: widget.showShadow
              ? [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(4, 0),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // 상단 토글 버튼 영역
            _RailToggleHeader(
              isPinned: widget.isPinned,
              isHovered: _isHovered,
            ),
            if (widget.leading != null) widget.leading!,
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: widget.destinations.length,
                itemBuilder: (context, index) {
                  final dest = widget.destinations[index];
                  final isSelected = index == widget.selectedIndex;
                  return _CupertinoNavItem(
                    icon: isSelected ? dest.selectedIcon : dest.icon,
                    label: dest.label,
                    isSelected: isSelected,
                    badgeCount: dest.badgeCount,
                    badgeColor: dest.badgeColor,
                    onTap: () => widget.onDestinationSelected(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 레일 상단 토글 헤더 (노션 스타일)
class _RailToggleHeader extends ConsumerStatefulWidget {
  const _RailToggleHeader({
    required this.isPinned,
    required this.isHovered,
  });

  final bool isPinned;
  final bool isHovered;

  @override
  ConsumerState<_RailToggleHeader> createState() => _RailToggleHeaderState();
}

class _RailToggleHeaderState extends ConsumerState<_RailToggleHeader> {
  bool _isButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    // 호버 중이거나 고정 해제 상태일 때 버튼 표시
    final showButton = widget.isHovered || !widget.isPinned;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // 토글 버튼 (호버 시에만 표시)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: showButton ? 1.0 : 0.0,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _isButtonHovered = true),
              onExit: (_) => setState(() => _isButtonHovered = false),
              child: GestureDetector(
                onTap: showButton
                    ? () => ref.read(railPinnedProvider.notifier).toggle()
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _isButtonHovered
                        ? CupertinoColors.systemGrey5.resolveFrom(context)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Icon(
                      widget.isPinned
                          ? CupertinoIcons.sidebar_left
                          : CupertinoIcons.arrow_right_to_line,
                      size: 16,
                      color: _isButtonHovered
                          ? CupertinoColors.label.resolveFrom(context)
                          : CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                ),
              ),
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
