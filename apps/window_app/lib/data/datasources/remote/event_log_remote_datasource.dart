import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';

part 'event_log_remote_datasource.g.dart';

/// EventLog Remote DataSource 인터페이스
abstract class EventLogRemoteDatasource {
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

/// EventLog Remote DataSource 구현체
class EventLogRemoteDatasourceImpl implements EventLogRemoteDatasource {
  final SupabaseClient _client;

  EventLogRemoteDatasourceImpl(this._client);

  @override
  Future<List<Map<String, dynamic>>> getEventLogs({
    int page = 1,
    int limit = 20,
    String? responseStatus,
    String? logLevel,
  }) async {
    final offset = (page - 1) * limit;

    var query = _client.from('event_logs').select();

    if (responseStatus != null) {
      query = query.eq('response_status', responseStatus);
    }

    if (logLevel != null) {
      query = query.eq('log_level', logLevel);
    }

    final result = await query
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return List<Map<String, dynamic>>.from(result);
  }

  @override
  Future<Map<String, dynamic>?> getEventLog(String id) async {
    return await _client
        .from('event_logs')
        .select()
        .eq('id', id)
        .maybeSingle();
  }

  @override
  Future<List<Map<String, dynamic>>> getUncheckedLogs({int limit = 50}) async {
    final result = await _client
        .from('event_logs')
        .select()
        .eq('response_status', 'unchecked')
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(result);
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingAlerts({int limit = 50}) async {
    logger.d('미확인/대응중 알림 조회');

    final result = await _client
        .from('event_logs')
        .select()
        .inFilter('log_level', ['warning', 'error', 'critical'])
        .inFilter('response_status', ['unchecked', 'in_progress'])
        .order('created_at', ascending: false)
        .limit(limit);

    logger.i('미확인/대응중 알림 ${result.length}건 조회 완료');
    return List<Map<String, dynamic>>.from(result);
  }

  @override
  Future<Map<String, dynamic>> createEventLog({
    required String source,
    String eventType = 'event',
    String? errorCode,
    String logLevel = 'info',
    Map<String, dynamic>? payload,
  }) async {
    logger.d('이벤트 로그 생성: source=$source, logLevel=$logLevel');

    final result = await _client.from('event_logs').insert({
      'source': source,
      'event_type': eventType,
      'error_code': errorCode,
      'log_level': logLevel,
      'payload': payload ?? {},
      'response_status': 'unchecked',
    }).select().single();

    logger.i('이벤트 로그 생성 완료: ${result['id']}');
    return result;
  }
}

/// EventLogRemoteDatasource Provider
@riverpod
EventLogRemoteDatasource eventLogRemoteDatasource(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return EventLogRemoteDatasourceImpl(client);
}
