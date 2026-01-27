import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:window_app/data/models/enums/admin_decision.dart';
import 'package:window_app/data/models/enums/dataset_state.dart';
import 'package:window_app/domain/entities/dataset_entity.dart';

/// 데이터셋 카드 위젯
class DatasetCard extends StatelessWidget {
  const DatasetCard({
    super.key,
    required this.dataset,
    this.isSelected = false,
    this.onTap,
    this.onStartReview,
    this.onCompleteReview,
    this.onSubmitReview,
    this.onApprove,
    this.onReject,
    this.onPublish,
  });

  final DatasetEntity dataset;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onStartReview;
  final VoidCallback? onCompleteReview;
  final VoidCallback? onSubmitReview;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onPublish;

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.activeBlue.withOpacity(0.1)
              : (isDark
                  ? CupertinoColors.systemGrey6.darkColor
                  : CupertinoColors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? CupertinoColors.activeBlue
                : (isDark
                    ? CupertinoColors.systemGrey4.darkColor
                    : CupertinoColors.systemGrey4),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단: 이름 + 상태 뱃지
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dataset.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStateBadge(context),
                  if (dataset.adminDecision != AdminDecision.pending) ...[
                    const SizedBox(width: 4),
                    _buildDecisionBadge(context),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // 설명
              if (dataset.description != null) ...[
                Text(
                  dataset.description!,
                  style: TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              // 메타 정보
              _buildMetaInfo(context),

              // 리뷰어/승인자 정보
              if (dataset.reviewerName != null || dataset.approverName != null) ...[
                const SizedBox(height: 8),
                _buildPersonInfo(context),
              ],

              // 반려 사유
              if (dataset.isRejected && dataset.rejectionReason != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.exclamationmark_triangle,
                        size: 16,
                        color: CupertinoColors.systemRed,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '반려 사유: ${dataset.rejectionReason}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.systemRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // 액션 버튼
              const SizedBox(height: 12),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStateBadge(BuildContext context) {
    final (color, icon) = _getStateColorAndIcon(dataset.state);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            dataset.state.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData) _getStateColorAndIcon(DatasetState state) {
    switch (state) {
      case DatasetState.s2Registered:
        return (CupertinoColors.systemGrey, CupertinoIcons.doc);
      case DatasetState.s3InReview:
        return (CupertinoColors.systemBlue, CupertinoIcons.eye);
      case DatasetState.s4ReviewDone:
        return (CupertinoColors.systemIndigo, CupertinoIcons.checkmark_circle);
      case DatasetState.s5AdminDecision:
        return (CupertinoColors.systemOrange, CupertinoIcons.person_badge_plus);
      case DatasetState.s6Published:
        return (CupertinoColors.systemGreen, CupertinoIcons.checkmark_seal_fill);
    }
  }

  Widget _buildDecisionBadge(BuildContext context) {
    final (color, text) = switch (dataset.adminDecision) {
      AdminDecision.approved => (CupertinoColors.systemGreen, '승인'),
      AdminDecision.rejected => (CupertinoColors.systemRed, '반려'),
      AdminDecision.pending => (CupertinoColors.systemGrey, '대기'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildMetaInfo(BuildContext context) {
    return Row(
      children: [
        Icon(
          CupertinoIcons.folder,
          size: 14,
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            dataset.sourcePath,
            style: TextStyle(
              fontSize: 12,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          CupertinoIcons.clock,
          size: 14,
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
        ),
        const SizedBox(width: 4),
        Text(
          dataset.formattedCreatedAt,
          style: TextStyle(
            fontSize: 12,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonInfo(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: [
        if (dataset.reviewerName != null)
          _buildPersonChip(
            context,
            icon: CupertinoIcons.eye,
            label: '리뷰어',
            name: dataset.reviewerName!,
          ),
        if (dataset.approverName != null)
          _buildPersonChip(
            context,
            icon: CupertinoIcons.person_badge_plus,
            label: '결정자',
            name: dataset.approverName!,
          ),
      ],
    );
  }

  Widget _buildPersonChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String name,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $name',
          style: TextStyle(
            fontSize: 11,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final buttons = <Widget>[];

    // Developer 액션
    if (dataset.state == DatasetState.s2Registered && onStartReview != null) {
      buttons.add(_ActionButton(
        label: '리뷰 시작',
        icon: CupertinoIcons.play_fill,
        color: CupertinoColors.activeBlue,
        onPressed: onStartReview,
      ));
    }

    if (dataset.state == DatasetState.s3InReview && onCompleteReview != null) {
      buttons.add(_ActionButton(
        label: '리뷰 완료',
        icon: CupertinoIcons.checkmark,
        color: CupertinoColors.systemIndigo,
        onPressed: onCompleteReview,
      ));
    }

    if (dataset.state == DatasetState.s4ReviewDone && onSubmitReview != null) {
      buttons.add(_ActionButton(
        label: '리뷰 제출',
        icon: CupertinoIcons.paperplane_fill,
        color: CupertinoColors.systemOrange,
        onPressed: onSubmitReview,
      ));
    }

    // Admin 액션
    if (dataset.state == DatasetState.s5AdminDecision) {
      if (onApprove != null) {
        buttons.add(_ActionButton(
          label: '승인',
          icon: CupertinoIcons.checkmark_circle_fill,
          color: CupertinoColors.systemGreen,
          onPressed: onApprove,
        ));
      }
      if (onReject != null) {
        buttons.add(_ActionButton(
          label: '반려',
          icon: CupertinoIcons.xmark_circle_fill,
          color: CupertinoColors.systemRed,
          onPressed: onReject,
        ));
      }
      if (dataset.isApproved && onPublish != null) {
        buttons.add(_ActionButton(
          label: '퍼블리시',
          icon: CupertinoIcons.cloud_upload_fill,
          color: CupertinoColors.systemGreen,
          onPressed: onPublish,
        ));
      }
    }

    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: buttons,
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minSize: 0,
        color: color,
        borderRadius: BorderRadius.circular(8),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: CupertinoColors.white),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
