// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// StatsRemoteDatasource Provider

@ProviderFor(statsRemoteDatasource)
const statsRemoteDatasourceProvider = StatsRemoteDatasourceProvider._();

/// StatsRemoteDatasource Provider

final class StatsRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          StatsRemoteDatasource,
          StatsRemoteDatasource,
          StatsRemoteDatasource
        >
    with $Provider<StatsRemoteDatasource> {
  /// StatsRemoteDatasource Provider
  const StatsRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<StatsRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StatsRemoteDatasource create(Ref ref) {
    return statsRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatsRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatsRemoteDatasource>(value),
    );
  }
}

String _$statsRemoteDatasourceHash() =>
    r'466f6bc04285ad3c91f3b836e0346fb81174135a';
