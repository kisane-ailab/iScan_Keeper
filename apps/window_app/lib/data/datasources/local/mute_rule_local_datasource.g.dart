// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_rule_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// SharedPreferences Provider

@ProviderFor(sharedPreferences)
const sharedPreferencesProvider = SharedPreferencesProvider._();

/// SharedPreferences Provider

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  /// SharedPreferences Provider
  const SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'dc403fbb1d968c7d5ab4ae1721a29ffe173701c7';

/// MuteRuleLocalDatasource Provider

@ProviderFor(muteRuleLocalDatasource)
const muteRuleLocalDatasourceProvider = MuteRuleLocalDatasourceProvider._();

/// MuteRuleLocalDatasource Provider

final class MuteRuleLocalDatasourceProvider
    extends
        $FunctionalProvider<
          MuteRuleLocalDatasource,
          MuteRuleLocalDatasource,
          MuteRuleLocalDatasource
        >
    with $Provider<MuteRuleLocalDatasource> {
  /// MuteRuleLocalDatasource Provider
  const MuteRuleLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'muteRuleLocalDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$muteRuleLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<MuteRuleLocalDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MuteRuleLocalDatasource create(Ref ref) {
    return muteRuleLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MuteRuleLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MuteRuleLocalDatasource>(value),
    );
  }
}

String _$muteRuleLocalDatasourceHash() =>
    r'8a9c0bc005203842ac0fa0d8939e6e957ceb1e34';
