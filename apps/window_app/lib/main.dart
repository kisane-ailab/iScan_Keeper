import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_app/app.dart';
import 'package:window_app/infrastructure/cache/system_log_cache_service.dart';
import 'package:window_app/infrastructure/local-storage/shared_preferences_storage.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';
import 'package:window_app/infrastructure/system_tray/tray_manager.dart';
import 'package:window_app/infrastructure/notification/notification_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Window Manager 초기화
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1200, 800),
    minimumSize: Size(800, 600),
    center: true,
    title: 'iScan Keeper',
    skipTaskbar: false,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // 창 닫기 방지 (트레이로 숨김)
  await windowManager.setPreventClose(true);
  windowManager.addListener(WindowListenerHandler());

  // Hive 로컬 캐시 초기화
  await Hive.initFlutter();

  // Supabase 초기화
  await SupabaseInitializer.initialize();

  // 시스템 트레이 초기화
  await AppTrayManager.initialize();

  // 알림 핸들러 초기화
  await NotificationHandler.initialize();

  // SharedPreferences 미리 초기화
  final sharedPreferences = await SharedPreferences.getInstance();

  // ProviderContainer에 override 주입
  final container = ProviderContainer(
    overrides: [
      localStorageProvider.overrideWithValue(
        SharedPreferencesStorage(sharedPreferences),
      ),
    ],
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const WindowApp(),
    ),
  );
}
