// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_rule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MuteRule _$MuteRuleFromJson(Map<String, dynamic> json) => _MuteRule(
  id: json['id'] as String,
  source: json['source'] as String?,
  code: json['code'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$MuteRuleToJson(_MuteRule instance) => <String, dynamic>{
  'id': instance.id,
  'source': instance.source,
  'code': instance.code,
  'createdAt': instance.createdAt.toIso8601String(),
};
