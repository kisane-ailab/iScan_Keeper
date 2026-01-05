// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_telegram_updates_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// GetTelegramUpdatesUseCase Provider

@ProviderFor(getTelegramUpdatesUseCase)
const getTelegramUpdatesUseCaseProvider = GetTelegramUpdatesUseCaseProvider._();

/// GetTelegramUpdatesUseCase Provider

final class GetTelegramUpdatesUseCaseProvider
    extends
        $FunctionalProvider<
          GetTelegramUpdatesUseCase,
          GetTelegramUpdatesUseCase,
          GetTelegramUpdatesUseCase
        >
    with $Provider<GetTelegramUpdatesUseCase> {
  /// GetTelegramUpdatesUseCase Provider
  const GetTelegramUpdatesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getTelegramUpdatesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getTelegramUpdatesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetTelegramUpdatesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetTelegramUpdatesUseCase create(Ref ref) {
    return getTelegramUpdatesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetTelegramUpdatesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetTelegramUpdatesUseCase>(value),
    );
  }
}

String _$getTelegramUpdatesUseCaseHash() =>
    r'd8257eabd9bd05a49a949ad74474867ff00a543d';
