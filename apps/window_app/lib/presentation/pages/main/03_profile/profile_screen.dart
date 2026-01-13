import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/domain/services/auth_service.dart';
import 'package:window_app/domain/services/event_response_service.dart';
import 'package:window_app/presentation/layout/base_page.dart';
import 'package:window_app/presentation/pages/main/03_profile/profile_view_model.dart';
import 'package:window_app/presentation/widgets/admin_label.dart';

class ProfileScreen extends BasePage {
  const ProfileScreen({super.key});

  static const String path = '/profile';
  static const String name = 'profile';

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const AppBarTitleWithLabel(title: '프로필'),
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final userDetail = ref.watch(currentUserDetailProvider);
    final state = ref.watch(profileViewModelProvider);
    final viewModel = ref.read(profileViewModelProvider.notifier);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            // 역할 뱃지
            userDetail.when(
              data: (detail) => detail != null
                  ? RoleBadge(role: detail.role, size: RoleBadgeSize.large)
                  : const SizedBox.shrink(),
              loading: () => const SizedBox(
                height: 32,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            // 이름 표시
            userDetail.when(
              data: (detail) => Text(
                detail?.name ?? user?.email ?? '알 수 없음',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              loading: () => const Text(
                '로딩 중...',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              error: (_, __) => Text(
                user?.email ?? '알 수 없음',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: 200,
              child: OutlinedButton.icon(
                onPressed: state.isLoading ? null : () => viewModel.signOut(),
                icon: state.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout),
                label: const Text('로그아웃'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wrapWithSafeArea => false;
}
