/// SystemLog Repository 인터페이스
abstract class SystemLogRepository {
  /// 시스템 로그 목록 조회 (페이지네이션)
  Future<List<Map<String, dynamic>>> getSystemLogs({
    int page = 1,
    int limit = 20,
    String? responseStatus,
    String? logLevel,
  });

  /// 시스템 로그 상세 조회
  Future<Map<String, dynamic>?> getSystemLog(String id);

  /// 미대응 로그 조회
  Future<List<Map<String, dynamic>>> getUnrespondedLogs({int limit = 50});

  /// 미대응/대응중 알림 로그 조회 (warning, error, critical)
  Future<List<Map<String, dynamic>>> getPendingAlerts({int limit = 50});

  /// 시스템 로그 생성 (테스트용)
  Future<Map<String, dynamic>> createSystemLog({
    required String source,
    String category = 'event',
    String? code,
    String logLevel = 'info',
    Map<String, dynamic>? payload,
  });

  /// 시스템 로그 알림 무시 설정/해제
  Future<Map<String, dynamic>> setLogMuted(String id, bool muted);
}
