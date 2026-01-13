import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/infrastructure/local-storage/local_storage.dart';
import 'package:window_app/infrastructure/local-storage/shared_preferences_storage.dart';

part 'read_status_service.g.dart';

/// 로그 읽음 상태 관리 서비스
/// - 상세보기를 열면 읽음 처리
/// - 로컬 저장소에 읽은 로그 ID 목록 저장
@Riverpod(keepAlive: true)
class ReadStatusService extends _$ReadStatusService {
  static const String _eventReadIdsKey = 'read_event_ids';
  static const String _healthCheckReadIdsKey = 'read_health_check_ids';
  static const int _maxStoredIds = 500; // 최대 저장 ID 개수

  LocalStorage get _storage => ref.read(localStorageProvider);

  @override
  ReadStatusState build() {
    final eventIds = _storage.getStringList(_eventReadIdsKey) ?? [];
    final healthCheckIds = _storage.getStringList(_healthCheckReadIdsKey) ?? [];
    return ReadStatusState(
      readEventIds: Set.from(eventIds),
      readHealthCheckIds: Set.from(healthCheckIds),
    );
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

    await _storage.setStringList(_eventReadIdsKey, list);
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

    await _storage.setStringList(_healthCheckReadIdsKey, list);
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

    await _storage.setStringList(_eventReadIdsKey, list);
    state = state.copyWith(readEventIds: Set.from(list));
  }

  /// 모든 헬스체크 읽음 처리
  Future<void> markAllHealthChecksAsRead(List<String> ids) async {
    final newSet = Set<String>.from(state.readHealthCheckIds)..addAll(ids);

    final list = newSet.toList();
    if (list.length > _maxStoredIds) {
      list.removeRange(0, list.length - _maxStoredIds);
    }

    await _storage.setStringList(_healthCheckReadIdsKey, list);
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
