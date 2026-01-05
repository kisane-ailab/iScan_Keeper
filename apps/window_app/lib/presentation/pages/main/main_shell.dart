import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/presentation/layout/base_shell.dart';

/// 메인 쉘 레이아웃
/// 좌측에 NavigationRail 메뉴가 있고, 우측에 콘텐츠가 표시됨
class MainShell extends BaseShell {
  const MainShell({
    super.key,
    required super.navigationShell,
  });

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // 좌측 네비게이션 메뉴
        NavigationRail(
          selectedIndex: currentIndex,
          onDestinationSelected: onDestinationSelected,
          labelType: NavigationRailLabelType.all,
          leading: buildLeading(context, ref),
          trailing: buildTrailing(context, ref),
          destinations: buildDestinations(context, ref),
        ),
        const VerticalDivider(thickness: 1, width: 1),
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
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Icon(Icons.apps, size: 32),
    );
  }

  /// NavigationRail 하단 위젯
  @protected
  Widget? buildTrailing(BuildContext context, WidgetRef ref) {
    return null;
  }

  /// NavigationRail 목적지 목록
  @protected
  List<NavigationRailDestination> buildDestinations(
    BuildContext context,
    WidgetRef ref,
  ) {
    return const [
      NavigationRailDestination(
        icon: Icon(Icons.notifications_outlined),
        selectedIcon: Icon(Icons.notifications),
        label: Text('알림'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: Text('대시보드'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: Text('프로필'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: Text('설정'),
      ),
    ];
  }
}
