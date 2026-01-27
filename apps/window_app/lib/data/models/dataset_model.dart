import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:window_app/data/models/enums/admin_decision.dart';
import 'package:window_app/data/models/enums/dataset_state.dart';
import 'package:window_app/data/models/enums/environment.dart';

part 'dataset_model.freezed.dart';
part 'dataset_model.g.dart';

/// 데이터셋 DTO (DB/API 매핑 전용)
/// 비즈니스 로직은 DatasetEntity에서 처리
@freezed
abstract class DatasetModel with _$DatasetModel {
  const factory DatasetModel({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'source_path') required String sourcePath,
    @Default({}) Map<String, dynamic> metadata,

    // 워크플로우 상태
    @JsonKey(name: 'state') @Default(DatasetState.s2Registered) DatasetState state,
    @JsonKey(name: 'admin_decision') @Default(AdminDecision.pending) AdminDecision adminDecision,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,

    // 리뷰어 정보
    @JsonKey(name: 'reviewer_id') String? reviewerId,
    @JsonKey(name: 'reviewer_name') String? reviewerName,
    @JsonKey(name: 'review_started_at') DateTime? reviewStartedAt,
    @JsonKey(name: 'review_completed_at') DateTime? reviewCompletedAt,
    @JsonKey(name: 'review_note') String? reviewNote,

    // 승인자 정보
    @JsonKey(name: 'approver_id') String? approverId,
    @JsonKey(name: 'approver_name') String? approverName,
    @JsonKey(name: 'approved_at') DateTime? approvedAt,

    // 퍼블리시 정보
    @JsonKey(name: 'published_at') DateTime? publishedAt,
    @JsonKey(name: 'published_path') String? publishedPath,

    // 공통 필드
    @JsonKey(name: 'environment') @Default(Environment.production) Environment environment,
    @JsonKey(name: 'organization_id') String? organizationId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _DatasetModel;

  factory DatasetModel.fromJson(Map<String, dynamic> json) =>
      _$DatasetModelFromJson(json);
}
