import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/presentation/pages/main/06_muted/muted_view_model.dart';

class MutedScreen extends ConsumerWidget {
  const MutedScreen({super.key});

  static const String path = '/muted';
  static const String name = 'muted';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mutedViewModelProvider);
    final viewModel = ref.read(mutedViewModelProvider.notifier);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          // 헤더
          CupertinoSliverNavigationBar(
            largeTitle: const Text('숨긴 알림'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => viewModel.loadMutedLogs(),
              child: const Icon(CupertinoIcons.refresh),
            ),
          ),
          // 콘텐츠
          if (state.isLoading)
            const SliverFillRemaining(
              child: Center(child: CupertinoActivityIndicator()),
            )
          else if (state.error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_triangle,
                      size: 48,
                      color: CupertinoColors.systemRed.resolveFrom(context),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.error!,
                      style: TextStyle(
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      onPressed: () => viewModel.loadMutedLogs(),
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
            )
          else if (state.logs.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.bell_slash,
                      size: 64,
                      color: CupertinoColors.systemGrey.resolveFrom(context),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '숨긴 알림이 없습니다',
                      style: TextStyle(
                        fontSize: 17,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '알림을 숨기면 여기에 표시됩니다',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final log = state.logs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _MutedLogCard(
                        log: log,
                        onUnmute: () async {
                          final success = await viewModel.unmuteLogs(log.id);
                          if (success && context.mounted) {
                            _showToast(context, '알림이 다시 표시됩니다');
                          }
                        },
                      ),
                    );
                  },
                  childCount: state.logs.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: CupertinoColors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message,
                style: const TextStyle(color: CupertinoColors.white),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}

/// 숨긴 로그 카드
class _MutedLogCard extends StatelessWidget {
  const _MutedLogCard({
    required this.log,
    required this.onUnmute,
  });

  final SystemLogEntity log;
  final VoidCallback onUnmute;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator.resolveFrom(context),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 로그 레벨 아이콘
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getLevelColor(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getLevelIcon(),
                color: _getLevelColor(context),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // 로그 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getLevelColor(context).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          log.logLevel.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getLevelColor(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          log.source,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (log.code != null)
                    Text(
                      log.code!,
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    log.formattedCreatedAt,
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                    ),
                  ),
                ],
              ),
            ),
            // 숨김 해제 버튼
            CupertinoButton(
              padding: const EdgeInsets.all(8),
              onPressed: onUnmute,
              child: Icon(
                CupertinoIcons.eye,
                color: CupertinoColors.systemBlue.resolveFrom(context),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getLevelIcon() {
    switch (log.logLevel.name) {
      case 'critical':
        return CupertinoIcons.exclamationmark_octagon_fill;
      case 'error':
        return CupertinoIcons.xmark_circle_fill;
      case 'warning':
        return CupertinoIcons.exclamationmark_triangle_fill;
      default:
        return CupertinoIcons.info_circle_fill;
    }
  }

  Color _getLevelColor(BuildContext context) {
    switch (log.logLevel.name) {
      case 'critical':
        return CupertinoColors.systemPurple.resolveFrom(context);
      case 'error':
        return CupertinoColors.systemRed.resolveFrom(context);
      case 'warning':
        return CupertinoColors.systemOrange.resolveFrom(context);
      default:
        return CupertinoColors.systemBlue.resolveFrom(context);
    }
  }
}
