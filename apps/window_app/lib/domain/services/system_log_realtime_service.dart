import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_app/data/models/notification_settings.dart';
import 'package:window_app/data/models/system_log_model.dart';
import 'package:window_app/data/repositories/system_log_repository_impl.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/domain/services/auth_service.dart';
import 'package:window_app/domain/services/notification_settings_service.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/notification/notification_handler.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';
import 'package:window_app/infrastructure/system_tray/tray_manager.dart';

part 'system_log_realtime_service.g.dart';

@Riverpod(keepAlive: true)
class SystemLogRealtimeService extends _$SystemLogRealtimeService {
  RealtimeChannel? _channel;
  final _alertController = StreamController<SystemLogEntity>.broadcast();

  Logger get _logger => ref.read(appLoggerProvider);
  Stream<SystemLogEntity> get alertStream => _alertController.stream;

  /// 현재 알림 설정 가져오기
  NotificationSettings get _settings => ref.read(notificationSettingsServiceProvider);

  @override
  List<SystemLogEntity> build() {
    _startListening();
    _fetchInitialLogs();

    ref.onDispose(() {
      _channel?.unsubscribe();
      _alertController.close();
    });

    return [];
  }

  /// Model → Entity 변환
  SystemLogEntity _toEntity(SystemLogModel model) {
    return SystemLogEntity.fromModel(model);
  }

  /// 해당 로그가 항상위 모드를 필요로 하는지 확인 (설정 기반)
  bool _needsAlwaysOnTop(SystemLogEntity entity) {
    if (!entity.isUnchecked) return false;
    final action = _settings.getActionForLevel(entity.logLevel, environment: entity.environment);
    return action == NotificationAction.alwaysOnTop;
  }

  /// 기존 로그 조회 (앱 시작 시) - 모든 레벨
  Future<void> _fetchInitialLogs() async {
    try {
      final systemLogRepository = ref.read(systemLogRepositoryProvider);

      // 모든 레벨의 로그 조회 (최근 100개)
      final response = await systemLogRepository.getSystemLogs(limit: 100);

      _logger.i('기존 로그 ${response.length}건 조회 완료');

      bool hasAlwaysOnTopNeeded = false;

      for (final record in response) {
        try {
          final model = SystemLogModel.fromJson(record);
          final entity = _toEntity(model);
          state = [...state, entity];

          // 항상위 모드가 필요한 미대응 로그가 있는지 체크
          if (_needsAlwaysOnTop(entity)) {
            hasAlwaysOnTopNeeded = true;
          }
        } catch (e) {
          _logger.e('로그 파싱 오류', error: e);
        }
      }

      // 항상위 모드가 필요한 미대응 로그가 있으면 활성화
      if (hasAlwaysOnTopNeeded) {
        _logger.w('항상위 모드 필요한 미대응 로그 발견 - 항상 위 모드 활성화');
        await AppTrayManager.showWindowAlwaysOnTop();
        ref.read(alwaysOnTopStateProvider.notifier).setAlwaysOnTop(true);
      }
    } catch (e) {
      _logger.e('로그 조회 실패', error: e);
    }
  }

  void _startListening() {
    final client = ref.read(supabaseClientProvider);

    _channel = client
        .channel('system_logs_realtime')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'system_logs',
          callback: (payload) {
            _handleNewLog(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'system_logs',
          callback: (payload) {
            _handleUpdatedLog(payload.oldRecord, payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'system_logs',
          callback: (payload) {
            _handleDeletedLog(payload.oldRecord);
          },
        )
        .subscribe();
  }

  void _handleNewLog(Map<String, dynamic> record) async {
    try {
      final model = SystemLogModel.fromJson(record);
      final entity = _toEntity(model);

      // 목록에 추가
      state = [entity, ...state];

      // 알림이 필요한 레벨이고 미대응 상태면 알림 스트림에 추가
      if (entity.needsNotification) {
        _alertController.add(entity);
      }

      // 설정에 따라 항상위모드 활성화
      if (_needsAlwaysOnTop(entity)) {
        _logger.w('새 로그 (${entity.logLevel.label}) - 설정에 따라 항상위모드 활성화');
        await AppTrayManager.showWindowAlwaysOnTop();
        ref.read(alwaysOnTopStateProvider.notifier).setAlwaysOnTop(true);
      }
    } catch (e) {
      _logger.e('시스템 로그 파싱 오류', error: e);
    }
  }

  void _handleUpdatedLog(
      Map<String, dynamic> oldRecord, Map<String, dynamic> newRecord) async {
    _logger.i('=== UPDATE 이벤트 수신 ===');
    _logger.d('newRecord: $newRecord');

    try {
      final newModel = SystemLogModel.fromJson(newRecord);
      _logger.d('Model 파싱 성공: ${newModel.id}');

      final newEntity = _toEntity(newModel);
      _logger.d('Entity 변환 성공: responseStatus=${newEntity.responseStatus.value}');

      // 로컬 상태에서 이전 로그 찾기
      final localOldEntity = state.firstWhere(
        (log) => log.id == newEntity.id,
        orElse: () => newEntity,
      );

      _logger.i('UPDATE 감지: ${newEntity.id}');
      _logger.i('이전 상태: ${localOldEntity.responseStatus.value}');
      _logger.i('새 상태: ${newEntity.responseStatus.value}');
      _logger.i('현재 state 개수: ${state.length}');

      // 목록에서 해당 로그 업데이트
      final newState = state.map((log) {
        if (log.id == newEntity.id) {
          return newEntity;
        }
        return log;
      }).toList();

      _logger.i('새 state 개수: ${newState.length}');
      state = newState;

      // 대응 시작 감지 (unchecked → in_progress)
      if (localOldEntity.isUnchecked && newEntity.isBeingResponded) {
        _logger.i('대응 시작 감지: ${newEntity.id} by ${newEntity.currentResponderName}');

        // 할당인 경우 (assigned_by_id가 있음)
        if (newEntity.isAssigned && newEntity.assignedByName != null) {
          final currentUserId = ref.read(authServiceProvider).user?.id;

          // 내가 할당받은 경우에만 알림 표시
          if (newEntity.currentResponderId == currentUserId) {
            _logger.i('나에게 할당됨: ${newEntity.assignedByName} → 나');
            await NotificationHandler.showAssigned(
              entity: newEntity,
              assignedByName: newEntity.assignedByName!,
            );
            // 앱 내 스낵바 표시
            rootScaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text(
                  '${newEntity.assignedByName}님이 [${newEntity.source}] 이슈를 할당했습니다',
                ),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: '확인',
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            );
          } else {
            // 다른 사람에게 할당된 경우
            _logger.i('다른 사람에게 할당됨: ${newEntity.assignedByName} → ${newEntity.currentResponderName}');
            await NotificationHandler.showResponseStarted(newEntity);
          }
        } else {
          // 자원인 경우
          await NotificationHandler.showResponseStarted(newEntity);
        }

        // 항상위 모드가 필요한 미대응 로그가 더 이상 없으면 해제
        await checkAndReleaseAlwaysOnTop();
      }

      // 대응 포기로 인해 미대응으로 바뀐 경우 → 재알림
      if (localOldEntity.isBeingResponded && newEntity.isUnchecked) {
        // 이전 담당자 이름 (포기한 사람)
        final abandonedByName = localOldEntity.currentResponderName ?? '알 수 없음';
        _logger.w('대응 포기 감지: ${newEntity.id} by $abandonedByName - 재알림');

        // 포기 알림 표시
        await NotificationHandler.showResponseAbandoned(
          entity: newEntity,
          abandonedByName: abandonedByName,
        );

        // 설정에 따라 항상 위 모드 재활성화
        if (_needsAlwaysOnTop(newEntity)) {
          _logger.w('${newEntity.logLevel.label} 재알림 - 설정에 따라 항상 위 모드 활성화');
          await AppTrayManager.showWindowAlwaysOnTop();
          ref.read(alwaysOnTopStateProvider.notifier).setAlwaysOnTop(true);
        }

        _alertController.add(newEntity);
      }
    } catch (e, st) {
      _logger.e('시스템 로그 업데이트 파싱 오류', error: e, stackTrace: st);
    }
  }

  void _handleDeletedLog(Map<String, dynamic> oldRecord) async {
    _logger.i('=== DELETE 이벤트 수신 ===');
    _logger.d('oldRecord: $oldRecord');

    try {
      final deletedId = oldRecord['id'] as String?;
      if (deletedId == null) {
        _logger.w('삭제된 로그 ID를 찾을 수 없음');
        return;
      }

      // 삭제된 로그가 항상위 모드가 필요했는지 체크
      final deletedEntity = state.firstWhere(
        (log) => log.id == deletedId,
        orElse: () => state.first,
      );
      final wasAlwaysOnTopNeeded = _needsAlwaysOnTop(deletedEntity);

      // 목록에서 해당 로그 제거
      final newState = state.where((log) => log.id != deletedId).toList();
      _logger.i('DELETE 처리: $deletedId (이전: ${state.length}개 → 현재: ${newState.length}개)');
      state = newState;

      // 삭제된 로그가 항상위 모드가 필요했다면 재평가
      if (wasAlwaysOnTopNeeded) {
        await checkAndReleaseAlwaysOnTop();
      }
    } catch (e, st) {
      _logger.e('시스템 로그 삭제 처리 오류', error: e, stackTrace: st);
    }
  }

  void clearLogs() {
    state = [];
  }

  /// 항상위 모드가 필요한 미대응 로그가 있는지 확인
  bool get hasAlwaysOnTopNeeded {
    return state.any((entity) => _needsAlwaysOnTop(entity));
  }

  /// 항상위 모드 재평가 - 필요하면 활성화, 불필요하면 해제 (외부에서도 호출 가능)
  Future<void> checkAndReleaseAlwaysOnTop() async {
    final hasNeeded = state.any((entity) => _needsAlwaysOnTop(entity));
    _logger.i('항상위 모드 필요 체크: hasNeeded=$hasNeeded, 현재상태=${AppTrayManager.isAlwaysOnTop}');

    if (hasNeeded && !AppTrayManager.isAlwaysOnTop) {
      // 필요한데 꺼져있으면 활성화
      _logger.w('항상위 모드 필요한 미대응 로그 있음 - 항상위모드 활성화');
      await AppTrayManager.showWindowAlwaysOnTop();
      ref.read(alwaysOnTopStateProvider.notifier).setAlwaysOnTop(true);
    } else if (!hasNeeded && AppTrayManager.isAlwaysOnTop) {
      // 불필요한데 켜져있으면 해제
      _logger.i('항상위 모드 필요한 미대응 로그 없음 - 항상위모드 해제');
      await AppTrayManager.releaseAlwaysOnTop();
      ref.read(alwaysOnTopStateProvider.notifier).setAlwaysOnTop(false);
    }
  }
}

// 알림용 스트림 provider
@Riverpod(keepAlive: true)
Stream<SystemLogEntity> systemLogAlerts(Ref ref) {
  final service = ref.watch(systemLogRealtimeServiceProvider.notifier);
  return service.alertStream;
}
