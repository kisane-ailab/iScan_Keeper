// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tick_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 전역 1초 타이머 - 경과시간 표시용
/// 개별 위젯에서 타이머를 만들지 않고 이 Provider를 watch

@ProviderFor(TickService)
const tickServiceProvider = TickServiceProvider._();

/// 전역 1초 타이머 - 경과시간 표시용
/// 개별 위젯에서 타이머를 만들지 않고 이 Provider를 watch
final class TickServiceProvider extends $NotifierProvider<TickService, int> {
  /// 전역 1초 타이머 - 경과시간 표시용
  /// 개별 위젯에서 타이머를 만들지 않고 이 Provider를 watch
  const TickServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tickServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tickServiceHash();

  @$internal
  @override
  TickService create() => TickService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$tickServiceHash() => r'55550fc87afad47a447ecc32e3a090c1469ab61d';

/// 전역 1초 타이머 - 경과시간 표시용
/// 개별 위젯에서 타이머를 만들지 않고 이 Provider를 watch

abstract class _$TickService extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
