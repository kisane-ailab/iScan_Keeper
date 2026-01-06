// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventLogModel _$EventLogModelFromJson(Map<String, dynamic> json) =>
    _EventLogModel(
      id: json['id'] as String,
      source: json['source'] as String,
      eventType:
          $enumDecodeNullable(_$EventTypeEnumMap, json['event_type']) ??
          EventType.event,
      errorCode: json['error_code'] as String?,
      logLevel:
          $enumDecodeNullable(_$LogLevelEnumMap, json['log_level']) ??
          LogLevel.info,
      payload: json['payload'] as Map<String, dynamic>? ?? const {},
      responseStatus:
          $enumDecodeNullable(
            _$ResponseStatusEnumMap,
            json['response_status'],
          ) ??
          ResponseStatus.unchecked,
      createdAt: DateTime.parse(json['created_at'] as String),
      currentResponderId: json['current_responder_id'] as String?,
      currentResponderName: json['current_responder_name'] as String?,
      responseStartedAt: json['response_started_at'] == null
          ? null
          : DateTime.parse(json['response_started_at'] as String),
    );

Map<String, dynamic> _$EventLogModelToJson(_EventLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': instance.source,
      'event_type': _$EventTypeEnumMap[instance.eventType]!,
      'error_code': instance.errorCode,
      'log_level': _$LogLevelEnumMap[instance.logLevel]!,
      'payload': instance.payload,
      'response_status': _$ResponseStatusEnumMap[instance.responseStatus]!,
      'created_at': instance.createdAt.toIso8601String(),
      'current_responder_id': instance.currentResponderId,
      'current_responder_name': instance.currentResponderName,
      'response_started_at': instance.responseStartedAt?.toIso8601String(),
    };

const _$EventTypeEnumMap = {
  EventType.event: 'event',
  EventType.healthCheck: 'health_check',
};

const _$LogLevelEnumMap = {
  LogLevel.info: 'info',
  LogLevel.warning: 'warning',
  LogLevel.error: 'error',
  LogLevel.critical: 'critical',
};

const _$ResponseStatusEnumMap = {
  ResponseStatus.unchecked: 'unchecked',
  ResponseStatus.inProgress: 'in_progress',
  ResponseStatus.completed: 'completed',
};
