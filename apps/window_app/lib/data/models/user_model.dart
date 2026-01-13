import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:window_app/data/models/enums/user_role.dart';
import 'package:window_app/data/models/enums/user_status.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// 사용자 모델
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    @Default(UserStatus.offline) UserStatus status,
    @Default(UserRole.member) UserRole role,
    @JsonKey(name: 'organization_id') String? organizationId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// UserModel 확장
extension UserModelX on UserModel {
  /// 관리자인지
  bool get isAdmin => role.isAdmin;

  /// 책임자 이상인지
  bool get isManagerOrAbove => role.isManagerOrAbove;

  /// 온라인인지
  bool get isOnline => status == UserStatus.online;

  /// 할당 가능한지 (온라인인 경우)
  bool get canBeAssigned => status == UserStatus.online;

  /// 상태 색상 (UI용)
  String get statusColorHex {
    switch (status) {
      case UserStatus.online:
        return '#34C759'; // green
      case UserStatus.offline:
        return '#8E8E93'; // gray
    }
  }
}
