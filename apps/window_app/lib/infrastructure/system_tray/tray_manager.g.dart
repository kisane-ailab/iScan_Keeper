// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tray_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 항상위모드 상태 Provider

@ProviderFor(AlwaysOnTopState)
const alwaysOnTopStateProvider = AlwaysOnTopStateProvider._();

/// 항상위모드 상태 Provider
final class AlwaysOnTopStateProvider
    extends $NotifierProvider<AlwaysOnTopState, bool> {
  /// 항상위모드 상태 Provider
  const AlwaysOnTopStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alwaysOnTopStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alwaysOnTopStateHash();

  @$internal
  @override
  AlwaysOnTopState create() => AlwaysOnTopState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$alwaysOnTopStateHash() => r'd4c24e21f9b50f3f360a00a8d7e51e183f8cf051';

/// 항상위모드 상태 Provider

abstract class _$AlwaysOnTopState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
