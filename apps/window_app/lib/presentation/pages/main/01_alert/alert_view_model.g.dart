// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Alert ViewModel (이벤트 전용)

@ProviderFor(AlertViewModel)
const alertViewModelProvider = AlertViewModelProvider._();

/// Alert ViewModel (이벤트 전용)
final class AlertViewModelProvider
    extends $NotifierProvider<AlertViewModel, AlertState> {
  /// Alert ViewModel (이벤트 전용)
  const AlertViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alertViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alertViewModelHash();

  @$internal
  @override
  AlertViewModel create() => AlertViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlertState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlertState>(value),
    );
  }
}

String _$alertViewModelHash() => r'8ce81ac6d1543a39c54a9edd20381ae14c343095';

/// Alert ViewModel (이벤트 전용)

abstract class _$AlertViewModel extends $Notifier<AlertState> {
  AlertState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AlertState, AlertState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AlertState, AlertState>,
              AlertState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
