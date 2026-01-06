// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_response_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EventResponseService)
const eventResponseServiceProvider = EventResponseServiceProvider._();

final class EventResponseServiceProvider
    extends $NotifierProvider<EventResponseService, List<String>> {
  const EventResponseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventResponseServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventResponseServiceHash();

  @$internal
  @override
  EventResponseService create() => EventResponseService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$eventResponseServiceHash() =>
    r'575793fadea367bbadd7035a821634dcc5959c81';

abstract class _$EventResponseService extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
