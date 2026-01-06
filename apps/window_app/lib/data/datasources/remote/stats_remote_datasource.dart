import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';

part 'stats_remote_datasource.g.dart';

/// Stats Remote DataSource 인터페이스
abstract class StatsRemoteDatasource {
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

/// Stats Remote DataSource 구현체
class StatsRemoteDatasourceImpl implements StatsRemoteDatasource {
  final SupabaseClient _client;

  StatsRemoteDatasourceImpl(this._client);

  String _getDefaultFrom() {
    final date = DateTime.now().subtract(const Duration(days: 7));
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getDefaultTo() {
    final date = DateTime.now();
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Future<Map<String, dynamic>> getUserStats({
    required String userId,
    String? from,
    String? to,
  }) async {
    final fromDate = from ?? _getDefaultFrom();
    final toDate = to ?? _getDefaultTo();

    logger.d('사용자 통계 조회: userId=$userId, from=$fromDate, to=$toDate');

    // 사용자 정보
    final user = await _client
        .from('users')
        .select('id, name')
        .eq('id', userId)
        .single();

    // 대응 기록 조회
    final responses = await _client
        .from('response_logs')
        .select('started_at, completed_at')
        .eq('user_id', userId)
        .gte('started_at', '${fromDate}T00:00:00Z')
        .lte('started_at', '${toDate}T23:59:59Z');

    final totalResponses = responses.length;
    final completed = responses.where((r) => r['completed_at'] != null).length;
    final inProgress = totalResponses - completed;

    // 평균 대응 시간 계산
    final completedWithTime = responses.where((r) => r['completed_at'] != null).toList();
    int avgResponseTimeMs = 0;
    if (completedWithTime.isNotEmpty) {
      int totalMs = 0;
      for (final r in completedWithTime) {
        final start = DateTime.parse(r['started_at'] as String);
        final end = DateTime.parse(r['completed_at'] as String);
        totalMs += end.difference(start).inMilliseconds;
      }
      avgResponseTimeMs = totalMs ~/ completedWithTime.length;
    }

    return {
      'userId': user['id'],
      'userName': user['name'],
      'period': {'from': fromDate, 'to': toDate},
      'stats': {
        'totalResponses': totalResponses,
        'completed': completed,
        'inProgress': inProgress,
        'avgResponseTimeMs': avgResponseTimeMs,
      },
    };
  }

  @override
  Future<Map<String, dynamic>> getDailyStats({
    String? from,
    String? to,
  }) async {
    final fromDate = from ?? _getDefaultFrom();
    final toDate = to ?? _getDefaultTo();

    logger.d('일별 통계 조회: from=$fromDate, to=$toDate');

    final responses = await _client
        .from('response_logs')
        .select('started_at, completed_at')
        .gte('started_at', '${fromDate}T00:00:00Z')
        .lte('started_at', '${toDate}T23:59:59Z');

    // 날짜별 그룹화
    final dailyMap = <String, Map<String, int>>{};
    for (final r in responses) {
      final date = (r['started_at'] as String).split('T')[0];
      dailyMap[date] ??= {'total': 0, 'completed': 0};
      dailyMap[date]!['total'] = (dailyMap[date]!['total'] ?? 0) + 1;
      if (r['completed_at'] != null) {
        dailyMap[date]!['completed'] = (dailyMap[date]!['completed'] ?? 0) + 1;
      }
    }

    // 날짜 범위 내 모든 날짜 생성
    final daily = <Map<String, dynamic>>[];
    var currentDate = DateTime.parse(fromDate);
    final endDate = DateTime.parse(toDate);

    while (!currentDate.isAfter(endDate)) {
      final dateStr = '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';
      final stats = dailyMap[dateStr] ?? {'total': 0, 'completed': 0};
      daily.add({
        'date': dateStr,
        'total': stats['total'],
        'completed': stats['completed'],
      });
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return {
      'period': {'from': fromDate, 'to': toDate},
      'daily': daily,
    };
  }

  @override
  Future<Map<String, dynamic>> getOverviewStats() async {
    logger.d('전체 개요 통계 조회');

    // 이벤트 로그 통계
    final totalEvents = await _client
        .from('event_logs')
        .select('id')
        .count();

    final uncheckedEvents = await _client
        .from('event_logs')
        .select('id')
        .eq('response_status', 'unchecked')
        .count();

    final inProgressEvents = await _client
        .from('event_logs')
        .select('id')
        .eq('response_status', 'in_progress')
        .count();

    final completedEvents = await _client
        .from('event_logs')
        .select('id')
        .eq('response_status', 'completed')
        .count();

    // 사용자 통계
    final totalUsers = await _client
        .from('users')
        .select('id')
        .count();

    final availableUsers = await _client
        .from('users')
        .select('id')
        .eq('status', 'available')
        .count();

    final busyUsers = await _client
        .from('users')
        .select('id')
        .eq('status', 'busy')
        .count();

    return {
      'events': {
        'total': totalEvents.count,
        'unchecked': uncheckedEvents.count,
        'inProgress': inProgressEvents.count,
        'completed': completedEvents.count,
      },
      'users': {
        'total': totalUsers.count,
        'available': availableUsers.count,
        'busy': busyUsers.count,
      },
    };
  }

  @override
  Future<Map<String, dynamic>> getResponsesByUser({
    required String userId,
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    final offset = (page - 1) * limit;

    var query = _client
        .from('response_logs')
        .select('*, event_log:event_logs(*)')
        .eq('user_id', userId);

    if (status == 'in_progress') {
      query = query.isFilter('completed_at', null);
    } else if (status == 'completed') {
      query = query.not('completed_at', 'is', null);
    }

    final data = await query
        .order('started_at', ascending: false)
        .range(offset, offset + limit - 1);

    // count 조회
    var countQuery = _client
        .from('response_logs')
        .select('id')
        .eq('user_id', userId);

    if (status == 'in_progress') {
      countQuery = countQuery.isFilter('completed_at', null);
    } else if (status == 'completed') {
      countQuery = countQuery.not('completed_at', 'is', null);
    }

    final countResult = await countQuery.count();

    return {
      'data': data,
      'pagination': {
        'page': page,
        'limit': limit,
        'total': countResult.count,
        'totalPages': (countResult.count / limit).ceil(),
      },
    };
  }

  @override
  Future<Map<String, dynamic>> getResponsesByDate({
    int page = 1,
    int limit = 20,
    String? from,
    String? to,
    String? status,
    String? userId,
  }) async {
    final fromDate = from ?? _getDefaultFrom();
    final toDate = to ?? _getDefaultTo();
    final offset = (page - 1) * limit;

    var query = _client
        .from('response_logs')
        .select('*, event_log:event_logs(*), user:users(id, name, email)')
        .gte('started_at', '${fromDate}T00:00:00Z')
        .lte('started_at', '${toDate}T23:59:59Z');

    if (status == 'in_progress') {
      query = query.isFilter('completed_at', null);
    } else if (status == 'completed') {
      query = query.not('completed_at', 'is', null);
    }

    if (userId != null) {
      query = query.eq('user_id', userId);
    }

    final data = await query
        .order('started_at', ascending: false)
        .range(offset, offset + limit - 1);

    // count 조회
    var countQuery = _client
        .from('response_logs')
        .select('id')
        .gte('started_at', '${fromDate}T00:00:00Z')
        .lte('started_at', '${toDate}T23:59:59Z');

    if (status == 'in_progress') {
      countQuery = countQuery.isFilter('completed_at', null);
    } else if (status == 'completed') {
      countQuery = countQuery.not('completed_at', 'is', null);
    }

    if (userId != null) {
      countQuery = countQuery.eq('user_id', userId);
    }

    final countResult = await countQuery.count();

    return {
      'data': data,
      'pagination': {
        'page': page,
        'limit': limit,
        'total': countResult.count,
        'totalPages': (countResult.count / limit).ceil(),
      },
    };
  }
}

/// StatsRemoteDatasource Provider
@riverpod
StatsRemoteDatasource statsRemoteDatasource(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return StatsRemoteDatasourceImpl(client);
}
