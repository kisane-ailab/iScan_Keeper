import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/models/notification_settings.dart';
import 'package:window_app/data/repositories/response_repository_impl.dart';
import 'package:window_app/data/repositories/user_repository_impl.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/domain/services/auth_service.dart';
import 'package:window_app/domain/services/notification_settings_service.dart';
import 'package:window_app/domain/services/system_log_realtime_service.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/system_tray/tray_manager.dart';

part 'event_response_service.g.dart';

@Riverpod(keepAlive: true)
class EventResponseService extends _$EventResponseService {
  @override
  List<String> build() {
    // 현재 내가 대응 중인 이벤트 ID 목록
    return [];
  }

  /// 현재 사용자 정보 가져오기
  Future<Map<String, dynamic>?> _getCurrentUserInfo() async {
    final authState = ref.read(authServiceProvider);
    final userId = authState.user?.id;
    if (userId == null) return null;

    final userRepository = ref.read(userRepositoryProvider);
    return await userRepository.getUser(userId);
  }

  /// 대응 시작
  Future<bool> startResponse(SystemLogEntity entity) async {
    try {
      final userInfo = await _getCurrentUserInfo();

      if (userInfo == null) {
        logger.e('대응 시작 실패: 로그인 필요');
        return false;
      }

      final userId = userInfo['id'] as String;
      final userName = userInfo['name'] as String;

      // 이미 다른 사람이 대응 중인지 확인
      if (entity.isBeingResponded && entity.currentResponderId != userId) {
        logger.w('이미 ${entity.currentResponderName}님이 대응 중입니다');
        return false;
      }

      // Repository를 통해 대응 시작
      final responseRepository = ref.read(responseRepositoryProvider);
      await responseRepository.startResponse(
        eventLogId: entity.id,
        userId: userId,
        userName: userName,
      );

      // 내 대응 목록에 추가
      state = [...state, entity.id];

      // 항상위 모드가 필요한 다른 미확인 로그가 없으면 해제
      if (AppTrayManager.isAlwaysOnTop) {
        final entities = ref.read(systemLogRealtimeServiceProvider);
        final settings = ref.read(notificationSettingsServiceProvider);

        final otherNeedsAlwaysOnTop = entities.any((e) {
          if (e.id == entity.id) return false;
          if (!e.isUnchecked) return false;
          final action = settings.getActionForLevel(e.logLevel, environment: e.environment);
          return action == NotificationAction.alwaysOnTop;
        });

        if (!otherNeedsAlwaysOnTop) {
          await AppTrayManager.releaseAlwaysOnTop();
          ref.read(alwaysOnTopStateProvider.notifier).setAlwaysOnTop(false);
          logger.i('항상위 필요 로그 없음 - 항상 위 모드 해제');
        } else {
          logger.i('아직 항상위 필요 로그 있음 - 항상 위 모드 유지');
        }
      }

      logger.i('대응 시작: ${entity.id}');
      return true;
    } catch (e) {
      logger.e('대응 시작 실패', error: e);
      return false;
    }
  }

  /// 대응 포기 (미확인으로 되돌림)
  Future<bool> abandonResponse(SystemLogEntity entity) async {
    try {
      final userInfo = await _getCurrentUserInfo();

      if (userInfo == null) return false;

      final userId = userInfo['id'] as String;

      // 내가 대응 중인 건만 포기 가능
      if (entity.currentResponderId != userId) {
        logger.w('본인이 대응 중인 건만 포기할 수 있습니다');
        return false;
      }

      // Repository를 통해 대응 취소
      final responseRepository = ref.read(responseRepositoryProvider);
      await responseRepository.cancelResponse(
        eventLogId: entity.id,
        userId: userId,
      );

      // 내 대응 목록에서 제거
      state = state.where((id) => id != entity.id).toList();

      logger.i('대응 포기: ${entity.id}');
      return true;
    } catch (e) {
      logger.e('대응 포기 실패', error: e);
      return false;
    }
  }

  /// 대응 완료
  Future<bool> completeResponse(SystemLogEntity entity, String memo) async {
    try {
      final userInfo = await _getCurrentUserInfo();

      if (userInfo == null) return false;

      final userId = userInfo['id'] as String;

      // Repository를 통해 대응 완료
      final responseRepository = ref.read(responseRepositoryProvider);
      await responseRepository.completeResponse(
        eventLogId: entity.id,
        userId: userId,
        memo: memo,
      );

      // 내 대응 목록에서 제거
      state = state.where((id) => id != entity.id).toList();

      logger.i('대응 완료: ${entity.id}');
      return true;
    } catch (e) {
      logger.e('대응 완료 실패', error: e);
      return false;
    }
  }

  /// 현재 내가 대응 중인지 확인
  bool isMyResponse(String systemLogId) {
    return state.contains(systemLogId);
  }
}
