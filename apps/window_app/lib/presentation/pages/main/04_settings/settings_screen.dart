import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/data/models/notification_settings.dart';
import 'package:window_app/domain/services/notification_settings_service.dart';
import 'package:window_app/presentation/layout/base_page.dart';

class SettingsScreen extends BasePage {
  const SettingsScreen({super.key});

  static const String path = '/settings';
  static const String name = 'settings';

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('설정'),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(notificationSettingsServiceProvider.notifier).resetToDefault();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('기본값으로 초기화되었습니다')),
            );
          },
          child: const Text('초기화'),
        ),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsServiceProvider);
    final settingsService = ref.read(notificationSettingsServiceProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 알림 설정 섹션
        const _SectionHeader(title: '알림 설정', icon: Icons.notifications_outlined),
        const SizedBox(height: 8),

        // Warning 레벨
        _NotificationActionTile(
          title: '경고 (Warning)',
          subtitle: '경고 수준의 로그 발생 시',
          color: Colors.orange,
          currentAction: settings.warningAction,
          onChanged: settingsService.setWarningAction,
        ),

        // Error 레벨
        _NotificationActionTile(
          title: '에러 (Error)',
          subtitle: '에러 수준의 로그 발생 시',
          color: Colors.red,
          currentAction: settings.errorAction,
          onChanged: settingsService.setErrorAction,
        ),

        // Critical 레벨
        _NotificationActionTile(
          title: '심각 (Critical)',
          subtitle: '심각한 오류 발생 시',
          color: Colors.purple,
          currentAction: settings.criticalAction,
          onChanged: settingsService.setCriticalAction,
        ),

        const Divider(height: 32),

        // 기타 설정
        const _SectionHeader(title: '기타', icon: Icons.tune),
        const SizedBox(height: 8),

        SwitchListTile(
          title: const Text('헬스체크 알림 표시'),
          subtitle: const Text('주기적인 헬스체크 로그도 알림으로 표시'),
          value: settings.showHealthCheck,
          onChanged: settingsService.setShowHealthCheck,
        ),

        const Divider(height: 32),

        // 앱 정보
        const _SectionHeader(title: '앱 정보', icon: Icons.info_outline),
        const SizedBox(height: 8),

        const ListTile(
          title: Text('버전'),
          trailing: Text('1.0.0'),
        ),
      ],
    );
  }

  @override
  bool get wrapWithSafeArea => false;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _NotificationActionTile extends StatelessWidget {
  const _NotificationActionTile({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.currentAction,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final Color color;
  final NotificationAction currentAction;
  final Future<void> Function(NotificationAction) onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            SegmentedButton<NotificationAction>(
              segments: NotificationAction.values.map((action) {
                return ButtonSegment<NotificationAction>(
                  value: action,
                  label: Text(
                    action.label,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
              selected: {currentAction},
              onSelectionChanged: (selected) {
                onChanged(selected.first);
              },
            ),
          ],
        ),
      ),
    );
  }
}
