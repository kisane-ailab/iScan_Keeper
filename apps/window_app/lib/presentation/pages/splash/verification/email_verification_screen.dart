import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/domain/services/auth_service.dart';
import 'package:window_app/presentation/layout/base_page.dart';
import 'package:window_app/presentation/pages/splash/splash_screen.dart';

class EmailVerificationScreen extends BasePage {
  const EmailVerificationScreen({super.key});

  static const String path = '/email-verification';
  static const String name = 'email-verification';

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    return null;
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final pendingEmail = ref.watch(pendingVerificationEmailProvider);
    final user = ref.watch(currentUserProvider);
    final email = pendingEmail ?? user?.email ?? '이메일';

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_unread_outlined,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 32),
              const Text(
                '이메일 인증 필요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$email로\n인증 메일을 발송했습니다.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '메일함을 확인하고 인증 링크를 클릭해주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '인증 완료 후 로그인 페이지에서 다시 로그인해주세요.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // 대기 이메일 초기화
                    ref.read(pendingVerificationEmailProvider.notifier).clear();
                    context.go(SplashScreen.path);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('로그인 페이지로 이동'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wrapWithSafeArea => false;
}
