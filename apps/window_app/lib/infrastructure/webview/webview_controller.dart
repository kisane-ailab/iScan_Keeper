import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'webview_controller.g.dart';

/// WebView 컨트롤러 래퍼
/// InAppWebViewController를 관리하고 네비게이션 기능 제공
class AppWebViewController {
  InAppWebViewController? _controller;

  /// WebView 컨트롤러 설정
  void setController(InAppWebViewController controller) {
    _controller = controller;
  }

  /// 컨트롤러 해제
  void clearController() {
    _controller = null;
  }

  /// 컨트롤러 존재 여부
  bool get hasController => _controller != null;

  /// 뒤로 가기
  Future<void> goBack() async {
    await _controller?.goBack();
  }

  /// 앞으로 가기
  Future<void> goForward() async {
    await _controller?.goForward();
  }

  /// 새로고침
  Future<void> reload() async {
    await _controller?.reload();
  }

  /// 뒤로 갈 수 있는지 확인
  Future<bool> canGoBack() async {
    return await _controller?.canGoBack() ?? false;
  }

  /// 앞으로 갈 수 있는지 확인
  Future<bool> canGoForward() async {
    return await _controller?.canGoForward() ?? false;
  }

  /// 현재 URL 조회
  Future<WebUri?> getUrl() async {
    return await _controller?.getUrl();
  }

  /// 특정 URL로 이동
  Future<void> loadUrl(String url) async {
    await _controller?.loadUrl(
      urlRequest: URLRequest(url: WebUri(url)),
    );
  }
}

/// WebViewController Provider
@Riverpod(keepAlive: true)
AppWebViewController appWebViewController(Ref ref) {
  return AppWebViewController();
}
