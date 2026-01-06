import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:window_app/data/models/event_log_model.dart';
import 'package:window_app/domain/services/event_log_realtime_service.dart';
import 'package:window_app/domain/services/notification_settings_service.dart';
import 'package:window_app/infrastructure/notification/notification_handler.dart';
import 'package:window_app/presentation/router/app_router.dart';

class WindowApp extends ConsumerStatefulWidget {
  const WindowApp({super.key});

  @override
  ConsumerState<WindowApp> createState() => _WindowAppState();
}

class _WindowAppState extends ConsumerState<WindowApp> {
  StreamSubscription<EventLogModel>? _alertSubscription;

  @override
  void initState() {
    super.initState();
    // 앱 시작 시 전역 알림 구독 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupAlertSubscription();
    });
  }

  void _setupAlertSubscription() {
    final service = ref.read(eventLogRealtimeServiceProvider.notifier);
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
    ref.watch(eventLogRealtimeServiceProvider);

    return MaterialApp.router(
      title: 'iScan Keeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
