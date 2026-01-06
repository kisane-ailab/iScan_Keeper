/// User Repository 인터페이스
abstract class UserRepository {
  /// 사용자 목록 조회
  Future<List<Map<String, dynamic>>> getUsers({String? status});

  /// 사용자 상세 조회
  Future<Map<String, dynamic>?> getUser(String userId);

  /// 대기중인 사용자 목록
  Future<List<Map<String, dynamic>>> getAvailableUsers();

  /// 사용자 상태 변경
  Future<Map<String, dynamic>> updateStatus({
    required String userId,
    required String status,
  });

  /// 사용자 생성
  Future<Map<String, dynamic>> createUser({
    required String id,
    required String name,
    required String email,
  });
}
