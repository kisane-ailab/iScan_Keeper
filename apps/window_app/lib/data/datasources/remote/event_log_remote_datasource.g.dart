// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_log_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// EventLogRemoteDatasource Provider

@ProviderFor(eventLogRemoteDatasource)
const eventLogRemoteDatasourceProvider = EventLogRemoteDatasourceProvider._();

/// EventLogRemoteDatasource Provider

final class EventLogRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          EventLogRemoteDatasource,
          EventLogRemoteDatasource,
          EventLogRemoteDatasource
        >
    with $Provider<EventLogRemoteDatasource> {
  /// EventLogRemoteDatasource Provider
  const EventLogRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventLogRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventLogRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<EventLogRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EventLogRemoteDatasource create(Ref ref) {
    return eventLogRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventLogRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventLogRemoteDatasource>(value),
    );
  }
}

String _$eventLogRemoteDatasourceHash() =>
    r'ff1eab76fa1d8722bcd3d0aa3e1c4fecac10b65f';
