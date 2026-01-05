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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('WebView 오류가 발생했습니다'),
          const SizedBox(height: 8),
          Text(
            state.errorMessage ?? '',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => viewModel.clearError(),
            child: const Text('다시 시도'),
          ),
        ],
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
            logger.e('로딩 오류 - 코드: $code, 메시지: $message');
          },
          onLoadHttpError: (controller, url, statusCode, description) {
            logger.w('HTTP 오류 - $statusCode: $description');
          },
          onRenderProcessGone: (controller, detail) {
            viewModel.onRenderProcessGone(detail.didCrash ?? false);
          },
        ),
        if (state.isLoading)
          LinearProgressIndicator(
            value: state.progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
      ],
    );
  }

  @override
  bool get wrapWithSafeArea => false;
}
