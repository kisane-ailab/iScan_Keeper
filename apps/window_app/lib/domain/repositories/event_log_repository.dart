/// EventLog Repository 인터페이스
abstract class EventLogRepository {
  /// 이벤트 로그 목록 조회 (페이지네이션)
  Future<List<Map<String, dynamic>>> getEventLogs({
    int page = 1,
    int limit = 20,
    String? responseStatus,
    String? logLevel,
  });

  /// 이벤트 로그 상세 조회
  Future<Map<String, dynamic>?> getEventLog(String id);

  /// 미확인 로그 조회
  Future<List<Map<String, dynamic>>> getUncheckedLogs({int limit = 50});

  /// 미확인/대응중 알림 로그 조회 (warning, error, critical)
  Future<List<Map<String, dynamic>>> getPendingAlerts({int limit = 50});

  /// 이벤트 로그 생성 (테스트용)
  Future<Map<String, dynamic>> createEventLog({
    required String source,
    String eventType = 'event',
    String? errorCode,
    String logLevel = 'info',
    Map<String, dynamic>? payload,
  });
}
