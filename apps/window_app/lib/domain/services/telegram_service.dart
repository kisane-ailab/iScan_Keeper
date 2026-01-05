import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/domain/usecases/get_telegram_updates_usecase.dart';

part 'telegram_service.g.dart';

/// Telegram Service
/// UseCase를 조합하여 비즈니스 로직 처리
class TelegramService {
  final GetTelegramUpdatesUseCase _getUpdatesUseCase;

  TelegramService(this._getUpdatesUseCase);

  /// 업데이트 조회
  Stream<dynamic> getUpdates([bool forceRefresh = false]) {
    return _getUpdatesUseCase(forceRefresh);
  }

  /// 캐시 삭제
  Future<void> clearCache() {
    return _getUpdatesUseCase.clearCache();
  }
}

/// TelegramService Provider
@riverpod
TelegramService telegramService(Ref ref) {
  final getUpdatesUseCase = ref.watch(getTelegramUpdatesUseCaseProvider);
  return TelegramService(getUpdatesUseCase);
}

/// Telegram Updates Stream Provider
/// UI에서 사용하는 최종 Provider
@riverpod
class TelegramUpdates extends _$TelegramUpdates {
  @override
  Stream<dynamic> build() async* {
    final service = ref.watch(telegramServiceProvider);
    yield* service.getUpdates();
  }

  /// 강제 새로고침
  Future<void> refresh() async {
    state = const AsyncLoading();
    final service = ref.read(telegramServiceProvider);

    await for (final data in service.getUpdates(true)) {
      state = AsyncData(data);
    }
  }

  /// 캐시 삭제
  Future<void> clearCache() async {
    final service = ref.read(telegramServiceProvider);
    await service.clearCache();
  }
}
