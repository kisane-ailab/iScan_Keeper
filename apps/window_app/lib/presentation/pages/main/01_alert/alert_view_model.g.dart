// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Alert ViewModel

@ProviderFor(AlertViewModel)
const alertViewModelProvider = AlertViewModelProvider._();

/// Alert ViewModel
final class AlertViewModelProvider
    extends $NotifierProvider<AlertViewModel, AlertState> {
  /// Alert ViewModel
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

String _$alertViewModelHash() => r'c94ce94075fc897410f3750ab94c041e41fa7cc5';

/// Alert ViewModel

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
