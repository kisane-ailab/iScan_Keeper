import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  // 페이지네이션 상태 (이벤트만)
  static const int _pageSize = 50;
  int _prodEventOffset = 0;
  int _devEventOffset = 0;
  bool _hasMoreProdEvent = true;
  bool _hasMoreDevEvent = true;
  bool _isLoadingMore = false;

  // 로컬 캐시
  static const String _cacheBoxName = 'system_logs_cache';
  static const String _cacheKey = 'logs';
  Box<dynamic>? _cacheBox;

  Logger get _logger => ref.read(appLoggerProvider);
  Stream<SystemLogEntity> get alertStream => _alertController.stream;

  /// 더 불러올 이벤트 데이터가 있는지
  bool get hasMoreData => _hasMoreProdEvent || _hasMoreDevEvent;

  /// 추가 로딩 중인지
  bool get isLoadingMore => _isLoadingMore;

  /// 현재 알림 설정 가져오기
  NotificationSettings get _settings => ref.read(notificationSettingsServiceProvider);

  @override
  List<SystemLogEntity> build() {
    _initAndLoad();

    ref.onDispose(() {
      _channel?.unsubscribe();
      _alertController.close();
    });

    return [];
  }

  /// 초기화 및 로드 (캐시 → 서버)
  Future<void> _initAndLoad() async {
    // 1. 캐시에서 먼저 로드 (즉시 표시)
    await _loadFromCache();

    // 2. 리얼타임 리스닝 시작
    _startListening();

    // 3. 서버에서 최신 데이터 fetch (백그라운드)
    await _fetchInitialLogs();
  }

  /// 로컬 캐시에서 로드
  Future<void> _loadFromCache() async {
    try {
      _cacheBox = await Hive.openBox(_cacheBoxName);
      final cached = _cacheBox?.get(_cacheKey);

      if (cached != null && cached is List) {
        final logs = <SystemLogEntity>[];
        for (final item in cached) {
          try {
            if (item is Map) {
              final map = Map<String, dynamic>.from(item);
              final model = SystemLogModel.fromJson(map);
              logs.add(_toEntity(model));
            }
          } catch (e) {
            // 파싱 실패한 항목 무시
          }
        }

        if (logs.isNotEmpty) {
          logs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          state = logs;
          _logger.i('캐시에서 ${logs.length}건 로드 완료');
        }
      }
    } catch (e) {
      _logger.w('캐시 로드 실패', error: e);
    }
  }

  /// 로컬 캐시에 저장
  Future<void> _saveToCache() async {
    try {
      if (_cacheBox == null) {
        _cacheBox = await Hive.openBox(_cacheBoxName);
      }

      // Entity를 JSON Map으로 변환하여 저장
      final jsonList = state.map((entity) => entity.toJson()).toList();
      await _cacheBox?.put(_cacheKey, jsonList);
      _logger.d('캐시에 ${jsonList.length}건 저장 완료');
    } catch (e) {
      _logger.w('캐시 저장 실패', error: e);
    }
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

  /// 기존 로그 조회 (앱 시작 시) - 이벤트는 페이지네이션, 헬스체크는 전체 조회
  Future<void> _fetchInitialLogs() async {
    try {
      // 페이지네이션 상태 초기화 (이벤트만)
      _prodEventOffset = 0;
      _devEventOffset = 0;
      _hasMoreProdEvent = true;
      _hasMoreDevEvent = true;

      final client = ref.read(supabaseClientProvider);

      // 최근 2주 기준 날짜
      final twoWeeksAgo = DateTime.now().subtract(const Duration(days: 14)).toUtc().toIso8601String();

      // 이벤트 로그 조회 - Production (페이지네이션)
      final prodEventResponse = await client
          .from('system_logs')
          .select()
          .eq('category', 'event')
          .eq('environment', 'production')
          .or('is_muted.is.null,is_muted.eq.false')
          .gte('created_at', twoWeeksAgo)
          .order('created_at', ascending: false)
          .range(0, _pageSize - 1);

      // 이벤트 로그 조회 - Development (페이지네이션)
      final devEventResponse = await client
          .from('system_logs')
          .select()
          .eq('category', 'event')
          .eq('environment', 'development')
          .or('is_muted.is.null,is_muted.eq.false')
          .gte('created_at', twoWeeksAgo)
          .order('created_at', ascending: false)
          .range(0, _pageSize - 1);

      // 헬스체크 로그 조회 - Production (전체)
      final prodHealthCheckResponse = await client
          .from('system_logs')
          .select()
          .eq('category', 'health_check')
          .eq('environment', 'production')
          .or('is_muted.is.null,is_muted.eq.false')
          .gte('created_at', twoWeeksAgo)
          .order('created_at', ascending: false);

      // 헬스체크 로그 조회 - Development (전체)
      final devHealthCheckResponse = await client
          .from('system_logs')
          .select()
          .eq('category', 'health_check')
          .eq('environment', 'development')
          .or('is_muted.is.null,is_muted.eq.false')
          .gte('created_at', twoWeeksAgo)
          .order('created_at', ascending: false);

      // 페이지네이션 상태 업데이트 (이벤트만)
      _hasMoreProdEvent = prodEventResponse.length >= _pageSize;
      _hasMoreDevEvent = devEventResponse.length >= _pageSize;
      _prodEventOffset = prodEventResponse.length;
      _devEventOffset = devEventResponse.length;

      // 전체 응답 합치기
      final eventResponse = [...prodEventResponse, ...devEventResponse];
      final healthCheckResponse = [...prodHealthCheckResponse, ...devHealthCheckResponse];

      _logger.i('초기 로그 조회 완료 - 이벤트: ${eventResponse.length}건 (prod: ${prodEventResponse.length}, dev: ${devEventResponse.length}), 헬스체크: ${healthCheckResponse.length}건');
      _logger.d('hasMore: prodEvent=$_hasMoreProdEvent, devEvent=$_hasMoreDevEvent');

      bool hasAlwaysOnTopNeeded = false;
      final allLogs = <SystemLogEntity>[];

      // 이벤트 로그 파싱
      for (final record in eventResponse) {
        try {
          final model = SystemLogModel.fromJson(record);
          final entity = _toEntity(model);
          allLogs.add(entity);
          if (_needsAlwaysOnTop(entity)) hasAlwaysOnTopNeeded = true;
        } catch (e) {
          _logger.e('이벤트 로그 파싱 오류', error: e);
        }
      }

      // 헬스체크 로그 파싱
      for (final record in healthCheckResponse) {
        try {
          final model = SystemLogModel.fromJson(record);
          final entity = _toEntity(model);
          allLogs.add(entity);
          if (_needsAlwaysOnTop(entity)) hasAlwaysOnTopNeeded = true;
        } catch (e) {
          _logger.e('헬스체크 로그 파싱 오류', error: e);
        }
      }

      // 시간순 정렬 (최신순)
      allLogs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = allLogs;

      // 캐시에 저장
      await _saveToCache();

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

  /// 추가 이벤트 로그 로딩 (무한 스크롤)
  Future<void> loadMore({String? environment}) async {
    if (_isLoadingMore || !hasMoreData) return;

    _isLoadingMore = true;

    try {
      final client = ref.read(supabaseClientProvider);
      final twoWeeksAgo = DateTime.now().subtract(const Duration(days: 14)).toUtc().toIso8601String();

      final newLogs = <SystemLogEntity>[];

      // Production 이벤트 추가 로딩
      if (_hasMoreProdEvent && (environment == null || environment == 'production')) {
        final response = await client
            .from('system_logs')
            .select()
            .eq('category', 'event')
            .eq('environment', 'production')
            .or('is_muted.is.null,is_muted.eq.false')
            .gte('created_at', twoWeeksAgo)
            .order('created_at', ascending: false)
            .range(_prodEventOffset, _prodEventOffset + _pageSize - 1);

        _hasMoreProdEvent = response.length >= _pageSize;
        _prodEventOffset += response.length;

        for (final record in response) {
          try {
            final model = SystemLogModel.fromJson(record);
            newLogs.add(_toEntity(model));
          } catch (e) {
            _logger.e('로그 파싱 오류', error: e);
          }
        }
      }

      // Development 이벤트 추가 로딩
      if (_hasMoreDevEvent && (environment == null || environment == 'development')) {
        final response = await client
            .from('system_logs')
            .select()
            .eq('category', 'event')
            .eq('environment', 'development')
            .or('is_muted.is.null,is_muted.eq.false')
            .gte('created_at', twoWeeksAgo)
            .order('created_at', ascending: false)
            .range(_devEventOffset, _devEventOffset + _pageSize - 1);

        _hasMoreDevEvent = response.length >= _pageSize;
        _devEventOffset += response.length;

        for (final record in response) {
          try {
            final model = SystemLogModel.fromJson(record);
            newLogs.add(_toEntity(model));
          } catch (e) {
            _logger.e('로그 파싱 오류', error: e);
          }
        }
      }

      if (newLogs.isNotEmpty) {
        // 중복 제거 후 추가
        final existingIds = state.map((e) => e.id).toSet();
        final uniqueNewLogs = newLogs.where((log) => !existingIds.contains(log.id)).toList();

        final allLogs = [...state, ...uniqueNewLogs];
        allLogs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        state = allLogs;

        // 캐시에 저장
        await _saveToCache();

        _logger.i('추가 이벤트 로딩 완료: ${uniqueNewLogs.length}건 추가 (총 ${state.length}건)');
      }
    } catch (e) {
      _logger.e('추가 이벤트 로딩 실패', error: e);
    } finally {
      _isLoadingMore = false;
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

  /// 로그 새로고침 (수동 리프레시)
  Future<void> refresh() async {
    _logger.i('수동 새로고침 시작');
    await _fetchInitialLogs();
  }

  /// 개별 로그 mute 설정
  Future<void> setLogMuted(String id, bool muted) async {
    try {
      final repository = ref.read(systemLogRepositoryProvider);
      await repository.setLogMuted(id, muted);

      // 로컬 상태에서 해당 로그 제거 (muted 처리되었으므로)
      if (muted) {
        state = state.where((log) => log.id != id).toList();
        _logger.i('로그 mute 완료: $id');
      }
    } catch (e) {
      _logger.e('로그 mute 실패: $id', error: e);
    }
  }

  /// 개별 로그 삭제 (관리자 전용)
  Future<void> deleteLog(String id) async {
    try {
      final repository = ref.read(systemLogRepositoryProvider);
      await repository.deleteSystemLog(id);

      // 로컬 상태에서 해당 로그 제거
      state = state.where((log) => log.id != id).toList();
      _logger.i('로그 삭제 완료: $id');

      // 항상위 모드 재평가
      await checkAndReleaseAlwaysOnTop();
    } catch (e) {
      _logger.e('로그 삭제 실패: $id', error: e);
      rethrow;
    }
  }

  /// 로그 일괄 삭제 (관리자 전용)
  Future<void> deleteLogs(List<String> ids) async {
    try {
      final repository = ref.read(systemLogRepositoryProvider);
      await repository.deleteSystemLogs(ids);

      // 로컬 상태에서 해당 로그들 제거
      state = state.where((log) => !ids.contains(log.id)).toList();
      _logger.i('로그 일괄 삭제 완료: ${ids.length}건');

      // 항상위 모드 재평가
      await checkAndReleaseAlwaysOnTop();
    } catch (e) {
      _logger.e('로그 일괄 삭제 실패: ${ids.length}건', error: e);
      rethrow;
    }
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
