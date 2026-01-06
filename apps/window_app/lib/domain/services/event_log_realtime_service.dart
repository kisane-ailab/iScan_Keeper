import 'dart:async';

import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/data/models/enums/response_status.dart';
import 'package:window_app/data/models/event_log_model.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';
import 'package:window_app/infrastructure/system_tray/tray_manager.dart';

part 'event_log_realtime_service.g.dart';

@Riverpod(keepAlive: true)
class EventLogRealtimeService extends _$EventLogRealtimeService {
  RealtimeChannel? _channel;
  final _alertController = StreamController<EventLogModel>.broadcast();

  Logger get _logger => ref.read(appLoggerProvider);
  Stream<EventLogModel> get alertStream => _alertController.stream;

  @override
  List<EventLogModel> build() {
    _startListening();
    _fetchPendingAlerts();

    ref.onDispose(() {
      _channel?.unsubscribe();
      _alertController.close();
    });

    return [];
  }

  /// 기존 미확인/대응중 알림 로그 조회 (앱 시작 시)
  Future<void> _fetchPendingAlerts() async {
    try {
      final client = ref.read(supabaseClientProvider);

      // warning, error, critical 레벨의 미확인/대응중 로그 조회
      final response = await client
          .from('event_logs')
          .select()
          .inFilter('log_level', ['warning', 'error', 'critical'])
          .inFilter('response_status', ['unchecked', 'in_progress'])
          .order('created_at', ascending: false)
          .limit(50);

      _logger.i('미확인/대응중 알림 ${response.length}건 조회 완료');

      bool hasCriticalUnchecked = false;

      for (final record in response) {
        try {
          final log = EventLogModel.fromJson(record);
          state = [log, ...state];

          // 미확인 critical이 있는지 체크
          if (log.isCriticalUnchecked) {
            hasCriticalUnchecked = true;
          }
        } catch (e) {
          _logger.e('미확인 로그 파싱 오류', error: e);
        }
      }

      // 미확인 critical이 있으면 항상 위 모드 활성화
      if (hasCriticalUnchecked) {
        _logger.w('미확인 critical 로그 발견 - 항상 위 모드 활성화');
        await AppTrayManager.showWindowAlwaysOnTop();
      }
    } catch (e) {
      _logger.e('미확인 알림 조회 실패', error: e);
    }
  }

  void _startListening() {
    final client = ref.read(supabaseClientProvider);

    _channel = client
        .channel('event_logs_realtime')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'event_logs',
          callback: (payload) {
            _handleNewLog(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'event_logs',
          callback: (payload) {
            _handleUpdatedLog(payload.oldRecord, payload.newRecord);
          },
        )
        .subscribe();
  }

  void _handleNewLog(Map<String, dynamic> record) {
    try {
      final log = EventLogModel.fromJson(record);

      // 목록에 추가
      state = [log, ...state];

      // 알림이 필요한 레벨이고 미확인 상태면 알림 스트림에 추가
      if (log.logLevel.needsNotification &&
          log.responseStatus == ResponseStatus.unchecked) {
        _alertController.add(log);
      }
    } catch (e) {
      _logger.e('이벤트 로그 파싱 오류', error: e);
    }
  }

  void _handleUpdatedLog(
      Map<String, dynamic> oldRecord, Map<String, dynamic> newRecord) async {
    try {
      final newLog = EventLogModel.fromJson(newRecord);

      // 로컬 상태에서 이전 로그 찾기
      final localOldLog = state.firstWhere(
        (log) => log.id == newLog.id,
        orElse: () => newLog,
      );

      _logger.d('UPDATE 감지: ${newLog.id}');
      _logger.d('이전 상태: ${localOldLog.responseStatus.value}');
      _logger.d('새 상태: ${newLog.responseStatus.value}');

      // 목록에서 해당 로그 업데이트
      state = state.map((log) {
        if (log.id == newLog.id) {
          return newLog;
        }
        return log;
      }).toList();

      // 대응 포기로 인해 미확인으로 바뀐 경우 → 재알림
      if (localOldLog.responseStatus == ResponseStatus.inProgress &&
          newLog.responseStatus == ResponseStatus.unchecked) {
        _logger.w('대응 포기 감지: ${newLog.id} - 재알림');

        // critical이면 항상 위 모드 재활성화
        if (newLog.logLevel == LogLevel.critical) {
          _logger.w('Critical 재알림 - 항상 위 모드 활성화');
          await AppTrayManager.showWindowAlwaysOnTop();
        }

        _alertController.add(newLog);
      }
    } catch (e, st) {
      _logger.e('이벤트 로그 업데이트 파싱 오류', error: e, stackTrace: st);
    }
  }

  void clearLogs() {
    state = [];
  }

  /// 미확인 critical 로그가 있는지 확인
  bool get hasUncheckedCritical {
    return state.any((log) => log.isCriticalUnchecked);
  }
}

// 알림용 스트림 provider
@Riverpod(keepAlive: true)
Stream<EventLogModel> eventLogAlerts(Ref ref) {
  final service = ref.watch(eventLogRealtimeServiceProvider.notifier);
  return service.alertStream;
}
