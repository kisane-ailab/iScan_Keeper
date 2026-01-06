import 'package:window_app/data/models/event_log_model.dart';

/// Response Repository 인터페이스
abstract class ResponseRepository {
  /// 대응 시작 (담당 선언)
  Future<Map<String, dynamic>> startResponse({
    required EventLogModel log,
    required String userId,
    required String userName,
  });

  /// 대응 취소 (포기)
  Future<void> cancelResponse({
    required EventLogModel log,
    required String userId,
  });

  /// 대응 완료
  Future<void> completeResponse({
    required EventLogModel log,
    required String userId,
    String? memo,
  });

  /// 내 대응 기록 조회
  Future<List<Map<String, dynamic>>> getMyResponses(String userId);

  /// 대응 상세 조회
  Future<Map<String, dynamic>?> getResponse(String responseId);
}
