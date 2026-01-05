import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/infrastructure/local-storage/local_storage.dart';
import 'package:window_app/infrastructure/local-storage/shared_preferences_storage.dart';

part 'telegram_local_datasource.g.dart';

/// Telegram Local DataSource (캐시)
class TelegramLocalDataSource {
  static const String _cacheKey = 'telegram_updates_cache';
  static const String _cacheTimeKey = 'telegram_updates_cache_time';

  final LocalStorage _storage;

  TelegramLocalDataSource(this._storage);

  /// 캐시된 데이터 조회
  dynamic getCachedUpdates() {
    final cached = _storage.getString(_cacheKey);
    if (cached == null) return null;
    return jsonDecode(cached);
  }

  /// 데이터 캐시 저장
  Future<void> cacheUpdates(dynamic data) async {
    await _storage.setString(_cacheKey, jsonEncode(data));
    await _storage.setInt(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// 캐시 시간 조회
  DateTime? getCacheTime() {
    final time = _storage.getInt(_cacheTimeKey);
    if (time == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  /// 캐시가 유효한지 확인 (기본 5분)
  bool isCacheValid({Duration maxAge = const Duration(minutes: 5)}) {
    final cacheTime = getCacheTime();
    if (cacheTime == null) return false;
    return DateTime.now().difference(cacheTime) < maxAge;
  }

  /// 캐시 삭제
  Future<void> clearCache() async {
    await _storage.remove(_cacheKey);
    await _storage.remove(_cacheTimeKey);
  }
}

/// TelegramLocalDataSource Provider
@riverpod
TelegramLocalDataSource telegramLocalDataSource(Ref ref) {
  final storage = ref.watch(localStorageProvider);
  return TelegramLocalDataSource(storage);
}
