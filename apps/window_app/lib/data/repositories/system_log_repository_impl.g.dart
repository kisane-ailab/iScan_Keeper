// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_log_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// SystemLogRepository Provider

@ProviderFor(systemLogRepository)
const systemLogRepositoryProvider = SystemLogRepositoryProvider._();

/// SystemLogRepository Provider

final class SystemLogRepositoryProvider
    extends
        $FunctionalProvider<
          SystemLogRepository,
          SystemLogRepository,
          SystemLogRepository
        >
    with $Provider<SystemLogRepository> {
  /// SystemLogRepository Provider
  const SystemLogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemLogRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemLogRepositoryHash();

  @$internal
  @override
  $ProviderElement<SystemLogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SystemLogRepository create(Ref ref) {
    return systemLogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SystemLogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SystemLogRepository>(value),
    );
  }
}

String _$systemLogRepositoryHash() =>
    r'd36512aff7dd152a1ba4136cded9ac61283fbe0a';
