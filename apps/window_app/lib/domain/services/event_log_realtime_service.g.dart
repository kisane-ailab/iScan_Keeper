// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_log_realtime_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EventLogRealtimeService)
const eventLogRealtimeServiceProvider = EventLogRealtimeServiceProvider._();

final class EventLogRealtimeServiceProvider
    extends $NotifierProvider<EventLogRealtimeService, List<EventLogModel>> {
  const EventLogRealtimeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventLogRealtimeServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventLogRealtimeServiceHash();

  @$internal
  @override
  EventLogRealtimeService create() => EventLogRealtimeService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EventLogModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EventLogModel>>(value),
    );
  }
}

String _$eventLogRealtimeServiceHash() =>
    r'cbbd17c793e54d8c5fd7544f012799b2737f3483';

abstract class _$EventLogRealtimeService
    extends $Notifier<List<EventLogModel>> {
  List<EventLogModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<EventLogModel>, List<EventLogModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<EventLogModel>, List<EventLogModel>>,
              List<EventLogModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(eventLogAlerts)
const eventLogAlertsProvider = EventLogAlertsProvider._();

final class EventLogAlertsProvider
    extends
        $FunctionalProvider<
          AsyncValue<EventLogModel>,
          EventLogModel,
          Stream<EventLogModel>
        >
    with $FutureModifier<EventLogModel>, $StreamProvider<EventLogModel> {
  const EventLogAlertsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventLogAlertsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventLogAlertsHash();

  @$internal
  @override
  $StreamProviderElement<EventLogModel> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<EventLogModel> create(Ref ref) {
    return eventLogAlerts(ref);
  }
}

String _$eventLogAlertsHash() => r'a31ca5b806509f85f219bc28e0dd21485c1a3316';
