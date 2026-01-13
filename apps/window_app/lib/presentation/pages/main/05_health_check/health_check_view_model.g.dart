// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_check_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// HealthCheck ViewModel

@ProviderFor(HealthCheckViewModel)
const healthCheckViewModelProvider = HealthCheckViewModelProvider._();

/// HealthCheck ViewModel
final class HealthCheckViewModelProvider
    extends $NotifierProvider<HealthCheckViewModel, HealthCheckState> {
  /// HealthCheck ViewModel
  const HealthCheckViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthCheckViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthCheckViewModelHash();

  @$internal
  @override
  HealthCheckViewModel create() => HealthCheckViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthCheckState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthCheckState>(value),
    );
  }
}

String _$healthCheckViewModelHash() =>
    r'ee0630b749974c24b61ab8403f8602473d0aee7f';

/// HealthCheck ViewModel

abstract class _$HealthCheckViewModel extends $Notifier<HealthCheckState> {
  HealthCheckState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<HealthCheckState, HealthCheckState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HealthCheckState, HealthCheckState>,
              HealthCheckState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
