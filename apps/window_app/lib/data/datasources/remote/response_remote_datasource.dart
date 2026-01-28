import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';

part 'response_remote_datasource.g.dart';

/// Response Remote DataSource 인터페이스
abstract class ResponseRemoteDatasource {
  /// 대응 시작 (담당 선언)
  Future<Map<String, dynamic>> claim({
    required String eventLogId,
    required String userId,
    required String userName,
  });

  /// 대응 할당 (관리자가 특정 유저에게 배정)
  Future<Map<String, dynamic>> assign({
    required String eventLogId,
    required String assigneeId,
    required String assigneeName,
    required String assignerId,
    required String assignerName,
  });

  /// 대응 취소 (포기)
  Future<void> cancel({
    required String eventLogId,
    required String userId,
  });

  /// 대응 완료
  Future<void> complete({
    required String eventLogId,
    required String userId,
    String? memo,
  });

  /// 대응 완료 (향상된 콘텐츠 지원)
  Future<void> completeWithContent({
    required String eventLogId,
    required String userId,
    String? memo,
    Map<String, dynamic>? content,
    List<Map<String, dynamic>>? attachments,
  });

  /// 내 대응 기록 조회
  Future<List<Map<String, dynamic>>> getMyResponses(String userId);

  /// 대응 상세 조회
  Future<Map<String, dynamic>?> getResponse(String responseId);
}

/// Response Remote DataSource 구현체 (Supabase 직접 호출)
class ResponseRemoteDatasourceImpl implements ResponseRemoteDatasource {
  final SupabaseClient _client;

  ResponseRemoteDatasourceImpl(this._client);

  @override
  Future<Map<String, dynamic>> claim({
    required String eventLogId,
    required String userId,
    required String userName,
  }) async {
    logger.d('대응 시작 요청: eventLogId=$eventLogId, userId=$userId');

    // 이미 대응 중인지 확인
    final existingLog = await _client
        .from('system_logs')
        .select('response_status, current_responder_id')
        .eq('id', eventLogId)
        .single();

    if (existingLog['response_status'] == 'in_progress') {
      throw Exception('이미 다른 사람이 대응 중입니다');
    }

    if (existingLog['response_status'] == 'completed') {
      throw Exception('이미 완료된 로그입니다');
    }

    // response_logs 생성
    final responseLog = await _client.from('response_logs').insert({
      'system_log_id': eventLogId,
      'user_id': userId,
      'started_at': DateTime.now().toIso8601String(),
    }).select().single();

    // system_logs 업데이트
    await _client.from('system_logs').update({
      'response_status': 'in_progress',
      'current_responder_id': userId,
      'current_responder_name': userName,
      'response_started_at': DateTime.now().toIso8601String(),
    }).eq('id', eventLogId);

    logger.i('대응 시작 완료: ${responseLog['id']}');
    return responseLog;
  }

  @override
  Future<Map<String, dynamic>> assign({
    required String eventLogId,
    required String assigneeId,
    required String assigneeName,
    required String assignerId,
    required String assignerName,
  }) async {
    logger.d('대응 할당 요청: eventLogId=$eventLogId, assigneeId=$assigneeId, assignerId=$assignerId');

    // 이미 대응 중인지 확인
    final existingLog = await _client
        .from('system_logs')
        .select('response_status, current_responder_id')
        .eq('id', eventLogId)
        .single();

    if (existingLog['response_status'] == 'completed') {
      throw Exception('이미 완료된 로그입니다');
    }

    // 기존 대응 중인 경우, 기존 response_log 삭제
    if (existingLog['response_status'] == 'in_progress') {
      await _client
          .from('response_logs')
          .delete()
          .eq('system_log_id', eventLogId)
          .isFilter('completed_at', null);
    }

    // response_logs 생성 (할당자 정보 포함)
    final responseLog = await _client.from('response_logs').insert({
      'system_log_id': eventLogId,
      'user_id': assigneeId,
      'started_at': DateTime.now().toIso8601String(),
    }).select().single();

    // system_logs 업데이트 (할당자 정보 포함)
    await _client.from('system_logs').update({
      'response_status': 'in_progress',
      'current_responder_id': assigneeId,
      'current_responder_name': assigneeName,
      'response_started_at': DateTime.now().toIso8601String(),
      'assigned_by_id': assignerId,
      'assigned_by_name': assignerName,
    }).eq('id', eventLogId);

    logger.i('대응 할당 완료: ${responseLog['id']} → $assigneeName (할당자: $assignerName)');
    return responseLog;
  }

  @override
  Future<void> cancel({
    required String eventLogId,
    required String userId,
  }) async {
    logger.d('대응 취소 요청: eventLogId=$eventLogId, userId=$userId');

    // response_logs 삭제 (완료되지 않은 것만)
    await _client
        .from('response_logs')
        .delete()
        .eq('system_log_id', eventLogId)
        .eq('user_id', userId)
        .isFilter('completed_at', null);

    // system_logs 미대응으로 되돌림
    await _client.from('system_logs').update({
      'response_status': 'unresponded',
      'current_responder_id': null,
      'current_responder_name': null,
      'response_started_at': null,
    }).eq('id', eventLogId);

    logger.i('대응 취소 완료: $eventLogId');
  }

  @override
  Future<void> complete({
    required String eventLogId,
    required String userId,
    String? memo,
  }) async {
    logger.d('대응 완료 요청: eventLogId=$eventLogId');

    // response_logs 완료 처리
    await _client
        .from('response_logs')
        .update({
          'completed_at': DateTime.now().toIso8601String(),
          'memo': memo,
        })
        .eq('system_log_id', eventLogId)
        .eq('user_id', userId)
        .isFilter('completed_at', null);

    // system_logs 완료 처리
    await _client.from('system_logs').update({
      'response_status': 'completed',
    }).eq('id', eventLogId);

    logger.i('대응 완료: $eventLogId');
  }

  @override
  Future<void> completeWithContent({
    required String eventLogId,
    required String userId,
    String? memo,
    Map<String, dynamic>? content,
    List<Map<String, dynamic>>? attachments,
  }) async {
    logger.d('대응 완료 요청 (콘텐츠 포함): eventLogId=$eventLogId');

    final updateData = <String, dynamic>{
      'completed_at': DateTime.now().toIso8601String(),
    };

    // 기존 memo 필드도 유지 (하위 호환성)
    if (memo != null) {
      updateData['memo'] = memo;
    } else if (content != null && content['markdown'] != null) {
      updateData['memo'] = content['markdown'];
    }

    // 새 content, attachments 필드
    if (content != null) {
      updateData['content'] = content;
    }
    if (attachments != null) {
      updateData['attachments'] = attachments;
    }

    // response_logs 완료 처리
    await _client
        .from('response_logs')
        .update(updateData)
        .eq('system_log_id', eventLogId)
        .eq('user_id', userId)
        .isFilter('completed_at', null);

    // system_logs 완료 처리
    await _client.from('system_logs').update({
      'response_status': 'completed',
    }).eq('id', eventLogId);

    logger.i('대응 완료 (콘텐츠 포함): $eventLogId');
  }

  @override
  Future<List<Map<String, dynamic>>> getMyResponses(String userId) async {
    final result = await _client
        .from('response_logs')
        .select('*, system_log:system_logs(*)')
        .eq('user_id', userId)
        .order('started_at', ascending: false)
        .limit(50);

    return List<Map<String, dynamic>>.from(result);
  }

  @override
  Future<Map<String, dynamic>?> getResponse(String responseId) async {
    return await _client
        .from('response_logs')
        .select('*, system_log:system_logs(*), user:users(id, name, email)')
        .eq('id', responseId)
        .maybeSingle();
  }
}

/// ResponseRemoteDatasource Provider
@riverpod
ResponseRemoteDatasource responseRemoteDatasource(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return ResponseRemoteDatasourceImpl(client);
}
