import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';

part 'system_log_remote_datasource.g.dart';

/// SystemLog Remote DataSource 인터페이스
abstract class SystemLogRemoteDatasource {
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

  /// 숨긴(muted) 로그 목록 조회
  Future<List<Map<String, dynamic>>> getMutedLogs({int limit = 100});
}

/// SystemLog Remote DataSource 구현체
class SystemLogRemoteDatasourceImpl implements SystemLogRemoteDatasource {
  final SupabaseClient _client;

  SystemLogRemoteDatasourceImpl(this._client);

  @override
  Future<List<Map<String, dynamic>>> getSystemLogs({
    int page = 1,
    int limit = 20,
    String? responseStatus,
    String? logLevel,
  }) async {
    final offset = (page - 1) * limit;

    var query = _client.from('system_logs').select();

    // muted 로그 제외 (is_muted가 null이거나 false인 것만)
    query = query.or('is_muted.is.null,is_muted.eq.false');

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
  Future<Map<String, dynamic>?> getSystemLog(String id) async {
    return await _client
        .from('system_logs')
        .select()
        .eq('id', id)
        .maybeSingle();
  }

  @override
  Future<List<Map<String, dynamic>>> getUnrespondedLogs({int limit = 50}) async {
    final result = await _client
        .from('system_logs')
        .select()
        .eq('response_status', 'unresponded')
        .or('is_muted.is.null,is_muted.eq.false')
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(result);
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingAlerts({int limit = 50}) async {
    logger.d('미대응/대응중 알림 조회');

    final result = await _client
        .from('system_logs')
        .select()
        .inFilter('log_level', ['warning', 'error', 'critical'])
        .inFilter('response_status', ['unresponded', 'in_progress'])
        .or('is_muted.is.null,is_muted.eq.false')
        .order('created_at', ascending: false)
        .limit(limit);

    logger.i('미대응/대응중 알림 ${result.length}건 조회 완료');
    return List<Map<String, dynamic>>.from(result);
  }

  @override
  Future<Map<String, dynamic>> createSystemLog({
    required String source,
    String category = 'event',
    String? code,
    String logLevel = 'info',
    Map<String, dynamic>? payload,
  }) async {
    logger.d('시스템 로그 생성: source=$source, logLevel=$logLevel');

    final result = await _client.from('system_logs').insert({
      'source': source,
      'category': category,
      'code': code,
      'log_level': logLevel,
      'payload': payload ?? {},
      'response_status': 'unresponded',
    }).select().single();

    logger.i('시스템 로그 생성 완료: ${result['id']}');
    return result;
  }

  @override
  Future<Map<String, dynamic>> setLogMuted(String id, bool muted) async {
    logger.d('시스템 로그 mute 설정: id=$id, muted=$muted');

    final result = await _client
        .from('system_logs')
        .update({'is_muted': muted ? true : null})
        .eq('id', id)
        .select('id, source, code, is_muted')
        .single();

    logger.i('시스템 로그 mute 설정 완료: ${result['id']}, is_muted=${result['is_muted']}');
    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> getMutedLogs({int limit = 100}) async {
    logger.d('숨긴 로그 목록 조회');

    final result = await _client
        .from('system_logs')
        .select()
        .eq('is_muted', true)
        .order('created_at', ascending: false)
        .limit(limit);

    logger.i('숨긴 로그 ${result.length}건 조회 완료');
    return List<Map<String, dynamic>>.from(result);
  }
}

/// SystemLogRemoteDatasource Provider
@riverpod
SystemLogRemoteDatasource systemLogRemoteDatasource(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return SystemLogRemoteDatasourceImpl(client);
}
