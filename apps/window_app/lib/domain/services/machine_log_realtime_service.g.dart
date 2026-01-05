// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_log_realtime_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MachineLogRealtimeService)
const machineLogRealtimeServiceProvider = MachineLogRealtimeServiceProvider._();

final class MachineLogRealtimeServiceProvider
    extends
        $NotifierProvider<MachineLogRealtimeService, List<MachineLogModel>> {
  const MachineLogRealtimeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'machineLogRealtimeServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$machineLogRealtimeServiceHash();

  @$internal
  @override
  MachineLogRealtimeService create() => MachineLogRealtimeService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MachineLogModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MachineLogModel>>(value),
    );
  }
}

String _$machineLogRealtimeServiceHash() =>
    r'7f9a83e6c12c7b83a2825d862e2865b88cbba1c5';

abstract class _$MachineLogRealtimeService
    extends $Notifier<List<MachineLogModel>> {
  List<MachineLogModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<MachineLogModel>, List<MachineLogModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<MachineLogModel>, List<MachineLogModel>>,
              List<MachineLogModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(machineLogAlerts)
const machineLogAlertsProvider = MachineLogAlertsProvider._();

final class MachineLogAlertsProvider
    extends
        $FunctionalProvider<
          AsyncValue<MachineLogModel>,
          MachineLogModel,
          Stream<MachineLogModel>
        >
    with $FutureModifier<MachineLogModel>, $StreamProvider<MachineLogModel> {
  const MachineLogAlertsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'machineLogAlertsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$machineLogAlertsHash();

  @$internal
  @override
  $StreamProviderElement<MachineLogModel> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<MachineLogModel> create(Ref ref) {
    return machineLogAlerts(ref);
  }
}

String _$machineLogAlertsHash() => r'452b1680a14e10695892518dbee0e0bb3cb75a79';
