// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// UserRemoteDatasource Provider

@ProviderFor(userRemoteDatasource)
const userRemoteDatasourceProvider = UserRemoteDatasourceProvider._();

/// UserRemoteDatasource Provider

final class UserRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          UserRemoteDatasource,
          UserRemoteDatasource,
          UserRemoteDatasource
        >
    with $Provider<UserRemoteDatasource> {
  /// UserRemoteDatasource Provider
  const UserRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<UserRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserRemoteDatasource create(Ref ref) {
    return userRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRemoteDatasource>(value),
    );
  }
}

String _$userRemoteDatasourceHash() =>
    r'505d021270a3755a464fe9743e1f47ea01a85b18';
