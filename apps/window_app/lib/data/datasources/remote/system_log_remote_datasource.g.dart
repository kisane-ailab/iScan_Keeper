// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_log_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// SystemLogRemoteDatasource Provider

@ProviderFor(systemLogRemoteDatasource)
const systemLogRemoteDatasourceProvider = SystemLogRemoteDatasourceProvider._();

/// SystemLogRemoteDatasource Provider

final class SystemLogRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          SystemLogRemoteDatasource,
          SystemLogRemoteDatasource,
          SystemLogRemoteDatasource
        >
    with $Provider<SystemLogRemoteDatasource> {
  /// SystemLogRemoteDatasource Provider
  const SystemLogRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemLogRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemLogRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<SystemLogRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SystemLogRemoteDatasource create(Ref ref) {
    return systemLogRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SystemLogRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SystemLogRemoteDatasource>(value),
    );
  }
}

String _$systemLogRemoteDatasourceHash() =>
    r'fca115c461b4ba95a26773d79ecb887ae5eb4c1a';
