import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/datasources/remote/system_log_remote_datasource.dart';
import 'package:window_app/domain/repositories/system_log_repository.dart';

part 'system_log_repository_impl.g.dart';

/// SystemLog Repository 구현체
class SystemLogRepositoryImpl implements SystemLogRepository {
  final SystemLogRemoteDatasource _remoteDatasource;

  SystemLogRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<Map<String, dynamic>>> getSystemLogs({
    int page = 1,
    int limit = 20,
    String? responseStatus,
    String? logLevel,
  }) async {
    return await _remoteDatasource.getSystemLogs(
      page: page,
      limit: limit,
      responseStatus: responseStatus,
      logLevel: logLevel,
    );
  }

  @override
  Future<Map<String, dynamic>?> getSystemLog(String id) async {
    return await _remoteDatasource.getSystemLog(id);
  }

  @override
  Future<List<Map<String, dynamic>>> getUnrespondedLogs({int limit = 50}) async {
    return await _remoteDatasource.getUnrespondedLogs(limit: limit);
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingAlerts({int limit = 50}) async {
    return await _remoteDatasource.getPendingAlerts(limit: limit);
  }

  @override
  Future<Map<String, dynamic>> createSystemLog({
    required String source,
    String eventType = 'event',
    String? errorCode,
    String logLevel = 'info',
    Map<String, dynamic>? payload,
  }) async {
    return await _remoteDatasource.createSystemLog(
      source: source,
      eventType: eventType,
      errorCode: errorCode,
      logLevel: logLevel,
      payload: payload,
    );
  }
}

/// SystemLogRepository Provider
@riverpod
SystemLogRepository systemLogRepository(Ref ref) {
  final remoteDatasource = ref.watch(systemLogRemoteDatasourceProvider);
  return SystemLogRepositoryImpl(remoteDatasource);
}
