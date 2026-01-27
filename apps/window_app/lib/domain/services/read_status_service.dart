import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';

part 'read_status_service.g.dart';

/// 로그 읽음 상태 관리 서비스
/// - 상세보기를 열면 읽음 처리
/// - Hive에 읽은 로그 ID 목록 저장
@Riverpod(keepAlive: true)
class ReadStatusService extends _$ReadStatusService {
  static const String _boxName = 'read_status_cache';
  static const String _eventReadIdsKey = 'read_event_ids';
  static const String _healthCheckReadIdsKey = 'read_health_check_ids';
  static const int _maxStoredIds = 500; // 최대 저장 ID 개수

  Box<dynamic>? _box;

  @override
  ReadStatusState build() {
    _initFromHive();
    return const ReadStatusState(
      readEventIds: {},
      readHealthCheckIds: {},
    );
  }

  /// Hive에서 읽음 상태 로드
  Future<void> _initFromHive() async {
    try {
      _box = await Hive.openBox(_boxName);

      final eventIds = _box?.get(_eventReadIdsKey);
      final healthCheckIds = _box?.get(_healthCheckReadIdsKey);

      final eventSet = eventIds is List
          ? Set<String>.from(eventIds.cast<String>())
          : <String>{};
      final healthCheckSet = healthCheckIds is List
          ? Set<String>.from(healthCheckIds.cast<String>())
          : <String>{};

      state = ReadStatusState(
        readEventIds: eventSet,
        readHealthCheckIds: healthCheckSet,
      );

      ref.read(appLoggerProvider).i('읽음 상태 로드 완료: 이벤트 ${eventSet.length}건, 헬스체크 ${healthCheckSet.length}건');
    } catch (e) {
      ref.read(appLoggerProvider).w('읽음 상태 로드 실패', error: e);
    }
  }

  /// Hive에 이벤트 읽음 상태 저장
  Future<void> _saveEventIds(List<String> ids) async {
    try {
      if (_box == null) {
        _box = await Hive.openBox(_boxName);
      }
      await _box?.put(_eventReadIdsKey, ids);
    } catch (e) {
      ref.read(appLoggerProvider).w('이벤트 읽음 상태 저장 실패', error: e);
    }
  }

  /// Hive에 헬스체크 읽음 상태 저장
  Future<void> _saveHealthCheckIds(List<String> ids) async {
    try {
      if (_box == null) {
        _box = await Hive.openBox(_boxName);
      }
      await _box?.put(_healthCheckReadIdsKey, ids);
    } catch (e) {
      ref.read(appLoggerProvider).w('헬스체크 읽음 상태 저장 실패', error: e);
    }
  }

  /// 이벤트 읽음 처리
  Future<void> markEventAsRead(String id) async {
    if (state.readEventIds.contains(id)) return;

    final newSet = Set<String>.from(state.readEventIds)..add(id);

    // 최대 개수 초과 시 오래된 것 제거
    final list = newSet.toList();
    if (list.length > _maxStoredIds) {
      list.removeRange(0, list.length - _maxStoredIds);
    }

    await _saveEventIds(list);
    state = state.copyWith(readEventIds: Set.from(list));
  }

  /// 헬스체크 읽음 처리
  Future<void> markHealthCheckAsRead(String id) async {
    if (state.readHealthCheckIds.contains(id)) return;

    final newSet = Set<String>.from(state.readHealthCheckIds)..add(id);

    // 최대 개수 초과 시 오래된 것 제거
    final list = newSet.toList();
    if (list.length > _maxStoredIds) {
      list.removeRange(0, list.length - _maxStoredIds);
    }

    await _saveHealthCheckIds(list);
    state = state.copyWith(readHealthCheckIds: Set.from(list));
  }

  /// 이벤트 읽음 여부 확인
  bool isEventRead(String id) => state.readEventIds.contains(id);

  /// 헬스체크 읽음 여부 확인
  bool isHealthCheckRead(String id) => state.readHealthCheckIds.contains(id);

  /// 모든 이벤트 읽음 처리
  Future<void> markAllEventsAsRead(List<String> ids) async {
    final newSet = Set<String>.from(state.readEventIds)..addAll(ids);

    final list = newSet.toList();
    if (list.length > _maxStoredIds) {
      list.removeRange(0, list.length - _maxStoredIds);
    }

    await _saveEventIds(list);
    state = state.copyWith(readEventIds: Set.from(list));
  }

  /// 모든 헬스체크 읽음 처리
  Future<void> markAllHealthChecksAsRead(List<String> ids) async {
    final newSet = Set<String>.from(state.readHealthCheckIds)..addAll(ids);

    final list = newSet.toList();
    if (list.length > _maxStoredIds) {
      list.removeRange(0, list.length - _maxStoredIds);
    }

    await _saveHealthCheckIds(list);
    state = state.copyWith(readHealthCheckIds: Set.from(list));
  }
}

/// 읽음 상태 저장 클래스
class ReadStatusState {
  final Set<String> readEventIds;
  final Set<String> readHealthCheckIds;

  const ReadStatusState({
    required this.readEventIds,
    required this.readHealthCheckIds,
  });

  ReadStatusState copyWith({
    Set<String>? readEventIds,
    Set<String>? readHealthCheckIds,
  }) {
    return ReadStatusState(
      readEventIds: readEventIds ?? this.readEventIds,
      readHealthCheckIds: readHealthCheckIds ?? this.readHealthCheckIds,
    );
  }
}
