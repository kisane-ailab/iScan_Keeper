import 'dart:async';

import 'package:desktop_updater/desktop_updater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/domain/services/app_updater_service.dart';
import 'package:window_app/domain/services/system_log_realtime_service.dart';
import 'package:window_app/domain/services/notification_settings_service.dart';
import 'package:window_app/infrastructure/notification/notification_handler.dart';
import 'package:window_app/infrastructure/system_tray/tray_manager.dart';
import 'package:window_app/presentation/router/app_router.dart';

class WindowApp extends ConsumerStatefulWidget {
  const WindowApp({super.key});

  @override
  ConsumerState<WindowApp> createState() => _WindowAppState();
}

class _WindowAppState extends ConsumerState<WindowApp> {
  StreamSubscription<SystemLogEntity>? _alertSubscription;

  @override
  void initState() {
    super.initState();
    // 앱 시작 시 전역 알림 구독 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupAlertSubscription();
    });
  }

  void _setupAlertSubscription() {
    final service = ref.read(systemLogRealtimeServiceProvider.notifier);
    _alertSubscription = service.alertStream.listen((log) {
      final settings = ref.read(notificationSettingsServiceProvider);
      NotificationHandler.handleEventLog(log, settings);
    });
  }

  @override
  void dispose() {
    _alertSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Realtime 서비스 시작 (앱 전체에서 백그라운드 구독)
    ref.watch(systemLogRealtimeServiceProvider);

    // 업데이터 서비스 활성화
    final updaterService = ref.watch(appUpdaterServiceProvider.notifier);

    return MaterialApp.router(
      title: 'iScan Keeper',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      routerConfig: ref.watch(appRouterProvider),
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            // 업데이트 다이얼로그 리스너
            UpdateDialogListener(controller: updaterService.controller),
          ],
        );
      },
    );
  }
}
