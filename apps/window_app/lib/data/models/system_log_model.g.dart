// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SystemLogModel _$SystemLogModelFromJson(Map<String, dynamic> json) =>
    _SystemLogModel(
      id: json['id'] as String,
      source: json['source'] as String,
      description: json['description'] as String?,
      category:
          $enumDecodeNullable(_$LogCategoryEnumMap, json['category']) ??
          LogCategory.event,
      code: json['code'] as String?,
      logLevel:
          $enumDecodeNullable(_$LogLevelEnumMap, json['log_level']) ??
          LogLevel.info,
      environment:
          $enumDecodeNullable(_$EnvironmentEnumMap, json['environment']) ??
          Environment.production,
      payload: json['payload'] as Map<String, dynamic>? ?? const {},
      responseStatus:
          $enumDecodeNullable(
            _$ResponseStatusEnumMap,
            json['response_status'],
            unknownValue: ResponseStatus.unresponded,
          ) ??
          ResponseStatus.unresponded,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      currentResponderId: json['current_responder_id'] as String?,
      currentResponderName: json['current_responder_name'] as String?,
      responseStartedAt: json['response_started_at'] == null
          ? null
          : DateTime.parse(json['response_started_at'] as String),
      organizationId: json['organization_id'] as String?,
      assignedById: json['assigned_by_id'] as String?,
      assignedByName: json['assigned_by_name'] as String?,
      isMuted: json['is_muted'] as bool?,
      site: json['site'] as String?,
      attachments: json['attachments'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$SystemLogModelToJson(_SystemLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': instance.source,
      'description': instance.description,
      'category': _$LogCategoryEnumMap[instance.category]!,
      'code': instance.code,
      'log_level': _$LogLevelEnumMap[instance.logLevel]!,
      'environment': _$EnvironmentEnumMap[instance.environment]!,
      'payload': instance.payload,
      'response_status': _$ResponseStatusEnumMap[instance.responseStatus]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'current_responder_id': instance.currentResponderId,
      'current_responder_name': instance.currentResponderName,
      'response_started_at': instance.responseStartedAt?.toIso8601String(),
      'organization_id': instance.organizationId,
      'assigned_by_id': instance.assignedById,
      'assigned_by_name': instance.assignedByName,
      'is_muted': instance.isMuted,
      'site': instance.site,
      'attachments': instance.attachments,
    };

const _$LogCategoryEnumMap = {
  LogCategory.event: 'event',
  LogCategory.healthCheck: 'health_check',
};

const _$LogLevelEnumMap = {
  LogLevel.info: 'info',
  LogLevel.warning: 'warning',
  LogLevel.error: 'error',
  LogLevel.critical: 'critical',
};

const _$EnvironmentEnumMap = {
  Environment.development: 'development',
  Environment.production: 'production',
};

const _$ResponseStatusEnumMap = {
  ResponseStatus.unresponded: 'unresponded',
  ResponseStatus.inProgress: 'in_progress',
  ResponseStatus.completed: 'completed',
};
