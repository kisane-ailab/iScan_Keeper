import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_rule_model.freezed.dart';
part 'mute_rule_model.g.dart';

/// Mute 규칙 모델
/// source, code 중 null인 필드는 "모든 값 매칭" (와일드카드)
@freezed
abstract class MuteRule with _$MuteRule {
  const MuteRule._();

  const factory MuteRule({
    required String id,
    /// 출처 (null이면 모든 source 매칭)
    String? source,
    /// 에러/이벤트 코드 (null이면 모든 code 매칭)
    String? code,
    /// 생성 시간
    required DateTime createdAt,
  }) = _MuteRule;

  factory MuteRule.fromJson(Map<String, dynamic> json) =>
      _$MuteRuleFromJson(json);

  /// 로그가 이 규칙에 매칭되는지 확인
  bool matches({required String logSource, String? logCode}) {
    // source가 설정되어 있으면 일치해야 함
    if (source != null && source != logSource) {
      return false;
    }
    // code가 설정되어 있으면 일치해야 함
    if (code != null && code != logCode) {
      return false;
    }
    return true;
  }

  /// 규칙 설명 문자열
  String get description {
    final parts = <String>[];
    if (source != null) {
      parts.add('출처: $source');
    }
    if (code != null) {
      parts.add('코드: $code');
    }
    if (parts.isEmpty) {
      return '모든 알림';
    }
    return parts.join(', ');
  }
}
