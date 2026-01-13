import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/infrastructure/config/env_config.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';

part 'swagger_view_model.freezed.dart';
part 'swagger_view_model.g.dart';

/// Swagger WebView 컨트롤러 (독립적인 인스턴스)
@riverpod
class SwaggerWebViewController extends _$SwaggerWebViewController {
  InAppWebViewController? _controller;

  @override
  void build() {}

  bool get hasController => _controller != null;

  void setController(InAppWebViewController controller) {
    _controller = controller;
  }

  Future<bool> canGoBack() async => await _controller?.canGoBack() ?? false;
  Future<bool> canGoForward() async => await _controller?.canGoForward() ?? false;
  Future<WebUri?> getUrl() async => await _controller?.getUrl();

  Future<void> goBack() async => await _controller?.goBack();
  Future<void> goForward() async => await _controller?.goForward();
  Future<void> reload() async => await _controller?.reload();
  Future<void> loadUrl(String url) async {
    await _controller?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
  }
}

/// Swagger 화면 상태
@freezed
abstract class SwaggerState with _$SwaggerState {
  const factory SwaggerState({
    @Default(true) bool isLoading,
    @Default(0) double progress,
    @Default(false) bool canGoBack,
    @Default(false) bool canGoForward,
    String? currentUrl,
    @Default(false) bool hasError,
    String? errorMessage,
  }) = _SwaggerState;
}

/// Swagger ViewModel
@riverpod
class SwaggerViewModel extends _$SwaggerViewModel {
  SwaggerWebViewController get _controller => ref.read(swaggerWebViewControllerProvider.notifier);
  Logger get _logger => ref.read(appLoggerProvider);
  Timer? _loadingTimeout;

  @override
  SwaggerState build() {
    _initNavigationState();
    _startLoadingTimeout();

    ref.onDispose(() {
      _loadingTimeout?.cancel();
    });

    return const SwaggerState();
  }

  void _startLoadingTimeout() {
    _loadingTimeout?.cancel();
    _loadingTimeout = Timer(const Duration(seconds: 15), () {
      if (state.isLoading && state.progress < 0.1) {
        _logger.e('Swagger 로딩 타임아웃 - URL: ${EnvConfig.swaggerUrl}');
        setError(
          '연결 시간 초과 (15초)\n\n'
          'URL: ${EnvConfig.swaggerUrl}\n\n'
          '가능한 원인:\n'
          '• 서버가 실행 중이 아님\n'
          '• 네트워크 연결 문제\n'
          '• 방화벽 차단'
        );
      }
    });
  }

  Future<void> _initNavigationState() async {
    if (_controller.hasController) {
      final canGoBack = await _controller.canGoBack();
      final canGoForward = await _controller.canGoForward();
      final url = await _controller.getUrl();

      state = state.copyWith(
        isLoading: false,
        canGoBack: canGoBack,
        canGoForward: canGoForward,
        currentUrl: url?.toString(),
      );
    }
  }

  void setController(InAppWebViewController controller) {
    _controller.setController(controller);
  }

  void onLoadStart() {
    state = state.copyWith(isLoading: true);
  }

  Future<void> onLoadStop(String? url) async {
    _loadingTimeout?.cancel();

    final canGoBack = await _controller.canGoBack();
    final canGoForward = await _controller.canGoForward();

    state = state.copyWith(
      isLoading: false,
      canGoBack: canGoBack,
      canGoForward: canGoForward,
      currentUrl: url,
    );
  }

  void onProgressChanged(int progress) {
    state = state.copyWith(progress: progress / 100);
  }

  Future<void> onUpdateVisitedHistory(String? url) async {
    final canGoBack = await _controller.canGoBack();
    final canGoForward = await _controller.canGoForward();

    state = state.copyWith(
      canGoBack: canGoBack,
      canGoForward: canGoForward,
      currentUrl: url,
    );
  }

  Future<void> goBack() async {
    if (state.canGoBack) {
      await _controller.goBack();
    }
  }

  Future<void> goForward() async {
    if (state.canGoForward) {
      await _controller.goForward();
    }
  }

  Future<void> reload() async {
    await _controller.reload();
  }

  void setError(String message) {
    state = state.copyWith(
      hasError: true,
      errorMessage: message,
      isLoading: false,
    );
  }

  void clearError() {
    state = state.copyWith(
      hasError: false,
      errorMessage: null,
    );
  }
}
