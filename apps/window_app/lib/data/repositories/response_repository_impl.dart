import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/datasources/remote/response_remote_datasource.dart';
import 'package:window_app/domain/repositories/response_repository.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';

part 'response_repository_impl.g.dart';

/// Response Repository 구현체
class ResponseRepositoryImpl implements ResponseRepository {
  final ResponseRemoteDatasource _remoteDatasource;

  ResponseRepositoryImpl(this._remoteDatasource);

  @override
  Future<Map<String, dynamic>> startResponse({
    required String eventLogId,
    required String userId,
    required String userName,
  }) async {
    logger.d('Repository: 대응 시작 - eventLogId=$eventLogId');

    return await _remoteDatasource.claim(
      eventLogId: eventLogId,
      userId: userId,
      userName: userName,
    );
  }

  @override
  Future<Map<String, dynamic>> assignResponse({
    required String eventLogId,
    required String assigneeId,
    required String assigneeName,
    required String assignerId,
    required String assignerName,
  }) async {
    logger.d('Repository: 대응 할당 - eventLogId=$eventLogId, assigneeId=$assigneeId');

    return await _remoteDatasource.assign(
      eventLogId: eventLogId,
      assigneeId: assigneeId,
      assigneeName: assigneeName,
      assignerId: assignerId,
      assignerName: assignerName,
    );
  }

  @override
  Future<void> cancelResponse({
    required String eventLogId,
    required String userId,
  }) async {
    logger.d('Repository: 대응 취소 - eventLogId=$eventLogId');

    await _remoteDatasource.cancel(
      eventLogId: eventLogId,
      userId: userId,
    );
  }

  @override
  Future<void> completeResponse({
    required String eventLogId,
    required String userId,
    String? memo,
  }) async {
    logger.d('Repository: 대응 완료 - eventLogId=$eventLogId');

    await _remoteDatasource.complete(
      eventLogId: eventLogId,
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
