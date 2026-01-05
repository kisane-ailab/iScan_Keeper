/// Telegram Repository 인터페이스
abstract class TelegramRepository {
  /// getUpdates 조회
  /// [forceRefresh] true면 캐시 무시하고 리모트에서 조회
  Stream<dynamic> getUpdates([bool forceRefresh = false]);

  /// 캐시 삭제
  Future<void> clearCache();
}
