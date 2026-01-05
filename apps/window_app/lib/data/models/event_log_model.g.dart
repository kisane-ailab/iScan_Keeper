// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventLogModel _$EventLogModelFromJson(Map<String, dynamic> json) =>
    _EventLogModel(
      id: json['id'] as String,
      source: json['source'] as String,
      eventType: json['event_type'] as String? ?? 'event',
      errorCode: json['error_code'] as String?,
      logLevel: json['log_level'] as String? ?? 'info',
      payload: json['payload'] as Map<String, dynamic>? ?? const {},
      responseStatus: json['response_status'] as String? ?? 'unchecked',
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$EventLogModelToJson(_EventLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': instance.source,
      'event_type': instance.eventType,
      'error_code': instance.errorCode,
      'log_level': instance.logLevel,
      'payload': instance.payload,
      'response_status': instance.responseStatus,
      'created_at': instance.createdAt.toIso8601String(),
    };
