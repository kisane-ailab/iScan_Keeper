import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/presentation/layout/base_page.dart';

class SettingsScreen extends BasePage {
  const SettingsScreen({super.key});

  static const String path = '/settings';
  static const String name = 'settings';

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('설정'),
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    // 상태 유지 테스트용 스위치
    final darkMode = useState(false);
    final notifications = useState(true);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Icon(Icons.settings, size: 64, color: Colors.orange),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            '설정 화면',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        SwitchListTile(
          title: const Text('다크 모드'),
          subtitle: const Text('어두운 테마를 사용합니다'),
          value: darkMode.value,
          onChanged: (value) => darkMode.value = value,
        ),
        SwitchListTile(
          title: const Text('알림'),
          subtitle: const Text('푸시 알림을 받습니다'),
          value: notifications.value,
          onChanged: (value) => notifications.value = value,
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('앱 정보'),
          subtitle: Text('버전 1.0.0'),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            '다른 탭으로 이동 후 돌아와도 스위치 상태가 유지됩니다.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  @override
  bool get wrapWithSafeArea => false;
}
