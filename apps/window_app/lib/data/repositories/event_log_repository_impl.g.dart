// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_log_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// EventLogRepository Provider

@ProviderFor(eventLogRepository)
const eventLogRepositoryProvider = EventLogRepositoryProvider._();

/// EventLogRepository Provider

final class EventLogRepositoryProvider
    extends
        $FunctionalProvider<
          EventLogRepository,
          EventLogRepository,
          EventLogRepository
        >
    with $Provider<EventLogRepository> {
  /// EventLogRepository Provider
  const EventLogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventLogRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventLogRepositoryHash();

  @$internal
  @override
  $ProviderElement<EventLogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EventLogRepository create(Ref ref) {
    return eventLogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventLogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventLogRepository>(value),
    );
  }
}

String _$eventLogRepositoryHash() =>
    r'a2682ce35e27e31c40d776f77b396e4a1b269b69';
