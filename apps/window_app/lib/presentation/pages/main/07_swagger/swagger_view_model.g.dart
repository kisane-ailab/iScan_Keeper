// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swagger_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Swagger WebView 컨트롤러 (독립적인 인스턴스)

@ProviderFor(SwaggerWebViewController)
const swaggerWebViewControllerProvider = SwaggerWebViewControllerProvider._();

/// Swagger WebView 컨트롤러 (독립적인 인스턴스)
final class SwaggerWebViewControllerProvider
    extends $NotifierProvider<SwaggerWebViewController, void> {
  /// Swagger WebView 컨트롤러 (독립적인 인스턴스)
  const SwaggerWebViewControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swaggerWebViewControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swaggerWebViewControllerHash();

  @$internal
  @override
  SwaggerWebViewController create() => SwaggerWebViewController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$swaggerWebViewControllerHash() =>
    r'bc9961dc8bd83ab616151984424f1363ae95c753';

/// Swagger WebView 컨트롤러 (독립적인 인스턴스)

abstract class _$SwaggerWebViewController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

/// Swagger ViewModel

@ProviderFor(SwaggerViewModel)
const swaggerViewModelProvider = SwaggerViewModelProvider._();

/// Swagger ViewModel
final class SwaggerViewModelProvider
    extends $NotifierProvider<SwaggerViewModel, SwaggerState> {
  /// Swagger ViewModel
  const SwaggerViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swaggerViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swaggerViewModelHash();

  @$internal
  @override
  SwaggerViewModel create() => SwaggerViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SwaggerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SwaggerState>(value),
    );
  }
}

String _$swaggerViewModelHash() => r'b44e1bf6129be30db48258fed839fdf5b521e31b';

/// Swagger ViewModel

abstract class _$SwaggerViewModel extends $Notifier<SwaggerState> {
  SwaggerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SwaggerState, SwaggerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SwaggerState, SwaggerState>,
              SwaggerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
