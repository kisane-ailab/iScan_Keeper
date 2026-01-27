import 'package:window_app/data/models/dataset_model.dart';
import 'package:window_app/data/models/enums/admin_decision.dart';
import 'package:window_app/data/models/enums/dataset_state.dart';
import 'package:window_app/data/models/enums/environment.dart';

/// 데이터셋 엔티티
/// - Model에서 시스템 데이터를 비즈니스 관점으로 해석
/// - 로컬 시간 변환 지원
/// - 워크플로우 비즈니스 로직 포함
class DatasetEntity {
  final String id;
  final String name;
  final String? description;
  final String sourcePath;
  final Map<String, dynamic> metadata;

  // 워크플로우 상태
  final DatasetState state;
  final AdminDecision adminDecision;
  final String? rejectionReason;

  // 리뷰어 정보
  final String? reviewerId;
  final String? reviewerName;
  final DateTime? _reviewStartedAtUtc;
  final DateTime? _reviewCompletedAtUtc;
  final String? reviewNote;

  // 승인자 정보
  final String? approverId;
  final String? approverName;
  final DateTime? _approvedAtUtc;

  // 퍼블리시 정보
  final DateTime? _publishedAtUtc;
  final String? publishedPath;

  // 공통 필드
  final Environment environment;
  final String? organizationId;
  final DateTime _createdAtUtc;
  final DateTime? _updatedAtUtc;

  DatasetEntity({
    required this.id,
    required this.name,
    this.description,
    required this.sourcePath,
    required this.metadata,
    required this.state,
    required this.adminDecision,
    this.rejectionReason,
    this.reviewerId,
    this.reviewerName,
    DateTime? reviewStartedAt,
    DateTime? reviewCompletedAt,
    this.reviewNote,
    this.approverId,
    this.approverName,
    DateTime? approvedAt,
    DateTime? publishedAt,
    this.publishedPath,
    required this.environment,
    this.organizationId,
    required DateTime createdAt,
    DateTime? updatedAt,
  })  : _reviewStartedAtUtc = reviewStartedAt,
        _reviewCompletedAtUtc = reviewCompletedAt,
        _approvedAtUtc = approvedAt,
        _publishedAtUtc = publishedAt,
        _createdAtUtc = createdAt,
        _updatedAtUtc = updatedAt;

  /// Model에서 Entity 생성
  factory DatasetEntity.fromModel(DatasetModel model) {
    return DatasetEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      sourcePath: model.sourcePath,
      metadata: model.metadata,
      state: model.state,
      adminDecision: model.adminDecision,
      rejectionReason: model.rejectionReason,
      reviewerId: model.reviewerId,
      reviewerName: model.reviewerName,
      reviewStartedAt: model.reviewStartedAt,
      reviewCompletedAt: model.reviewCompletedAt,
      reviewNote: model.reviewNote,
      approverId: model.approverId,
      approverName: model.approverName,
      approvedAt: model.approvedAt,
      publishedAt: model.publishedAt,
      publishedPath: model.publishedPath,
      environment: model.environment,
      organizationId: model.organizationId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  // ===== 로컬 시간 변환 =====

  /// 생성 시간 (로컬 시간)
  DateTime get createdAt => _createdAtUtc.toLocal();

  /// 업데이트 시간 (로컬 시간) - 없으면 생성 시간 반환
  DateTime get updatedAt => (_updatedAtUtc ?? _createdAtUtc).toLocal();

  /// 리뷰 시작 시간 (로컬 시간)
  DateTime? get reviewStartedAt => _reviewStartedAtUtc?.toLocal();

  /// 리뷰 완료 시간 (로컬 시간)
  DateTime? get reviewCompletedAt => _reviewCompletedAtUtc?.toLocal();

  /// 승인/반려 시간 (로컬 시간)
  DateTime? get approvedAt => _approvedAtUtc?.toLocal();

  /// 퍼블리시 시간 (로컬 시간)
  DateTime? get publishedAt => _publishedAtUtc?.toLocal();

  // ===== UTC 원본 =====

  DateTime get createdAtUtc => _createdAtUtc;
  DateTime? get updatedAtUtc => _updatedAtUtc;
  DateTime? get reviewStartedAtUtc => _reviewStartedAtUtc;
  DateTime? get reviewCompletedAtUtc => _reviewCompletedAtUtc;
  DateTime? get approvedAtUtc => _approvedAtUtc;
  DateTime? get publishedAtUtc => _publishedAtUtc;

  // ===== 포맷된 시간 문자열 =====

  /// 생성 시간 포맷 (MM/dd HH:mm)
  String get formattedCreatedAt => _formatDateTime(createdAt);

  /// 업데이트 시간 포맷 (MM/dd HH:mm)
  String get formattedUpdatedAt => _formatDateTime(updatedAt);

  /// 리뷰 시작 시간 포맷 (MM/dd HH:mm)
  String? get formattedReviewStartedAt {
    final time = reviewStartedAt;
    if (time == null) return null;
    return _formatDateTime(time);
  }

  /// 리뷰 완료 시간 포맷 (MM/dd HH:mm)
  String? get formattedReviewCompletedAt {
    final time = reviewCompletedAt;
    if (time == null) return null;
    return _formatDateTime(time);
  }

  /// 승인 시간 포맷 (MM/dd HH:mm)
  String? get formattedApprovedAt {
    final time = approvedAt;
    if (time == null) return null;
    return _formatDateTime(time);
  }

  /// 퍼블리시 시간 포맷 (MM/dd HH:mm)
  String? get formattedPublishedAt {
    final time = publishedAt;
    if (time == null) return null;
    return _formatDateTime(time);
  }

  String _formatDateTime(DateTime dt) {
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$month/$day $hour:$minute';
  }

  // ===== 비즈니스 로직 =====

  /// 개발 환경인지
  bool get isDevelopment => environment.isDevelopment;

  /// 운영 환경인지
  bool get isProduction => environment.isProduction;

  /// Developer가 행동할 수 있는 상태인지
  bool get canDeveloperAct => state.canDeveloperAct;

  /// Admin이 행동할 수 있는 상태인지
  bool get canAdminAct => state.canAdminAct;

  /// 리뷰 대기 상태인지 (Developer 뱃지용)
  bool get isPendingReview => state.isPendingReview;

  /// 승인 대기 상태인지 (Admin 뱃지용)
  bool get isPendingApproval => state.isPendingApproval;

  /// 완료된 상태인지
  bool get isCompleted => state.isCompleted;

  /// 리뷰 진행 중인지
  bool get isInReview => state.isInReview;

  /// 승인됨
  bool get isApproved => adminDecision.isApproved;

  /// 반려됨
  bool get isRejected => adminDecision.isRejected;

  /// 재리뷰가 필요한지 (반려 후 S3 상태)
  bool get needsReReview => state.isInReview && adminDecision.isRejected;

  /// 퍼블리시 가능한지 (승인됨 + S5 상태)
  bool get canPublish => state == DatasetState.s5AdminDecision && isApproved;

  /// 상태 요약 문자열
  String get statusSummary {
    if (isRejected && state.isInReview) {
      return '재리뷰 필요';
    }
    if (isApproved && !isCompleted) {
      return '퍼블리시 대기';
    }
    return state.label;
  }

  /// 상세 정보 요약 문자열
  String get detailInfo {
    final buffer = StringBuffer();
    buffer.write('이름: $name');

    if (reviewerName != null) {
      buffer.write(' | 리뷰어: $reviewerName');
    }

    if (approverName != null) {
      buffer.write(' | 결정자: $approverName');
    }

    return buffer.toString();
  }

  /// Entity → JSON (캐시 저장용)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'source_path': sourcePath,
      'metadata': metadata,
      'state': state.value,
      'admin_decision': adminDecision.value,
      'rejection_reason': rejectionReason,
      'reviewer_id': reviewerId,
      'reviewer_name': reviewerName,
      'review_started_at': _reviewStartedAtUtc?.toIso8601String(),
      'review_completed_at': _reviewCompletedAtUtc?.toIso8601String(),
      'review_note': reviewNote,
      'approver_id': approverId,
      'approver_name': approverName,
      'approved_at': _approvedAtUtc?.toIso8601String(),
      'published_at': _publishedAtUtc?.toIso8601String(),
      'published_path': publishedPath,
      'environment': environment.value,
      'organization_id': organizationId,
      'created_at': _createdAtUtc.toIso8601String(),
      'updated_at': _updatedAtUtc?.toIso8601String(),
    };
  }
}
