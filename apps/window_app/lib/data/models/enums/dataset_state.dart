import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum DatasetState {
  s2Registered('s2_registered', 'DB 등록'),
  s3InReview('s3_in_review', '리뷰 중'),
  s4ReviewDone('s4_review_done', '리뷰 완료'),
  s5AdminDecision('s5_admin_decision', '관리자 결정'),
  s6Published('s6_published', '퍼블리시');

  const DatasetState(this.value, this.label);

  final String value;
  final String label;

  /// Developer가 행동할 수 있는 상태인지 (S2: 리뷰 시작, S3: 리뷰 진행)
  bool get canDeveloperAct =>
      this == DatasetState.s2Registered || this == DatasetState.s3InReview;

  /// Admin이 행동할 수 있는 상태인지 (S5: 승인/반려/퍼블리시)
  bool get canAdminAct => this == DatasetState.s5AdminDecision;

  /// 리뷰 대기 상태인지 (Developer 뱃지용)
  bool get isPendingReview => this == DatasetState.s2Registered;

  /// 승인 대기 상태인지 (Admin 뱃지용)
  bool get isPendingApproval => this == DatasetState.s5AdminDecision;

  /// 완료된 상태인지
  bool get isCompleted => this == DatasetState.s6Published;

  /// 리뷰 진행 중인지
  bool get isInReview => this == DatasetState.s3InReview;

  static DatasetState fromString(String? value) {
    return DatasetState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DatasetState.s2Registered,
    );
  }
}
