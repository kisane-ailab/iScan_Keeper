// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_log_cache_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// SystemLogCacheService Provider

@ProviderFor(systemLogCacheService)
const systemLogCacheServiceProvider = SystemLogCacheServiceProvider._();

/// SystemLogCacheService Provider

final class SystemLogCacheServiceProvider
    extends
        $FunctionalProvider<
          SystemLogCacheService,
          SystemLogCacheService,
          SystemLogCacheService
        >
    with $Provider<SystemLogCacheService> {
  /// SystemLogCacheService Provider
  const SystemLogCacheServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemLogCacheServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemLogCacheServiceHash();

  @$internal
  @override
  $ProviderElement<SystemLogCacheService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SystemLogCacheService create(Ref ref) {
    return systemLogCacheService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SystemLogCacheService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SystemLogCacheService>(value),
    );
  }
}

String _$systemLogCacheServiceHash() =>
    r'6c605cf13969bf599fffa10ddf2a6ddbb0ab4263';
