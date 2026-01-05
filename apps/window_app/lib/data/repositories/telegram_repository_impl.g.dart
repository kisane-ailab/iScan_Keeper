// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telegram_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// TelegramRepository Provider

@ProviderFor(telegramRepository)
const telegramRepositoryProvider = TelegramRepositoryProvider._();

/// TelegramRepository Provider

final class TelegramRepositoryProvider
    extends
        $FunctionalProvider<
          TelegramRepository,
          TelegramRepository,
          TelegramRepository
        >
    with $Provider<TelegramRepository> {
  /// TelegramRepository Provider
  const TelegramRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telegramRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telegramRepositoryHash();

  @$internal
  @override
  $ProviderElement<TelegramRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TelegramRepository create(Ref ref) {
    return telegramRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TelegramRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TelegramRepository>(value),
    );
  }
}

String _$telegramRepositoryHash() =>
    r'47488a7f9fd867b93b8e766fc00e8076c61e2e39';
