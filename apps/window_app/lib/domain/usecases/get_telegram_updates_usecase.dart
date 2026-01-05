import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/repositories/telegram_repository.dart';
import 'package:window_app/data/repositories/telegram_repository_impl.dart';

part 'get_telegram_updates_usecase.g.dart';

/// Telegram Updates 조회 UseCase
class GetTelegramUpdatesUseCase {
  final TelegramRepository _repository;

  GetTelegramUpdatesUseCase(this._repository);

  /// 업데이트 조회 (캐시 우선, 리모트 업데이트)
  Stream<dynamic> call([bool forceRefresh = false]) {
    return _repository.getUpdates(forceRefresh);
  }

  /// 캐시 삭제
  Future<void> clearCache() {
    return _repository.clearCache();
  }
}

/// GetTelegramUpdatesUseCase Provider
@riverpod
GetTelegramUpdatesUseCase getTelegramUpdatesUseCase(Ref ref) {
  final repository = ref.watch(telegramRepositoryProvider);
  return GetTelegramUpdatesUseCase(repository);
}
