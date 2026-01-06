// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ResponseRemoteDatasource Provider

@ProviderFor(responseRemoteDatasource)
const responseRemoteDatasourceProvider = ResponseRemoteDatasourceProvider._();

/// ResponseRemoteDatasource Provider

final class ResponseRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          ResponseRemoteDatasource,
          ResponseRemoteDatasource,
          ResponseRemoteDatasource
        >
    with $Provider<ResponseRemoteDatasource> {
  /// ResponseRemoteDatasource Provider
  const ResponseRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'responseRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$responseRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<ResponseRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ResponseRemoteDatasource create(Ref ref) {
    return responseRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResponseRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResponseRemoteDatasource>(value),
    );
  }
}

String _$responseRemoteDatasourceHash() =>
    r'b39ffa7bcd0c61cdb483667caf20e2861f589d74';
