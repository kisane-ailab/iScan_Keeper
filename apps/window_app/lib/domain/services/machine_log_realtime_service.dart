import 'dart:async';

import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_app/data/models/machine_log_model.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';

part 'machine_log_realtime_service.g.dart';

@Riverpod(keepAlive: true)
class MachineLogRealtimeService extends _$MachineLogRealtimeService {
  RealtimeChannel? _channel;
  final _alertController = StreamController<MachineLogModel>.broadcast();

  Logger get _logger => ref.read(appLoggerProvider);
  Stream<MachineLogModel> get alertStream => _alertController.stream;

  @override
  List<MachineLogModel> build() {
    _startListening();
    _fetchPendingAlerts();

    ref.onDispose(() {
      _channel?.unsubscribe();
      _alertController.close();
    });

    return [];
  }

  /// 기존 미확인 에러 로그 조회 (앱 시작 시)
  /// 알림 센터에만 표시, Windows 알림은 뜨지 않음
  Future<void> _fetchPendingAlerts() async {
    try {
      final client = ref.read(supabaseClientProvider);

      final response = await client
          .from('machine_logs')
          .select()
          .eq('status_code', 500)
          .eq('response_status', 'unchecked')
          .order('created_at', ascending: false)
          .limit(10);

      _logger.i('미확인 알림 ${response.length}건 조회 완료');

      for (final record in response) {
        try {
          final log = MachineLogModel.fromJson(record);
          // 목록에만 추가 (Windows 알림 X)
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
        .channel('machine_logs_realtime')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'machine_logs',
          callback: (payload) {
            _handleNewLog(payload.newRecord);
          },
        )
        .subscribe();
  }

  void _handleNewLog(Map<String, dynamic> record) {
    try {
      final log = MachineLogModel.fromJson(record);

      // 목록에 추가
      state = [log, ...state];

      // status_code가 500이고 unchecked면 알림
      if (log.statusCode == 500 && log.responseStatus == 'unchecked') {
        _alertController.add(log);
      }
    } catch (e) {
      _logger.e('머신 로그 파싱 오류', error: e);
    }
  }

  void clearLogs() {
    state = [];
  }
}

// 알림용 스트림 provider
@Riverpod(keepAlive: true)
Stream<MachineLogModel> machineLogAlerts(Ref ref) {
  final service = ref.watch(machineLogRealtimeServiceProvider.notifier);
  return service.alertStream;
}
