// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telegram_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// TelegramLocalDataSource Provider

@ProviderFor(telegramLocalDataSource)
const telegramLocalDataSourceProvider = TelegramLocalDataSourceProvider._();

/// TelegramLocalDataSource Provider

final class TelegramLocalDataSourceProvider
    extends
        $FunctionalProvider<
          TelegramLocalDataSource,
          TelegramLocalDataSource,
          TelegramLocalDataSource
        >
    with $Provider<TelegramLocalDataSource> {
  /// TelegramLocalDataSource Provider
  const TelegramLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telegramLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telegramLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<TelegramLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TelegramLocalDataSource create(Ref ref) {
    return telegramLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TelegramLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TelegramLocalDataSource>(value),
    );
  }
}

String _$telegramLocalDataSourceHash() =>
    r'805c2323f05c8734d1a1fc11e712a6768cb8ff79';
