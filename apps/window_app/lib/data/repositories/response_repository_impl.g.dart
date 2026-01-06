// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ResponseRepository Provider

@ProviderFor(responseRepository)
const responseRepositoryProvider = ResponseRepositoryProvider._();

/// ResponseRepository Provider

final class ResponseRepositoryProvider
    extends
        $FunctionalProvider<
          ResponseRepository,
          ResponseRepository,
          ResponseRepository
        >
    with $Provider<ResponseRepository> {
  /// ResponseRepository Provider
  const ResponseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'responseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$responseRepositoryHash();

  @$internal
  @override
  $ProviderElement<ResponseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ResponseRepository create(Ref ref) {
    return responseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResponseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResponseRepository>(value),
    );
  }
}

String _$responseRepositoryHash() =>
    r'987db952b8c68884e3dd877ecbd10162ce66e612';
