import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_app/domain/services/event_response_service.dart';
import 'package:window_app/presentation/pages/main/08_workflow/widgets/dataset_card.dart';
import 'package:window_app/presentation/pages/main/08_workflow/workflow_view_model.dart';

class WorkflowScreen extends HookConsumerWidget {
  const WorkflowScreen({super.key});

  static const String path = '/workflow';
  static const String name = 'workflow';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workflowViewModelProvider);
    final viewModel = ref.read(workflowViewModelProvider.notifier);
    final currentUserAsync = ref.watch(currentUserDetailProvider);
    final currentUser = currentUserAsync.when(
      data: (user) => user,
      loading: () => null,
      error: (_, __) => null,
    );

    final isRefreshing = useState(false);

    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      appBar: AppBar(
        title: const Text('데이터셋 워크플로우'),
        actions: [
          // 새로고침 버튼
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: isRefreshing.value
                ? null
                : () async {
                    isRefreshing.value = true;
                    await viewModel.refresh();
                    isRefreshing.value = false;
                  },
            child: isRefreshing.value
                ? const CupertinoActivityIndicator()
                : const Icon(CupertinoIcons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 필터 바
          _FilterBar(
            currentFilter: state.filterMode,
            pendingReviewCount: state.pendingReviewCount,
            pendingApprovalCount: state.pendingApprovalCount,
            onFilterChanged: viewModel.setFilterMode,
          ),

          // 데이터셋 목록
          Expanded(
            child: state.datasets.isEmpty
                ? _EmptyState(filterMode: state.filterMode)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.datasets.length,
                    itemBuilder: (context, index) {
                      final dataset = state.datasets[index];
                      return DatasetCard(
                        dataset: dataset,
                        isSelected: dataset.id == state.selectedDatasetId,
                        onTap: () => viewModel.selectDataset(
                          dataset.id == state.selectedDatasetId ? null : dataset.id,
                        ),
                        onStartReview: currentUser != null
                            ? () => _handleStartReview(
                                  context,
                                  viewModel,
                                  dataset.id,
                                  currentUser.id,
                                  currentUser.name,
                                )
                            : null,
                        onCompleteReview: () => _handleCompleteReview(
                          context,
                          viewModel,
                          dataset.id,
                        ),
                        onSubmitReview: () => _handleSubmitReview(
                          context,
                          viewModel,
                          dataset.id,
                        ),
                        onApprove: currentUser != null
                            ? () => _handleApprove(
                                  context,
                                  viewModel,
                                  dataset.id,
                                  currentUser.id,
                                  currentUser.name,
                                )
                            : null,
                        onReject: currentUser != null
                            ? () => _handleReject(
                                  context,
                                  viewModel,
                                  dataset.id,
                                  currentUser.id,
                                  currentUser.name,
                                )
                            : null,
                        onPublish: () => _handlePublish(
                          context,
                          viewModel,
                          dataset.id,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleStartReview(
    BuildContext context,
    WorkflowViewModel viewModel,
    String datasetId,
    String reviewerId,
    String reviewerName,
  ) async {
    try {
      await viewModel.startReview(datasetId, reviewerId, reviewerName);
      if (context.mounted) {
        _showSnackBar(context, '리뷰를 시작했습니다.');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, '리뷰 시작 실패: $e');
      }
    }
  }

  Future<void> _handleCompleteReview(
    BuildContext context,
    WorkflowViewModel viewModel,
    String datasetId,
  ) async {
    final note = await _showInputDialog(
      context,
      title: '리뷰 완료',
      placeholder: '리뷰 노트 (선택사항)',
    );

    if (note == null) return;

    try {
      await viewModel.completeReview(
        datasetId,
        reviewNote: note.isNotEmpty ? note : null,
      );
      if (context.mounted) {
        _showSnackBar(context, '리뷰를 완료했습니다.');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, '리뷰 완료 실패: $e');
      }
    }
  }

  Future<void> _handleSubmitReview(
    BuildContext context,
    WorkflowViewModel viewModel,
    String datasetId,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: '리뷰 제출',
      message: '리뷰를 제출하시겠습니까? 관리자 승인 대기 상태로 변경됩니다.',
    );

    if (confirmed != true) return;

    try {
      await viewModel.submitReview(datasetId);
      if (context.mounted) {
        _showSnackBar(context, '리뷰를 제출했습니다.');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, '리뷰 제출 실패: $e');
      }
    }
  }

  Future<void> _handleApprove(
    BuildContext context,
    WorkflowViewModel viewModel,
    String datasetId,
    String approverId,
    String approverName,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: '승인',
      message: '이 데이터셋을 승인하시겠습니까?',
    );

    if (confirmed != true) return;

    try {
      await viewModel.approve(datasetId, approverId, approverName);
      if (context.mounted) {
        _showSnackBar(context, '승인되었습니다.');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, '승인 실패: $e');
      }
    }
  }

  Future<void> _handleReject(
    BuildContext context,
    WorkflowViewModel viewModel,
    String datasetId,
    String approverId,
    String approverName,
  ) async {
    final reason = await _showInputDialog(
      context,
      title: '반려',
      placeholder: '반려 사유를 입력하세요',
      required: true,
    );

    if (reason == null || reason.isEmpty) return;

    try {
      await viewModel.reject(datasetId, approverId, approverName, reason);
      if (context.mounted) {
        _showSnackBar(context, '반려되었습니다.');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, '반려 실패: $e');
      }
    }
  }

  Future<void> _handlePublish(
    BuildContext context,
    WorkflowViewModel viewModel,
    String datasetId,
  ) async {
    final path = await _showInputDialog(
      context,
      title: '퍼블리시',
      placeholder: '퍼블리시 경로를 입력하세요',
      required: true,
    );

    if (path == null || path.isEmpty) return;

    try {
      await viewModel.publish(datasetId, path);
      if (context.mounted) {
        _showSnackBar(context, '퍼블리시되었습니다.');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, '퍼블리시 실패: $e');
      }
    }
  }

  Future<String?> _showInputDialog(
    BuildContext context, {
    required String title,
    required String placeholder,
    bool required = false,
  }) async {
    final controller = TextEditingController();

    return showCupertinoDialog<String>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            maxLines: 3,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              if (required && controller.text.isEmpty) {
                return;
              }
              Navigator.of(context).pop(controller.text);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(message),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CupertinoColors.systemRed,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// 필터 바 위젯
class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.currentFilter,
    required this.pendingReviewCount,
    required this.pendingApprovalCount,
    required this.onFilterChanged,
  });

  final WorkflowFilterMode currentFilter;
  final int pendingReviewCount;
  final int pendingApprovalCount;
  final ValueChanged<WorkflowFilterMode> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: WorkflowFilterMode.values.map((mode) {
            final isSelected = mode == currentFilter;
            final badgeCount = switch (mode) {
              WorkflowFilterMode.pendingReview => pendingReviewCount,
              WorkflowFilterMode.pendingApproval => pendingApprovalCount,
              _ => 0,
            };

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FilterChip(
                label: mode.label,
                isSelected: isSelected,
                badgeCount: badgeCount,
                onTap: () => onFilterChanged(mode),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// 필터 칩 위젯
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.badgeCount,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.activeBlue
              : CupertinoColors.systemGrey5.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? CupertinoColors.white
                    : CupertinoColors.label.resolveFrom(context),
              ),
            ),
            if (badgeCount > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? CupertinoColors.white.withOpacity(0.3)
                      : CupertinoColors.systemRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? CupertinoColors.white
                        : CupertinoColors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 빈 상태 위젯
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filterMode});

  final WorkflowFilterMode filterMode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.doc_text_search,
            size: 64,
            color: CupertinoColors.systemGrey.resolveFrom(context),
          ),
          const SizedBox(height: 16),
          Text(
            filterMode == WorkflowFilterMode.all
                ? '데이터셋이 없습니다'
                : '${filterMode.label} 상태의 데이터셋이 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}
