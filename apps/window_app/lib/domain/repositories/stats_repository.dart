/// Stats Repository 인터페이스
abstract class StatsRepository {
  /// 사용자별 통계
  Future<Map<String, dynamic>> getUserStats({
    required String userId,
    String? from,
    String? to,
  });

  /// 일별 통계
  Future<Map<String, dynamic>> getDailyStats({
    String? from,
    String? to,
  });

  /// 전체 개요 통계
  Future<Map<String, dynamic>> getOverviewStats();

  /// 사용자별 대응 목록 (페이지네이션)
  Future<Map<String, dynamic>> getResponsesByUser({
    required String userId,
    int page = 1,
    int limit = 20,
    String? status,
  });

  /// 날짜별 대응 목록 (페이지네이션)
  Future<Map<String, dynamic>> getResponsesByDate({
    int page = 1,
    int limit = 20,
    String? from,
    String? to,
    String? status,
    String? userId,
  });
}
