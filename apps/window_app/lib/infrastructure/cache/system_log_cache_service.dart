import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';

part 'system_log_cache_service.g.dart';

/// 시스템 로그 로컬 캐시 서비스
class SystemLogCacheService {
  static const String _boxName = 'system_logs_cache';
  static const String _logsKey = 'cached_logs';
  static const String _lastUpdatedKey = 'last_updated';

  Box<dynamic>? _box;

  /// Hive 초기화
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  /// 캐시된 로그 저장
  Future<void> saveLogs(List<Map<String, dynamic>> logs) async {
    if (_box == null) return;

    try {
      await _box!.put(_logsKey, logs);
      await _box!.put(_lastUpdatedKey, DateTime.now().toIso8601String());
    } catch (e) {
      // 캐시 저장 실패는 무시
    }
  }

  /// 캐시된 로그 불러오기
  List<Map<String, dynamic>> loadLogs() {
    if (_box == null) return [];

    try {
      final cached = _box!.get(_logsKey);
      if (cached == null) return [];

      // Hive에서 가져온 데이터를 Map<String, dynamic>으로 변환
      return (cached as List).map((item) {
        if (item is Map) {
          return Map<String, dynamic>.from(item);
        }
        return <String, dynamic>{};
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// 마지막 업데이트 시간
  DateTime? get lastUpdated {
    if (_box == null) return null;

    try {
      final str = _box!.get(_lastUpdatedKey) as String?;
      if (str == null) return null;
      return DateTime.parse(str);
    } catch (e) {
      return null;
    }
  }

  /// 캐시 삭제
  Future<void> clearCache() async {
    if (_box == null) return;
    await _box!.clear();
  }

  /// 캐시 닫기
  Future<void> close() async {
    await _box?.close();
  }
}

/// SystemLogCacheService Provider
@Riverpod(keepAlive: true)
SystemLogCacheService systemLogCacheService(Ref ref) {
  final service = SystemLogCacheService();
  ref.onDispose(() => service.close());
  return service;
}
