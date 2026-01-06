import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/presentation/layout/base_page.dart';
import 'package:window_app/presentation/pages/splash/signup/signup_view_model.dart';
import 'package:window_app/presentation/pages/splash/splash_screen.dart';
import 'package:window_app/presentation/pages/splash/verification/email_verification_screen.dart';

class SignupScreen extends BasePage {
  const SignupScreen({super.key});

  static const String path = '/signup';
  static const String name = 'signup';

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('회원가입'),
      centerTitle: true,
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signupViewModelProvider);
    final viewModel = ref.read(signupViewModelProvider.notifier);

    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final nameFocus = useFocusNode();
    final emailFocus = useFocusNode();
    final passwordFocus = useFocusNode();
    final confirmPasswordFocus = useFocusNode();

    Future<void> handleSubmit() async {
      if (state.isLoading) return;

      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('비밀번호가 일치하지 않습니다'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final success = await viewModel.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
      );
      if (success && context.mounted) {
        context.go(EmailVerificationScreen.path);
      }
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.person_add_outlined,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              const Text(
                '계정 만들기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '새 계정을 생성하세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: nameController,
                focusNode: nameFocus,
                decoration: const InputDecoration(
                  labelText: '이름',
                  prefixIcon: Icon(Icons.person_outlined),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => emailFocus.requestFocus(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                focusNode: emailFocus,
                decoration: const InputDecoration(
                  labelText: '이메일',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => passwordFocus.requestFocus(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                focusNode: passwordFocus,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  prefixIcon: Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => confirmPasswordFocus.requestFocus(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                focusNode: confirmPasswordFocus,
                decoration: const InputDecoration(
                  labelText: '비밀번호 확인',
                  prefixIcon: Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => handleSubmit(),
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: state.isLoading ? null : handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('회원가입'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go(SplashScreen.path),
                child: const Text('이미 계정이 있으신가요? 로그인'),
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
