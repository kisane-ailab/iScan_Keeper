import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/domain/services/auth_service.dart';
import 'package:window_app/presentation/pages/main/main_shell.dart';
import 'package:window_app/presentation/pages/main/01_alert/alert_screen.dart';
import 'package:window_app/presentation/pages/main/02_dashboard/dashboard_screen.dart';
import 'package:window_app/presentation/pages/main/03_profile/profile_screen.dart';
import 'package:window_app/presentation/pages/main/04_settings/settings_screen.dart';
import 'package:window_app/presentation/pages/main/05_health_check/health_check_screen.dart';
import 'package:window_app/presentation/pages/main/06_muted/muted_screen.dart';
import 'package:window_app/presentation/pages/main/07_swagger/swagger_screen.dart';
import 'package:window_app/presentation/pages/splash/splash_screen.dart';
import 'package:window_app/presentation/pages/splash/signup/signup_screen.dart';
import 'package:window_app/presentation/pages/splash/verification/email_verification_screen.dart';

part 'app_router.g.dart';

// 네비게이션 키
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAlertKey = GlobalKey<NavigatorState>();
final _shellNavigatorHealthCheckKey = GlobalKey<NavigatorState>();
final _shellNavigatorDashboardKey = GlobalKey<NavigatorState>();
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>();
final _shellNavigatorSettingsKey = GlobalKey<NavigatorState>();
final _shellNavigatorMutedKey = GlobalKey<NavigatorState>();
final _shellNavigatorSwaggerKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(Ref ref) {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  final isEmailConfirmed = ref.watch(isEmailConfirmedProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: SplashScreen.path,
    redirect: (context, state) {
      final currentPath = state.matchedLocation;
      final isVerificationRoute = currentPath == EmailVerificationScreen.path;
      final isAuthRoute =
          currentPath == SplashScreen.path || currentPath == SignupScreen.path;

      // 로그인됨 + 이메일 인증 완료 + 인증 관련 페이지 → 메인으로
      if (isLoggedIn && isEmailConfirmed && (isAuthRoute || isVerificationRoute)) {
        return AlertScreen.path;
      }

      // 로그인됨 + 이메일 미인증 → 인증 대기 화면으로
      if (isLoggedIn && !isEmailConfirmed && !isVerificationRoute) {
        return EmailVerificationScreen.path;
      }

      // 비로그인 상태에서 인증 화면 접근 허용 (회원가입 직후)
      if (!isLoggedIn && isVerificationRoute) {
        return null;
      }

      // 로그인 안됨 + 메인 페이지 접근 시 → 스플래시로
      if (!isLoggedIn && !isAuthRoute) {
        return SplashScreen.path;
      }

      return null;
    },
    routes: [
      // 스플래시(로그인) 라우트
      GoRoute(
        path: SplashScreen.path,
        name: SplashScreen.name,
        builder: (context, state) => const SplashScreen(),
      ),
      // 회원가입 라우트
      GoRoute(
        path: SignupScreen.path,
        name: SignupScreen.name,
        builder: (context, state) => const SignupScreen(),
      ),
      // 이메일 인증 라우트
      GoRoute(
        path: EmailVerificationScreen.path,
        name: EmailVerificationScreen.name,
        builder: (context, state) => const EmailVerificationScreen(),
      ),
      // 메인 라우트 (StatefulShellRoute)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // 이벤트 알림 브랜치 (첫 번째)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAlertKey,
            routes: [
              GoRoute(
                path: AlertScreen.path,
                name: AlertScreen.name,
                builder: (context, state) => const AlertScreen(),
              ),
            ],
          ),
          // 헬스체크 브랜치 (두 번째)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHealthCheckKey,
            routes: [
              GoRoute(
                path: HealthCheckScreen.path,
                name: HealthCheckScreen.name,
                builder: (context, state) => const HealthCheckScreen(),
              ),
            ],
          ),
          // 대시보드 브랜치 (세 번째)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDashboardKey,
            routes: [
              GoRoute(
                path: DashboardScreen.path,
                name: DashboardScreen.name,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // 프로필 브랜치
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: ProfileScreen.path,
                name: ProfileScreen.name,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          // 설정 브랜치
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettingsKey,
            routes: [
              GoRoute(
                path: SettingsScreen.path,
                name: SettingsScreen.name,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
          // API 문서 브랜치
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSwaggerKey,
            routes: [
              GoRoute(
                path: SwaggerScreen.path,
                name: SwaggerScreen.name,
                builder: (context, state) => const SwaggerScreen(),
              ),
            ],
          ),
          // 숨긴 알림 브랜치
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMutedKey,
            routes: [
              GoRoute(
                path: MutedScreen.path,
                name: MutedScreen.name,
                builder: (context, state) => const MutedScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
