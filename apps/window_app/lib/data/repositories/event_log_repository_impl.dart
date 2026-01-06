import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/datasources/remote/event_log_remote_datasource.dart';
import 'package:window_app/domain/repositories/event_log_repository.dart';

part 'event_log_repository_impl.g.dart';

/// EventLog Repository 구현체
class EventLogRepositoryImpl implements EventLogRepository {
  final EventLogRemoteDatasource _remoteDatasource;

  EventLogRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<Map<String, dynamic>>> getEventLogs({
    int page = 1,
    int limit = 20,
    String? responseStatus,
    String? logLevel,
  }) async {
    return await _remoteDatasource.getEventLogs(
      page: page,
      limit: limit,
      responseStatus: responseStatus,
      logLevel: logLevel,
    );
  }

  @override
  Future<Map<String, dynamic>?> getEventLog(String id) async {
    return await _remoteDatasource.getEventLog(id);
  }

  @override
  Future<List<Map<String, dynamic>>> getUncheckedLogs({int limit = 50}) async {
    return await _remoteDatasource.getUncheckedLogs(limit: limit);
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingAlerts({int limit = 50}) async {
    return await _remoteDatasource.getPendingAlerts(limit: limit);
  }

  @override
  Future<Map<String, dynamic>> createEventLog({
    required String source,
    String eventType = 'event',
    String? errorCode,
    String logLevel = 'info',
    Map<String, dynamic>? payload,
  }) async {
    return await _remoteDatasource.createEventLog(
      source: source,
      eventType: eventType,
      errorCode: errorCode,
      logLevel: logLevel,
      payload: payload,
    );
  }
}

/// EventLogRepository Provider
@riverpod
EventLogRepository eventLogRepository(Ref ref) {
  final remoteDatasource = ref.watch(eventLogRemoteDatasourceProvider);
  return EventLogRepositoryImpl(remoteDatasource);
}
