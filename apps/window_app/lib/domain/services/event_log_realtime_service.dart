import 'dart:async';

import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_app/data/models/event_log_model.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';

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

  /// 기존 미확인 에러 로그 조회 (앱 시작 시)
  Future<void> _fetchPendingAlerts() async {
    try {
      final client = ref.read(supabaseClientProvider);

      final response = await client
          .from('event_logs')
          .select()
          .eq('log_level', 'error')
          .eq('response_status', 'unchecked')
          .order('created_at', ascending: false)
          .limit(10);

      _logger.i('미확인 알림 ${response.length}건 조회 완료');

      for (final record in response) {
        try {
          final log = EventLogModel.fromJson(record);
          state = [log, ...state];
        } catch (e) {
          _logger.e('미확인 로그 파싱 오류', error: e);
        }
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
        .subscribe();
  }

  void _handleNewLog(Map<String, dynamic> record) {
    try {
      final log = EventLogModel.fromJson(record);

      // 목록에 추가
      state = [log, ...state];

      // log_level이 error이고 unchecked면 알림
      if (log.logLevel == 'error' && log.responseStatus == 'unchecked') {
        _alertController.add(log);
      }
    } catch (e) {
      _logger.e('이벤트 로그 파싱 오류', error: e);
    }
  }

  void clearLogs() {
    state = [];
  }
}

// 알림용 스트림 provider
@Riverpod(keepAlive: true)
Stream<EventLogModel> eventLogAlerts(Ref ref) {
  final service = ref.watch(eventLogRealtimeServiceProvider.notifier);
  return service.alertStream;
}
