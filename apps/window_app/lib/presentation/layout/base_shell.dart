import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///
/// 앱의 쉘 레이아웃을 생성하는 유틸리티 클래스
/// [HookConsumerWidget]을 상속하여 hook과 WidgetRef 로직에 접근할 수 있음
/// NavigationRail/BottomNavigation 등을 포함하는 쉘 레이아웃에 사용
///
abstract class BaseShell extends HookConsumerWidget {
  const BaseShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 구독 저장소
    final subscriptions = useRef<List<StreamSubscription>>([]);

    /// 쉘의 초기화 및 해제를 처리
    useEffect(() {
      onInit(context, ref, subscriptions.value);
      return () {
        // 모든 구독 취소
        for (final sub in subscriptions.value) {
          sub.cancel();
        }
        subscriptions.value.clear();
        onDispose(context, ref);
      };
    }, []);

    /// 앱의 라이프 사이클 변화를 처리
    useOnAppLifecycleStateChange((previousState, state) {
      switch (state) {
        case AppLifecycleState.resumed:
          onResumed(context, ref);
          break;
        case AppLifecycleState.paused:
          onPaused(context, ref);
          break;
        case AppLifecycleState.inactive:
          onInactive(context, ref);
          break;
        case AppLifecycleState.detached:
          onDetached(context, ref);
          break;
        case AppLifecycleState.hidden:
          onHidden(context, ref);
          break;
      }
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: buildBody(context, ref),
    );
  }

  /// 쉘의 본문을 구성하는 위젯을 반환
  @protected
  Widget buildBody(BuildContext context, WidgetRef ref);

  /// 네비게이션 목적지 선택 시 호출
  @protected
  void onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  /// 현재 선택된 인덱스
  int get currentIndex => navigationShell.currentIndex;

  /// 배경색
  @protected
  Color? get backgroundColor => null;

  /// 앱이 활성화된 상태로 돌아올 때 호출
  @protected
  void onResumed(BuildContext context, WidgetRef ref) {}

  /// 앱이 일시 정지될 때 호출
  @protected
  void onPaused(BuildContext context, WidgetRef ref) {}

  /// 앱이 비활성 상태로 전환될 때 호출
  @protected
  void onInactive(BuildContext context, WidgetRef ref) {}

  /// 앱이 분리되었을 때 호출
  @protected
  void onDetached(BuildContext context, WidgetRef ref) {}

  /// 앱이 숨겨질 때 호출
  @protected
  void onHidden(BuildContext context, WidgetRef ref) {}

  /// 쉘 초기화 시 호출
  /// [subscriptions]에 StreamSubscription을 추가하면 자동으로 dispose 시 취소됨
  @protected
  void onInit(
    BuildContext context,
    WidgetRef ref, [
    List<StreamSubscription>? subscriptions,
  ]) {}

  /// 쉘 해제 시 호출
  @protected
  void onDispose(BuildContext context, WidgetRef ref) {}
}
