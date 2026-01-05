// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webview_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// WebViewController Provider

@ProviderFor(appWebViewController)
const appWebViewControllerProvider = AppWebViewControllerProvider._();

/// WebViewController Provider

final class AppWebViewControllerProvider
    extends
        $FunctionalProvider<
          AppWebViewController,
          AppWebViewController,
          AppWebViewController
        >
    with $Provider<AppWebViewController> {
  /// WebViewController Provider
  const AppWebViewControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appWebViewControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appWebViewControllerHash();

  @$internal
  @override
  $ProviderElement<AppWebViewController> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppWebViewController create(Ref ref) {
    return appWebViewController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppWebViewController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppWebViewController>(value),
    );
  }
}

String _$appWebViewControllerHash() =>
    r'1c4406237eb931c381b1b010cd7ec9b6fa4e6b78';
