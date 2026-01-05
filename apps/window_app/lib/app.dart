import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:window_app/domain/services/event_log_realtime_service.dart';
import 'package:window_app/presentation/router/app_router.dart';

class WindowApp extends ConsumerWidget {
  const WindowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
