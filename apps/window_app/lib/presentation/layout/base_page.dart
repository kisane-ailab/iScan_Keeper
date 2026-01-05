import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///
/// 앱의 화면 페이지를 생성하는 유틸리티 클래스
/// [HookConsumerWidget]을 상속하여 hook과 WidgetRef로직에 접근할 수 있음
///
abstract class BasePage extends HookConsumerWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 구독 저장소
    final subscriptions = useRef<List<StreamSubscription>>([]);

    /// 페이지의 초기화 및 해제를 처리
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

    ///
    /// Swipe Back 제스처 이벤트를 관리
    /// [preventSwipeBack]의 속성 값은 통해
    /// 플랫폼별 Swipe Back 제스쳐 작동 여부를 설정할 수 있음.

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        onWillPop(context, ref);
      },
      child: ProviderScope(
        child: HookConsumer(
          builder: (context, ref, child) {
            return GestureDetector(
              onTap: !preventAutoUnfocus
                  ? () => FocusManager.instance.primaryFocus?.unfocus()
                  : null,
              child: Container(
                color: unSafeAreaColor,
                child: wrapWithSafeArea
                    ? SafeArea(
                        top: setTopSafeArea,
                        bottom: setBottomSafeArea,
                        child: _buildScaffold(context, ref),
                      )
                    : _buildScaffold(context, ref),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: buildAppBar(context, ref),
      body: buildPage(context, ref),
      backgroundColor: screenBackgroundColor,
      bottomNavigationBar: buildBottomNavigationBar(context),
      bottomSheet: buildBottomSheet(ref),
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: buildFloatingActionButton(ref),
    );
  }

  /// 하단 네비게이션 바를 구성하는 위젯을 반환
  @protected
  Widget? buildBottomNavigationBar(BuildContext context) => null;

  @protected
  Widget? buildBottomSheet(WidgetRef ref) => null;

  /// 화면 페이지의 본문을 구성하는 위젯을 반환
  @protected
  Widget buildPage(BuildContext context, WidgetRef ref);

  /// 화면 상단에 표시될 앱 바를 구성하는 위젯을 반환
  @protected
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) => null;

  /// 화면에 표시될 플로팅 액션 버튼을 구성하는 위젯을 반환
  @protected
  Widget? buildFloatingActionButton(WidgetRef ref) => null;

  /// 뷰의 안전 영역 밖의 배경색을 설정
  @protected
  Color? get unSafeAreaColor => Colors.white;

  /// 키보드가 화면 하단에 올라왔을 때 페이지의 크기를 조정하는 여부를 설정
  @protected
  bool get resizeToAvoidBottomInset => true;

  /// 플로팅 액션 버튼의 위치를 설정
  @protected
  FloatingActionButtonLocation? get floatingActionButtonLocation => null;

  /// 앱 바 아래의 콘텐츠가 앱 바 뒤로 표시되는지 여부를 설정
  @protected
  bool get extendBodyBehindAppBar => false;

  /// Swipe Back 제스처 동작을 막는지 여부를 설정
  @protected
  bool get canPop => true;

  /// 화면의 배경색을 설정
  @protected
  Color? get screenBackgroundColor => Colors.white;

  /// SafeArea로 감싸는 여부를 설정
  @protected
  bool get wrapWithSafeArea => true;

  /// 뷰의 안전 영역 아래에 SafeArea를 적용할지 여부를 설정
  @protected
  bool get setBottomSafeArea => true;

  /// 뷰의 안전 영역 위에 SafeArea를 적용할지 여부를 설정
  @protected
  bool get setTopSafeArea => true;

  /// 화면 클릭 시 자동으로 포커스를 해제할지 여부를 설정
  @protected
  bool get preventAutoUnfocus => false;

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

  /// 페이지 초기화 시 호출
  /// [subscriptions]에 StreamSubscription을 추가하면 자동으로 dispose 시 취소됨
  @protected
  void onInit(
    BuildContext context,
    WidgetRef ref, [
    List<StreamSubscription>? subscriptions,
  ]) {}

  /// 페이지 해제 시 호출
  @protected
  void onDispose(BuildContext context, WidgetRef ref) {}

  /// will pop시
  @protected
  void onWillPop(BuildContext context, WidgetRef ref) {}
}
