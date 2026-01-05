import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:tray_manager/tray_manager.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_manager/window_manager.dart';

class AppTrayManager with TrayListener {
  static final AppTrayManager _instance = AppTrayManager._internal();
  factory AppTrayManager() => _instance;
  AppTrayManager._internal();

  static Future<void> initialize() async {
    try {
      // 실행 파일 경로 기준으로 아이콘 찾기
      final exeDir = path.dirname(Platform.resolvedExecutable);
      final iconPath = path.join(exeDir, 'data', 'flutter_assets', 'assets', 'icons', 'app_icon.ico');

      // 아이콘 파일이 없으면 기본 경로 시도
      String finalIconPath;
      if (File(iconPath).existsSync()) {
        finalIconPath = iconPath;
      } else {
        // 개발 모드용 경로
        finalIconPath = 'windows/runner/resources/app_icon.ico';
      }

      await trayManager.setIcon(finalIconPath);
      await trayManager.setToolTip('iScan Keeper - 백그라운드 실행 중');

      final menu = Menu(
        items: [
          MenuItem(key: 'show', label: '열기'),
          MenuItem.separator(),
          MenuItem(key: 'exit', label: '종료'),
        ],
      );
      await trayManager.setContextMenu(menu);

      trayManager.addListener(_instance);
      logger.i('TrayManager 초기화 완료: $finalIconPath');
    } catch (e) {
      logger.e('TrayManager 초기화 실패', error: e);
    }
  }

  @override
  void onTrayIconMouseDown() {
    showWindow();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show':
        showWindow();
        break;
      case 'exit':
        exitApp();
        break;
    }
  }

  static Future<void> showWindow() async {
    await windowManager.show();
    await windowManager.focus();
  }

  static Future<void> hideWindow() async {
    await windowManager.hide();
  }

  static Future<void> exitApp() async {
    await trayManager.destroy();
    exit(0);
  }

  static Future<void> updateToolTip(String message) async {
    await trayManager.setToolTip(message);
  }
}

class WindowListenerHandler extends WindowListener {
  @override
  void onWindowClose() async {
    // 창 닫기 버튼 클릭 시 트레이로 숨김 (종료 X)
    await AppTrayManager.hideWindow();
  }

  @override
  void onWindowFocus() {}

  @override
  void onWindowBlur() {}

  @override
  void onWindowMaximize() {}

  @override
  void onWindowUnmaximize() {}

  @override
  void onWindowMinimize() {}

  @override
  void onWindowRestore() {}

  @override
  void onWindowResize() {}

  @override
  void onWindowMove() {}

  @override
  void onWindowEnterFullScreen() {}

  @override
  void onWindowLeaveFullScreen() {}

  @override
  void onWindowMoved() {}

  @override
  void onWindowResized() {}

  @override
  void onWindowDocked() {}

  @override
  void onWindowUndocked() {}
}
