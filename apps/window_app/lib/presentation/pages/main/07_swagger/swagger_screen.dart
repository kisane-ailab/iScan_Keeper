import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/infrastructure/config/env_config.dart';
import 'package:window_app/presentation/layout/base_page.dart';
import 'package:window_app/presentation/widgets/admin_label.dart';
import 'swagger_view_model.dart';

class SwaggerScreen extends BasePage {
  const SwaggerScreen({super.key});

  static const String path = '/swagger';
  static const String name = 'swagger';

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    final state = ref.watch(swaggerViewModelProvider);
    final viewModel = ref.read(swaggerViewModelProvider.notifier);

    return AppBar(
      title: const AppBarTitleWithLabel(title: 'API 문서'),
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
    final state = ref.watch(swaggerViewModelProvider);
    final viewModel = ref.read(swaggerViewModelProvider.notifier);

    if (state.hasError) {
      return _buildErrorWidget(state, viewModel);
    }

    return _buildWebView(context, state, viewModel);
  }

  Widget _buildErrorWidget(SwaggerState state, SwaggerViewModel viewModel) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Swagger 로딩 오류',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                state.errorMessage ?? '알 수 없는 오류',
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => viewModel.clearError(),
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebView(BuildContext context, SwaggerState state, SwaggerViewModel viewModel) {
    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(EnvConfig.swaggerUrl),
          ),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            domStorageEnabled: true,
            databaseEnabled: true,
            allowFileAccess: true,
            allowContentAccess: true,
            mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            useWideViewPort: true,
            loadWithOverviewMode: true,
            supportZoom: true,
            builtInZoomControls: true,
            displayZoomControls: false,
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
          onUpdateVisitedHistory: (controller, url, androidIsReload) {
            viewModel.onUpdateVisitedHistory(url?.toString());
          },
          onReceivedError: (controller, request, error) {
            if (request.url.toString() == EnvConfig.swaggerUrl) {
              viewModel.setError(
                '페이지 로드 실패\n\n'
                'URL: ${request.url}\n'
                '오류: ${error.description}'
              );
            }
          },
          onReceivedHttpError: (controller, request, response) {
            if (request.url.toString() == EnvConfig.swaggerUrl) {
              viewModel.setError(
                'HTTP 오류\n\n'
                'URL: ${request.url}\n'
                '상태: ${response.statusCode}'
              );
            }
          },
        ),
        // 로딩 인디케이터
        if (state.isLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: state.progress > 0 ? state.progress : null,
              backgroundColor: Colors.grey[200],
            ),
          ),
      ],
    );
  }
}
