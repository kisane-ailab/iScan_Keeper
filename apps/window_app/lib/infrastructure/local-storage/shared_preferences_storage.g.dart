// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_preferences_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// LocalStorage Provider
/// main.dart에서 ProviderScope.overrides로 주입

@ProviderFor(localStorage)
const localStorageProvider = LocalStorageProvider._();

/// LocalStorage Provider
/// main.dart에서 ProviderScope.overrides로 주입

final class LocalStorageProvider
    extends $FunctionalProvider<LocalStorage, LocalStorage, LocalStorage>
    with $Provider<LocalStorage> {
  /// LocalStorage Provider
  /// main.dart에서 ProviderScope.overrides로 주입
  const LocalStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localStorageHash();

  @$internal
  @override
  $ProviderElement<LocalStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalStorage create(Ref ref) {
    return localStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalStorage>(value),
    );
  }
}

String _$localStorageHash() => r'28a1260b5aa6bfd6c95ad08787cb9369f21f6330';
