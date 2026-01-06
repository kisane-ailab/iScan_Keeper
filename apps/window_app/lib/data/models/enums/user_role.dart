import 'package:json_annotation/json_annotation.dart';

/// 사용자 역할 enum
/// DB의 user_role과 매핑
@JsonEnum(valueField: 'value')
enum UserRole {
  admin('admin', '관리자'),
  manager('manager', '책임자'),
  member('member', '일반');

  const UserRole(this.value, this.label);

  final String value;
  final String label;

  /// 관리자인지
  bool get isAdmin => this == UserRole.admin;

  /// 책임자 이상인지
  bool get isManagerOrAbove => this == UserRole.admin || this == UserRole.manager;
}
