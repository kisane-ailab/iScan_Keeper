// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MachineLogModel _$MachineLogModelFromJson(Map<String, dynamic> json) =>
    _MachineLogModel(
      id: json['id'] as String,
      ipAddress: json['ip_address'] as String,
      portNumber: (json['port_number'] as num).toInt(),
      statusCode: (json['status_code'] as num).toInt(),
      responseStatus: json['response_status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$MachineLogModelToJson(_MachineLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ip_address': instance.ipAddress,
      'port_number': instance.portNumber,
      'status_code': instance.statusCode,
      'response_status': instance.responseStatus,
      'created_at': instance.createdAt.toIso8601String(),
    };
