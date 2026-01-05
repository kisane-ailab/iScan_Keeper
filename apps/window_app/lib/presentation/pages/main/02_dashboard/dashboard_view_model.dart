import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/webview/webview_controller.dart';

part 'dashboard_view_model.freezed.dart';
part 'dashboard_view_model.g.dart';

/// Dashboard 화면 상태
@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(true) bool isLoading,
    @Default(0) double progress,
    @Default(false) bool canGoBack,
    @Default(false) bool canGoForward,
    String? currentUrl,
    @Default(false) bool hasError,
    String? errorMessage,
  }) = _DashboardState;
}

/// Dashboard ViewModel
@riverpod
class DashboardViewModel extends _$DashboardViewModel {
  AppWebViewController get _controller => ref.read(appWebViewControllerProvider);
  Logger get _logger => ref.read(appLoggerProvider);

  @override
  DashboardState build() {
    // 초기화 시 현재 네비게이션 상태 확인
    _initNavigationState();
    return const DashboardState();
  }

  /// 초기 네비게이션 상태 설정
  Future<void> _initNavigationState() async {
    // Controller가 있으면 현재 상태 확인
    if (_controller.hasController) {
      _logger.d('기존 컨트롤러에서 네비게이션 상태 초기화');
      final canGoBack = await _controller.canGoBack();
      final canGoForward = await _controller.canGoForward();
      final url = await _controller.getUrl();

      state = state.copyWith(
        isLoading: false,
        canGoBack: canGoBack,
        canGoForward: canGoForward,
        currentUrl: url?.toString(),
      );
      _logger.d('초기 상태 - 뒤로가기: $canGoBack, 앞으로가기: $canGoForward');
    }
  }

  /// WebView 컨트롤러 설정
  void setController(InAppWebViewController controller) {
    _controller.setController(controller);
    _logger.d('컨트롤러 설정 완료');
  }

  /// 로딩 시작
  void onLoadStart() {
    state = state.copyWith(isLoading: true);
  }

  /// 로딩 완료
  Future<void> onLoadStop(String? url) async {
    _logger.d('페이지 로딩 완료 - URL: $url');

    final canGoBack = await _controller.canGoBack();
    final canGoForward = await _controller.canGoForward();

    state = state.copyWith(
      isLoading: false,
      canGoBack: canGoBack,
      canGoForward: canGoForward,
      currentUrl: url,
    );
  }

  /// 로딩 진행률 업데이트
  void onProgressChanged(int progress) {
    state = state.copyWith(progress: progress / 100);
  }

  /// 방문 히스토리 업데이트 (뒤로가기/앞으로가기 상태 갱신)
  Future<void> onUpdateVisitedHistory(String? url) async {
    final canGoBack = await _controller.canGoBack();
    final canGoForward = await _controller.canGoForward();

    state = state.copyWith(
      canGoBack: canGoBack,
      canGoForward: canGoForward,
      currentUrl: url,
    );
  }

  /// 뒤로 가기
  Future<void> goBack() async {
    if (state.canGoBack) {
      await _controller.goBack();
    }
  }

  /// 앞으로 가기
  Future<void> goForward() async {
    if (state.canGoForward) {
      await _controller.goForward();
    }
  }

  /// 새로고침
  Future<void> reload() async {
    await _controller.reload();
  }

  /// URL 이동
  Future<void> loadUrl(String url) async {
    await _controller.loadUrl(url);
  }

  /// 에러 설정
  void setError(String message) {
    _logger.e('오류: $message');
    state = state.copyWith(
      hasError: true,
      errorMessage: message,
      isLoading: false,
    );
  }

  /// 에러 초기화 (다시 시도)
  void clearError() {
    state = state.copyWith(
      hasError: false,
      errorMessage: null,
    );
  }

  /// 렌더 프로세스 종료 처리
  void onRenderProcessGone(bool didCrash) {
    _logger.w('렌더 프로세스 종료 - 크래시: $didCrash');
    setError(didCrash ? 'WebView가 크래시되었습니다' : 'WebView가 종료되었습니다');
  }

  /// URL이 허용되는지 확인
  bool isUrlAllowed(String? urlString) {
    if (urlString == null) return true;

    try {
      final uri = Uri.parse(urlString);
      final host = uri.host;

      // 문제가 되는 도메인 차단
      if (host.contains('mail.naver.com') || host.contains('nid.naver.com')) {
        _logger.w('차단된 도메인: $host');
        return false;
      }

      // http/https만 허용
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        _logger.w('차단된 스킴: ${uri.scheme}');
        return false;
      }

      return true;
    } catch (e) {
      _logger.e('URL 파싱 오류', error: e);
      return false;
    }
  }

  /// 차단된 URL 메시지 반환
  String? getBlockedMessage(String? urlString) {
    if (urlString == null) return null;

    try {
      final uri = Uri.parse(urlString);
      final host = uri.host;

      if (host.contains('mail.naver.com') || host.contains('nid.naver.com')) {
        return '$host 는 지원되지 않습니다';
      }

      if (uri.scheme != 'http' && uri.scheme != 'https') {
        return '${uri.scheme} 링크는 지원되지 않습니다';
      }

      return null;
    } catch (e) {
      return 'URL 오류: $e';
    }
  }
}
