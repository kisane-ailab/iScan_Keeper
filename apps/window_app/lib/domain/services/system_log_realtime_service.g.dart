// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_log_realtime_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SystemLogRealtimeService)
const systemLogRealtimeServiceProvider = SystemLogRealtimeServiceProvider._();

final class SystemLogRealtimeServiceProvider
    extends $NotifierProvider<SystemLogRealtimeService, List<SystemLogEntity>> {
  const SystemLogRealtimeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemLogRealtimeServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemLogRealtimeServiceHash();

  @$internal
  @override
  SystemLogRealtimeService create() => SystemLogRealtimeService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SystemLogEntity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SystemLogEntity>>(value),
    );
  }
}

String _$systemLogRealtimeServiceHash() =>
    r'd82c9982944ba12c1e00920248255ebad628780c';

abstract class _$SystemLogRealtimeService
    extends $Notifier<List<SystemLogEntity>> {
  List<SystemLogEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<SystemLogEntity>, List<SystemLogEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SystemLogEntity>, List<SystemLogEntity>>,
              List<SystemLogEntity>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(systemLogAlerts)
const systemLogAlertsProvider = SystemLogAlertsProvider._();

final class SystemLogAlertsProvider
    extends
        $FunctionalProvider<
          AsyncValue<SystemLogEntity>,
          SystemLogEntity,
          Stream<SystemLogEntity>
        >
    with $FutureModifier<SystemLogEntity>, $StreamProvider<SystemLogEntity> {
  const SystemLogAlertsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemLogAlertsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemLogAlertsHash();

  @$internal
  @override
  $StreamProviderElement<SystemLogEntity> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SystemLogEntity> create(Ref ref) {
    return systemLogAlerts(ref);
  }
}

String _$systemLogAlertsHash() => r'cb24c749ab87c05e7fdbc1d4c63efb81cd534be1';
