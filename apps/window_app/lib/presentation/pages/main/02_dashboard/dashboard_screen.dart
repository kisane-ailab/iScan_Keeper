import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/infrastructure/config/env_config.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/presentation/layout/base_page.dart';
import 'dashboard_view_model.dart';

class DashboardScreen extends BasePage {
  const DashboardScreen({super.key});

  static const String path = '/dashboard';
  static const String name = 'dashboard';

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardViewModelProvider);
    final viewModel = ref.read(dashboardViewModelProvider.notifier);

    return AppBar(
      title: const Text('대시보드'),
      actions: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: state.canGoBack ? null : Colors.grey,
          ),
          onPressed: () => viewModel.goBack(),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward,
            color: state.canGoForward ? null : Colors.grey,
          ),
          onPressed: () => viewModel.goForward(),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            if (state.hasError) {
              viewModel.clearError();
            } else {
              viewModel.reload();
            }
          },
        ),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardViewModelProvider);
    final viewModel = ref.read(dashboardViewModelProvider.notifier);

    if (state.hasError) {
      return _buildErrorWidget(state, viewModel);
    }

    return _buildWebView(context, state, viewModel);
  }

  Widget _buildErrorWidget(DashboardState state, DashboardViewModel viewModel) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'WebView 오류가 발생했습니다',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '대시보드 URL: ${EnvConfig.dashboardUrl}',
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage ?? '알 수 없는 오류',
                    style: const TextStyle(fontSize: 13, color: Colors.red),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => viewModel.clearError(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('다시 시도'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => viewModel.loadUrl(EnvConfig.dashboardUrl),
                  icon: const Icon(Icons.home),
                  label: const Text('홈으로'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebView(
    BuildContext context,
    DashboardState state,
    DashboardViewModel viewModel,
  ) {
    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(EnvConfig.dashboardUrl)),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            domStorageEnabled: true,
            supportZoom: true,
            useWideViewPort: true,
            javaScriptCanOpenWindowsAutomatically: true,
            supportMultipleWindows: true,
            isInspectable: true,
            mediaPlaybackRequiresUserGesture: true,
            allowsInlineMediaPlayback: true,
            hardwareAcceleration: false,
            userAgent:
                'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
          ),
          onWebViewCreated: (controller) {
            viewModel.setController(controller);
          },
          onLoadStart: (controller, url) {
            viewModel.onLoadStart();
          },
          onLoadStop: (controller, url) {
            viewModel.onLoadStop(url?.toString());
          },
          onProgressChanged: (controller, progress) {
            viewModel.onProgressChanged(progress);
          },
          onUpdateVisitedHistory: (controller, url, isReload) {
            if (isReload != true) {
              viewModel.onUpdateVisitedHistory(url?.toString());
            }
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final url = navigationAction.request.url?.toString();

            if (!viewModel.isUrlAllowed(url)) {
              final message = viewModel.getBlockedMessage(url);
              if (message != null && context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message)));
              }
              return NavigationActionPolicy.CANCEL;
            }
            return NavigationActionPolicy.ALLOW;
          },
          onCreateWindow: (controller, createWindowAction) async {
            final url = createWindowAction.request.url;

            if (!viewModel.isUrlAllowed(url?.toString())) {
              final message = viewModel.getBlockedMessage(url?.toString());
              if (message != null && context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message)));
              }
              return false;
            }

            if (url != null) {
              await controller.loadUrl(urlRequest: URLRequest(url: url));
            }
            return false;
          },
          onConsoleMessage: (controller, consoleMessage) {
            logger.d('[웹뷰 콘솔] ${consoleMessage.messageLevel}: ${consoleMessage.message}');
          },
          onLoadError: (controller, url, code, message) {
            logger.e('로딩 오류 - URL: $url, 코드: $code, 메시지: $message');
            viewModel.setError('페이지 로드 실패\n\nURL: $url\n오류 코드: $code\n$message');
          },
          onLoadHttpError: (controller, url, statusCode, description) {
            logger.w('HTTP 오류 - $statusCode: $description');
            if (statusCode >= 400) {
              viewModel.setError('HTTP 오류 $statusCode\n\nURL: $url\n$description');
            }
          },
          onReceivedError: (controller, request, error) {
            logger.e('연결 오류 - ${error.type}: ${error.description}');
            viewModel.setError('연결 오류\n\nURL: ${request.url}\n${error.type}: ${error.description}');
          },
          onRenderProcessGone: (controller, detail) {
            viewModel.onRenderProcessGone(detail.didCrash ?? false);
          },
        ),
        // 로딩 중 오버레이
        if (state.isLoading)
          Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    '로딩 중... ${(state.progress * 100).toInt()}%',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    EnvConfig.dashboardUrl,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  bool get wrapWithSafeArea => false;
}
