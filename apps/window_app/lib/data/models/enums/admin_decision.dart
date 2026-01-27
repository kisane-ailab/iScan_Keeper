import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum AdminDecision {
  pending('pending', '대기'),
  approved('approved', '승인'),
  rejected('rejected', '반려');

  const AdminDecision(this.value, this.label);

  final String value;
  final String label;

  /// 승인되었는지
  bool get isApproved => this == AdminDecision.approved;

  /// 반려되었는지
  bool get isRejected => this == AdminDecision.rejected;

  /// 결정 대기 중인지
  bool get isPending => this == AdminDecision.pending;

  static AdminDecision fromString(String? value) {
    return AdminDecision.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AdminDecision.pending,
    );
  }
}
