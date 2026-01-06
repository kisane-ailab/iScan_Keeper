import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/datasources/remote/response_remote_datasource.dart';
import 'package:window_app/data/models/event_log_model.dart';
import 'package:window_app/domain/repositories/response_repository.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';

part 'response_repository_impl.g.dart';

/// Response Repository 구현체
class ResponseRepositoryImpl implements ResponseRepository {
  final ResponseRemoteDatasource _remoteDatasource;

  ResponseRepositoryImpl(this._remoteDatasource);

  @override
  Future<Map<String, dynamic>> startResponse({
    required EventLogModel log,
    required String userId,
    required String userName,
  }) async {
    logger.d('Repository: 대응 시작 - eventLogId=${log.id}');

    // 이미 다른 사람이 대응 중인지 확인
    if (log.isBeingResponded && log.currentResponderId != userId) {
      throw Exception('이미 ${log.currentResponderName}님이 대응 중입니다');
    }

    return await _remoteDatasource.claim(
      eventLogId: log.id,
      userId: userId,
      userName: userName,
    );
  }

  @override
  Future<void> cancelResponse({
    required EventLogModel log,
    required String userId,
  }) async {
    logger.d('Repository: 대응 취소 - eventLogId=${log.id}');

    // 본인이 대응 중인 건만 취소 가능
    if (log.currentResponderId != userId) {
      throw Exception('본인이 대응 중인 건만 취소할 수 있습니다');
    }

    await _remoteDatasource.cancel(
      eventLogId: log.id,
      userId: userId,
    );
  }

  @override
  Future<void> completeResponse({
    required EventLogModel log,
    required String userId,
    String? memo,
  }) async {
    logger.d('Repository: 대응 완료 - eventLogId=${log.id}');

    await _remoteDatasource.complete(
      eventLogId: log.id,
      userId: userId,
      memo: memo,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getMyResponses(String userId) async {
    return await _remoteDatasource.getMyResponses(userId);
  }

  @override
  Future<Map<String, dynamic>?> getResponse(String responseId) async {
    return await _remoteDatasource.getResponse(responseId);
  }
}

/// ResponseRepository Provider
@riverpod
ResponseRepository responseRepository(Ref ref) {
  final remoteDatasource = ref.watch(responseRemoteDatasourceProvider);
  return ResponseRepositoryImpl(remoteDatasource);
}
