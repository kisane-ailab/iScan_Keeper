import 'package:json_annotation/json_annotation.dart';

/// 사용자 상태 enum
/// DB의 user_status와 매핑
@JsonEnum(valueField: 'value')
enum UserStatus {
  online('online', '온라인'),
  offline('offline', '오프라인');

  const UserStatus(this.value, this.label);

  final String value;
  final String label;

  /// 온라인인지
  bool get isOnline => this == UserStatus.online;

  /// 오프라인인지
  bool get isOffline => this == UserStatus.offline;
}
