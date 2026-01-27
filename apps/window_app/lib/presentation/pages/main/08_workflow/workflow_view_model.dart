import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/models/enums/admin_decision.dart';
import 'package:window_app/data/models/enums/dataset_state.dart';
import 'package:window_app/domain/entities/dataset_entity.dart';
import 'package:window_app/domain/services/dataset_realtime_service.dart';

part 'workflow_view_model.freezed.dart';
part 'workflow_view_model.g.dart';

/// 워크플로우 필터 모드
enum WorkflowFilterMode {
  all('전체'),
  pendingReview('리뷰 대기'),
  inReview('리뷰 중'),
  reviewDone('리뷰 완료'),
  pendingApproval('승인 대기'),
  approved('승인됨'),
  rejected('반려됨'),
  published('퍼블리시');

  final String label;
  const WorkflowFilterMode(this.label);
}

/// 워크플로우 화면 상태
@freezed
abstract class WorkflowState with _$WorkflowState {
  const factory WorkflowState({
    @Default([]) List<DatasetEntity> datasets,
    @Default(WorkflowFilterMode.all) WorkflowFilterMode filterMode,
    @Default(0) int pendingReviewCount,
    @Default(0) int pendingApprovalCount,
    @Default(false) bool isLoading,
    String? selectedDatasetId,
  }) = _WorkflowState;
}

extension WorkflowStateX on WorkflowState {
  /// 선택된 데이터셋
  DatasetEntity? get selectedDataset {
    if (selectedDatasetId == null) return null;
    try {
      return datasets.firstWhere((d) => d.id == selectedDatasetId);
    } catch (_) {
      return null;
    }
  }
}

/// 워크플로우 ViewModel
@riverpod
class WorkflowViewModel extends _$WorkflowViewModel {
  WorkflowFilterMode _filterMode = WorkflowFilterMode.all;
  String? _selectedDatasetId;

  @override
  WorkflowState build() {
    final allDatasets = ref.watch(datasetRealtimeServiceProvider);

    // 필터 적용
    final filteredDatasets = _applyFilter(allDatasets);

    // 카운트 계산
    final pendingReviewCount = allDatasets.where((d) => d.isPendingReview).length;
    final pendingApprovalCount = allDatasets.where((d) => d.isPendingApproval).length;

    return WorkflowState(
      datasets: filteredDatasets,
      filterMode: _filterMode,
      pendingReviewCount: pendingReviewCount,
      pendingApprovalCount: pendingApprovalCount,
      selectedDatasetId: _selectedDatasetId,
    );
  }

  /// 필터 적용
  List<DatasetEntity> _applyFilter(List<DatasetEntity> datasets) {
    switch (_filterMode) {
      case WorkflowFilterMode.all:
        return datasets;
      case WorkflowFilterMode.pendingReview:
        return datasets.where((d) => d.state == DatasetState.s2Registered).toList();
      case WorkflowFilterMode.inReview:
        return datasets.where((d) => d.state == DatasetState.s3InReview).toList();
      case WorkflowFilterMode.reviewDone:
        return datasets.where((d) => d.state == DatasetState.s4ReviewDone).toList();
      case WorkflowFilterMode.pendingApproval:
        return datasets.where((d) => d.state == DatasetState.s5AdminDecision).toList();
      case WorkflowFilterMode.approved:
        return datasets.where((d) => d.isApproved).toList();
      case WorkflowFilterMode.rejected:
        return datasets.where((d) => d.isRejected).toList();
      case WorkflowFilterMode.published:
        return datasets.where((d) => d.state == DatasetState.s6Published).toList();
    }
  }

  /// 필터 모드 설정
  void setFilterMode(WorkflowFilterMode mode) {
    _filterMode = mode;
    ref.invalidateSelf();
  }

  /// 데이터셋 선택
  void selectDataset(String? id) {
    _selectedDatasetId = id;
    ref.invalidateSelf();
  }

  /// 새로고침
  Future<void> refresh() async {
    await ref.read(datasetRealtimeServiceProvider.notifier).refresh();
  }

  /// 리뷰 시작 (S2 → S3)
  Future<void> startReview(String datasetId, String reviewerId, String reviewerName) async {
    await ref
        .read(datasetRealtimeServiceProvider.notifier)
        .startReview(datasetId, reviewerId, reviewerName);
  }

  /// 리뷰 완료 (S3 → S4)
  Future<void> completeReview(String datasetId, {String? reviewNote}) async {
    await ref
        .read(datasetRealtimeServiceProvider.notifier)
        .completeReview(datasetId, reviewNote: reviewNote);
  }

  /// 리뷰 제출 (S4 → S5)
  Future<void> submitReview(String datasetId) async {
    await ref.read(datasetRealtimeServiceProvider.notifier).submitReview(datasetId);
  }

  /// 승인 (S5에서)
  Future<void> approve(String datasetId, String approverId, String approverName) async {
    await ref
        .read(datasetRealtimeServiceProvider.notifier)
        .approve(datasetId, approverId, approverName);
  }

  /// 반려 (S5 → S3)
  Future<void> reject(
    String datasetId,
    String approverId,
    String approverName,
    String reason,
  ) async {
    await ref
        .read(datasetRealtimeServiceProvider.notifier)
        .reject(datasetId, approverId, approverName, reason);
  }

  /// 퍼블리시 (S5 → S6)
  Future<void> publish(String datasetId, String publishedPath) async {
    await ref.read(datasetRealtimeServiceProvider.notifier).publish(datasetId, publishedPath);
  }
}
