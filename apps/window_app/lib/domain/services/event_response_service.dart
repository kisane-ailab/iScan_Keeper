import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/data/models/enums/response_status.dart';
import 'package:window_app/data/models/event_log_model.dart';
import 'package:window_app/domain/services/auth_service.dart';
import 'package:window_app/domain/services/event_log_realtime_service.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';
import 'package:window_app/infrastructure/system_tray/tray_manager.dart';

part 'event_response_service.g.dart';

@Riverpod(keepAlive: true)
class EventResponseService extends _$EventResponseService {
  @override
  List<String> build() {
    // 현재 내가 대응 중인 이벤트 ID 목록
    return [];
  }

  /// 현재 사용자 정보 가져오기
  Future<Map<String, dynamic>?> _getCurrentUserInfo() async {
    final authState = ref.read(authServiceProvider);
    final userId = authState.user?.id;
    if (userId == null) return null;

    final client = ref.read(supabaseClientProvider);
    final result = await client
        .from('users')
        .select('id, name, email')
        .eq('id', userId)
        .maybeSingle();

    return result;
  }

  /// 대응 시작
  Future<bool> startResponse(EventLogModel log) async {
    try {
      final client = ref.read(supabaseClientProvider);
      final userInfo = await _getCurrentUserInfo();

      if (userInfo == null) {
        logger.e('대응 시작 실패: 로그인 필요');
        return false;
      }

      final userId = userInfo['id'] as String;
      final userName = userInfo['name'] as String;

      // 이미 다른 사람이 대응 중인지 확인
      if (log.isBeingResponded && log.currentResponderId != userId) {
        logger.w('이미 ${log.currentResponderName}님이 대응 중입니다');
        return false;
      }

      // 트랜잭션으로 처리
      // 1. response_logs에 기록 추가
      await client.from('response_logs').insert({
        'event_log_id': log.id,
        'user_id': userId,
        'started_at': DateTime.now().toIso8601String(),
      });

      // 2. event_logs 업데이트
      await client.from('event_logs').update({
        'response_status': ResponseStatus.inProgress.value,
        'current_responder_id': userId,
        'current_responder_name': userName,
        'response_started_at': DateTime.now().toIso8601String(),
      }).eq('id', log.id);

      // 내 대응 목록에 추가
      state = [...state, log.id];

      // 다른 미확인 critical이 없으면 항상 위 모드 해제
      if (AppTrayManager.isAlwaysOnTop) {
        final logs = ref.read(eventLogRealtimeServiceProvider);
        final otherUncheckedCritical = logs.any((l) =>
            l.id != log.id &&
            l.logLevel == LogLevel.critical &&
            l.responseStatus == ResponseStatus.unchecked);

        if (!otherUncheckedCritical) {
          await AppTrayManager.releaseAlwaysOnTop();
          logger.i('모든 critical 대응 완료 - 항상 위 모드 해제');
        } else {
          logger.i('아직 미확인 critical 있음 - 항상 위 모드 유지');
        }
      }

      logger.i('대응 시작: ${log.id}');
      return true;
    } catch (e) {
      logger.e('대응 시작 실패', error: e);
      return false;
    }
  }

  /// 대응 포기 (미확인으로 되돌림)
  Future<bool> abandonResponse(EventLogModel log) async {
    try {
      final client = ref.read(supabaseClientProvider);
      final userInfo = await _getCurrentUserInfo();

      if (userInfo == null) return false;

      final userId = userInfo['id'] as String;

      // 내가 대응 중인 건만 포기 가능
      if (log.currentResponderId != userId) {
        logger.w('본인이 대응 중인 건만 포기할 수 있습니다');
        return false;
      }

      // 1. response_logs에서 삭제 (완료되지 않은 것)
      await client
          .from('response_logs')
          .delete()
          .eq('event_log_id', log.id)
          .eq('user_id', userId)
          .isFilter('completed_at', null);

      // 2. event_logs를 미확인으로 되돌림
      await client.from('event_logs').update({
        'response_status': ResponseStatus.unchecked.value,
        'current_responder_id': null,
        'current_responder_name': null,
        'response_started_at': null,
      }).eq('id', log.id);

      // 내 대응 목록에서 제거
      state = state.where((id) => id != log.id).toList();

      logger.i('대응 포기: ${log.id}');
      return true;
    } catch (e) {
      logger.e('대응 포기 실패', error: e);
      return false;
    }
  }

  /// 대응 완료
  Future<bool> completeResponse(EventLogModel log, String memo) async {
    try {
      final client = ref.read(supabaseClientProvider);
      final userInfo = await _getCurrentUserInfo();

      if (userInfo == null) return false;

      final userId = userInfo['id'] as String;

      // 1. response_logs 업데이트
      await client
          .from('response_logs')
          .update({
            'completed_at': DateTime.now().toIso8601String(),
            'memo': memo,
          })
          .eq('event_log_id', log.id)
          .eq('user_id', userId)
          .isFilter('completed_at', null);

      // 2. event_logs 완료 처리
      await client.from('event_logs').update({
        'response_status': ResponseStatus.completed.value,
      }).eq('id', log.id);

      // 내 대응 목록에서 제거
      state = state.where((id) => id != log.id).toList();

      logger.i('대응 완료: ${log.id}');
      return true;
    } catch (e) {
      logger.e('대응 완료 실패', error: e);
      return false;
    }
  }

  /// 현재 내가 대응 중인지 확인
  bool isMyResponse(String eventLogId) {
    return state.contains(eventLogId);
  }
}
