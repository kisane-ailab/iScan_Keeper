// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telegram_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// TelegramRemoteDataSource Provider (curl 사용)

@ProviderFor(telegramRemoteDataSource)
const telegramRemoteDataSourceProvider = TelegramRemoteDataSourceProvider._();

/// TelegramRemoteDataSource Provider (curl 사용)

final class TelegramRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          TelegramRemoteDataSource,
          TelegramRemoteDataSource,
          TelegramRemoteDataSource
        >
    with $Provider<TelegramRemoteDataSource> {
  /// TelegramRemoteDataSource Provider (curl 사용)
  const TelegramRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telegramRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telegramRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<TelegramRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TelegramRemoteDataSource create(Ref ref) {
    return telegramRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TelegramRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TelegramRemoteDataSource>(value),
    );
  }
}

String _$telegramRemoteDataSourceHash() =>
    r'ed0a0469e4e5ee019dabbb0bc88d10fe0a701d99';
