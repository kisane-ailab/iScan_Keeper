import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/models/enums/environment.dart';
import 'package:window_app/data/models/notification_settings.dart';
import 'package:window_app/domain/services/system_log_realtime_service.dart';
import 'package:window_app/infrastructure/local-storage/shared_preferences_storage.dart';

part 'notification_settings_service.g.dart';

const _storageKey = 'notification_settings_v2';

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

  /// Production warning 알림 동작 변경
  Future<void> setProductionWarningAction(NotificationAction action) async {
    state = state.copyWith(
      production: state.production.copyWith(warningAction: action),
    );
    await _saveSettings();
    await _reevaluateAlwaysOnTop();
  }

  /// Production error 알림 동작 변경
  Future<void> setProductionErrorAction(NotificationAction action) async {
    state = state.copyWith(
      production: state.production.copyWith(errorAction: action),
    );
    await _saveSettings();
    await _reevaluateAlwaysOnTop();
  }

  /// Production critical 알림 동작 변경
  Future<void> setProductionCriticalAction(NotificationAction action) async {
    state = state.copyWith(
      production: state.production.copyWith(criticalAction: action),
    );
    await _saveSettings();
    await _reevaluateAlwaysOnTop();
  }

  /// Development warning 알림 동작 변경
  Future<void> setDevelopmentWarningAction(NotificationAction action) async {
    state = state.copyWith(
      development: state.development.copyWith(warningAction: action),
    );
    await _saveSettings();
    await _reevaluateAlwaysOnTop();
  }

  /// Development error 알림 동작 변경
  Future<void> setDevelopmentErrorAction(NotificationAction action) async {
    state = state.copyWith(
      development: state.development.copyWith(errorAction: action),
    );
    await _saveSettings();
    await _reevaluateAlwaysOnTop();
  }

  /// Development critical 알림 동작 변경
  Future<void> setDevelopmentCriticalAction(NotificationAction action) async {
    state = state.copyWith(
      development: state.development.copyWith(criticalAction: action),
    );
    await _saveSettings();
    await _reevaluateAlwaysOnTop();
  }

  /// 환경별 레벨 알림 동작 변경
  Future<void> setActionForEnvironment(
    Environment environment,
    String level,
    NotificationAction action,
  ) async {
    if (environment.isProduction) {
      switch (level) {
        case 'warning':
          await setProductionWarningAction(action);
        case 'error':
          await setProductionErrorAction(action);
        case 'critical':
          await setProductionCriticalAction(action);
      }
    } else {
      switch (level) {
        case 'warning':
          await setDevelopmentWarningAction(action);
        case 'error':
          await setDevelopmentErrorAction(action);
        case 'critical':
          await setDevelopmentCriticalAction(action);
      }
    }
  }

  /// 설정 변경 시 항상위 모드 재평가
  Future<void> _reevaluateAlwaysOnTop() async {
    await ref.read(systemLogRealtimeServiceProvider.notifier).checkAndReleaseAlwaysOnTop();
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
    await _reevaluateAlwaysOnTop();
  }
}
