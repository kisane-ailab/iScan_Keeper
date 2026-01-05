// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telegram_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// TelegramService Provider

@ProviderFor(telegramService)
const telegramServiceProvider = TelegramServiceProvider._();

/// TelegramService Provider

final class TelegramServiceProvider
    extends
        $FunctionalProvider<TelegramService, TelegramService, TelegramService>
    with $Provider<TelegramService> {
  /// TelegramService Provider
  const TelegramServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telegramServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telegramServiceHash();

  @$internal
  @override
  $ProviderElement<TelegramService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TelegramService create(Ref ref) {
    return telegramService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TelegramService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TelegramService>(value),
    );
  }
}

String _$telegramServiceHash() => r'33cfa7d0f15fc5fa52f1dc4a062ecfce62218bfc';

/// Telegram Updates Stream Provider
/// UI에서 사용하는 최종 Provider

@ProviderFor(TelegramUpdates)
const telegramUpdatesProvider = TelegramUpdatesProvider._();

/// Telegram Updates Stream Provider
/// UI에서 사용하는 최종 Provider
final class TelegramUpdatesProvider
    extends $StreamNotifierProvider<TelegramUpdates, dynamic> {
  /// Telegram Updates Stream Provider
  /// UI에서 사용하는 최종 Provider
  const TelegramUpdatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telegramUpdatesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telegramUpdatesHash();

  @$internal
  @override
  TelegramUpdates create() => TelegramUpdates();
}

String _$telegramUpdatesHash() => r'c5df952f33ca3df5e86f1367600dca3f60c5f110';

/// Telegram Updates Stream Provider
/// UI에서 사용하는 최종 Provider

abstract class _$TelegramUpdates extends $StreamNotifier<dynamic> {
  Stream<dynamic> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<dynamic>, dynamic>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<dynamic>, dynamic>,
              AsyncValue<dynamic>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
