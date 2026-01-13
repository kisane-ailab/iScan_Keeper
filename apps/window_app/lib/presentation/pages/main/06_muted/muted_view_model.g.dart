// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muted_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 숨긴 알림 ViewModel

@ProviderFor(MutedViewModel)
const mutedViewModelProvider = MutedViewModelProvider._();

/// 숨긴 알림 ViewModel
final class MutedViewModelProvider
    extends $NotifierProvider<MutedViewModel, MutedState> {
  /// 숨긴 알림 ViewModel
  const MutedViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mutedViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mutedViewModelHash();

  @$internal
  @override
  MutedViewModel create() => MutedViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MutedState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MutedState>(value),
    );
  }
}

String _$mutedViewModelHash() => r'65a22045b91c2787278eab40b8b4590311dc715b';

/// 숨긴 알림 ViewModel

abstract class _$MutedViewModel extends $Notifier<MutedState> {
  MutedState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MutedState, MutedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MutedState, MutedState>,
              MutedState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
