import 'package:json_annotation/json_annotation.dart';

/// 사용자 상태 enum
/// DB의 user_status와 매핑
@JsonEnum(valueField: 'value')
enum UserStatus {
  available('available', '대기중'),
  busy('busy', '대응중'),
  offline('offline', '오프라인');

  const UserStatus(this.value, this.label);

  final String value;
  final String label;

  /// 대기중인지
  bool get isAvailable => this == UserStatus.available;

  /// 대응중인지
  bool get isBusy => this == UserStatus.busy;

  /// 오프라인인지
  bool get isOffline => this == UserStatus.offline;
}
