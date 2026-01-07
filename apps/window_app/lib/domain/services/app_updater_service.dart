import 'package:desktop_updater/desktop_updater.dart';
import 'package:desktop_updater/updater_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:window_app/infrastructure/config/env_config.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';

part 'app_updater_service.freezed.dart';
part 'app_updater_service.g.dart';

/// 앱 업데이트 상태
@freezed
abstract class AppUpdateState with _$AppUpdateState {
  const factory AppUpdateState({
    @Default(false) bool isChecking,
    @Default(false) bool updateAvailable,
    @Default(false) bool isDownloading,
    @Default(false) bool isDownloaded,
    @Default(0.0) double downloadProgress,
    String? newVersion,
    String? currentVersion,
    String? errorMessage,
  }) = _AppUpdateState;
}

/// 앱 업데이터 서비스
@Riverpod(keepAlive: true)
class AppUpdaterService extends _$AppUpdaterService {
  DesktopUpdaterController? _controller;

  /// GitHub Raw URL에서 app-archive.json 가져오기
  Uri get _appArchiveUrl => Uri.parse(
        'https://raw.githubusercontent.com/${EnvConfig.githubOwner}/${EnvConfig.githubRepo}/main/releases/app-archive.json',
      );

  DesktopUpdaterController get controller {
    if (_controller == null) {
      _controller = DesktopUpdaterController(
        appArchiveUrl: _appArchiveUrl,
        localization: const DesktopUpdateLocalization(
          updateAvailableText: '업데이트 가능',
          downloadText: '다운로드',
          skipThisVersionText: '이 버전 건너뛰기',
          restartText: '재시작하여 업데이트',
          warningTitleText: '확인',
          restartWarningText: '업데이트를 완료하려면 앱을 재시작해야 합니다.\n저장하지 않은 변경사항은 손실됩니다. 지금 재시작하시겠습니까?',
          warningCancelText: '나중에',
          warningConfirmText: '재시작',
        ),
      );

      // 컨트롤러 변경 감지
      _controller!.addListener(_onControllerChanged);
    }
    return _controller!;
  }

  void _onControllerChanged() {
    final ctrl = _controller!;
    state = state.copyWith(
      updateAvailable: ctrl.needUpdate && !ctrl.skipUpdate,
      isDownloading: ctrl.isDownloading,
      isDownloaded: ctrl.isDownloaded,
      downloadProgress: ctrl.downloadProgress,
      newVersion: ctrl.appVersion,
    );
  }

  @override
  AppUpdateState build() {
    // 현재 버전 로드
    _loadCurrentVersion();

    // 앱 시작 시 자동 업데이트 확인 (3초 딜레이)
    Future.delayed(const Duration(seconds: 3), () {
      // 컨트롤러 초기화 (이미 checkVersion 호출됨)
      controller;
    });

    ref.onDispose(() {
      _controller?.removeListener(_onControllerChanged);
      _controller?.dispose();
    });

    return const AppUpdateState();
  }

  /// 현재 앱 버전 로드
  Future<void> _loadCurrentVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      state = state.copyWith(currentVersion: packageInfo.version);
    } catch (e) {
      logger.e('버전 정보 로드 실패', error: e);
    }
  }

  /// 업데이트 확인
  Future<void> checkForUpdates({bool showNoUpdateMessage = true}) async {
    if (state.isChecking) return;

    state = state.copyWith(isChecking: true, errorMessage: null);

    try {
      await controller.checkVersion();

      if (controller.needUpdate) {
        state = state.copyWith(
          isChecking: false,
          updateAvailable: true,
          newVersion: controller.appVersion,
        );
        logger.i('새 버전 발견: ${controller.appVersion}');
      } else {
        state = state.copyWith(
          isChecking: false,
          updateAvailable: false,
        );
        if (showNoUpdateMessage) {
          logger.i('최신 버전입니다');
        }
      }
    } catch (e, stackTrace) {
      logger.e('업데이트 확인 실패', error: e, stackTrace: stackTrace);
      state = state.copyWith(
        isChecking: false,
        errorMessage: '업데이트 확인 실패: $e',
      );
    }
  }

  /// 업데이트 다운로드 시작
  Future<void> startUpdate() async {
    if (state.isDownloading) return;

    state = state.copyWith(isDownloading: true, downloadProgress: 0.0);

    try {
      await controller.downloadUpdate();
      logger.i('업데이트 다운로드 시작됨');
    } catch (e, stackTrace) {
      logger.e('업데이트 다운로드 실패', error: e, stackTrace: stackTrace);
      state = state.copyWith(
        isDownloading: false,
        errorMessage: '업데이트 실패: $e',
      );
    }
  }

  /// 앱 재시작
  void restartApp() {
    controller.restartApp();
  }

  /// 업데이트 알림 무시
  void dismissUpdate() {
    controller.makeSkipUpdate();
    state = state.copyWith(updateAvailable: false);
  }

  /// 에러 메시지 클리어
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
