import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/models/notification_settings.dart';
import 'package:window_app/infrastructure/local-storage/shared_preferences_storage.dart';

part 'notification_settings_service.g.dart';

const _storageKey = 'notification_settings';

@Riverpod(keepAlive: true)
class NotificationSettingsService extends _$NotificationSettingsService {
  @override
  NotificationSettings build() {
    _loadSettings();
    return const NotificationSettings();
  }

  Future<void> _loadSettings() async {
    final storage = ref.read(localStorageProvider);
    final jsonString = storage.getString(_storageKey);

    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        state = NotificationSettings.fromJson(json);
      } catch (_) {
        // 파싱 실패 시 기본값 유지
      }
    }
  }

  Future<void> _saveSettings() async {
    final storage = ref.read(localStorageProvider);
    final jsonString = jsonEncode(state.toJson());
    await storage.setString(_storageKey, jsonString);
  }

  /// warning 알림 동작 변경
  Future<void> setWarningAction(NotificationAction action) async {
    state = state.copyWith(warningAction: action);
    await _saveSettings();
  }

  /// error 알림 동작 변경
  Future<void> setErrorAction(NotificationAction action) async {
    state = state.copyWith(errorAction: action);
    await _saveSettings();
  }

  /// critical 알림 동작 변경
  Future<void> setCriticalAction(NotificationAction action) async {
    state = state.copyWith(criticalAction: action);
    await _saveSettings();
  }

  /// 헬스체크 알림 표시 여부 변경
  Future<void> setShowHealthCheck(bool value) async {
    state = state.copyWith(showHealthCheck: value);
    await _saveSettings();
  }

  /// 기본값으로 초기화
  Future<void> resetToDefault() async {
    state = const NotificationSettings();
    await _saveSettings();
  }
}
