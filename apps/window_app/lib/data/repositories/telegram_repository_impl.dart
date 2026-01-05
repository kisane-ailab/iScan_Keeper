import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/datasources/local/telegram_local_datasource.dart';
import 'package:window_app/data/datasources/remote/telegram_remote_datasource.dart';
import 'package:window_app/data/repositories/telegram_repository.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';

part 'telegram_repository_impl.g.dart';

/// Telegram Repository 구현체
/// Cache-First 패턴: 로컬 캐시 먼저 → 리모트 업데이트
class TelegramRepositoryImpl implements TelegramRepository {
  final TelegramRemoteDataSource _remoteDataSource;
  final TelegramLocalDataSource _localDataSource;

  TelegramRepositoryImpl({
    required TelegramRemoteDataSource remoteDataSource,
    required TelegramLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Stream<dynamic> getUpdates([bool forceRefresh = false]) async* {
    logger.i('업데이트 조회 시작, 강제새로고침: $forceRefresh');

    // 1. 캐시 먼저 반환 (빠른 응답)
    if (!forceRefresh) {
      final cached = _localDataSource.getCachedUpdates();
      if (cached != null) {
        yield cached;
      }
    }

    // 2. 리모트에서 최신 데이터 가져오기
    try {
      final remote = await _remoteDataSource.getUpdates(TelegramRemoteDataSource.token);

      // 3. 캐시 저장
      await _localDataSource.cacheUpdates(remote);

      // 4. 최신 데이터 반환
      yield remote;
    } catch (e, stackTrace) {
      logger.e('원격 데이터 조회 실패', error: e, stackTrace: stackTrace);
      // 리모트 실패 시, 캐시가 없었다면 에러 throw
      final cached = _localDataSource.getCachedUpdates();
      if (cached == null) {
        rethrow;
      }
      // 캐시가 있었다면 이미 반환했으므로 무시
    }
  }

  @override
  Future<void> clearCache() async {
    await _localDataSource.clearCache();
  }
}

/// TelegramRepository Provider
@riverpod
TelegramRepository telegramRepository(Ref ref) {
  final remoteDataSource = ref.watch(telegramRemoteDataSourceProvider);
  final localDataSource = ref.watch(telegramLocalDataSourceProvider);

  return TelegramRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
}
