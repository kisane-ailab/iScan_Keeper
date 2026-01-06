import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:window_app/data/models/enums/log_category.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/data/models/enums/response_status.dart';

part 'system_log_model.freezed.dart';
part 'system_log_model.g.dart';

/// 시스템 로그 DTO (DB/API 매핑 전용)
/// 비즈니스 로직은 SystemLogEntity에서 처리
@freezed
abstract class SystemLogModel with _$SystemLogModel {
  const factory SystemLogModel({
    required String id,
    required String source,
    String? description,
    @JsonKey(name: 'category') @Default(LogCategory.event) LogCategory category,
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'log_level') @Default(LogLevel.info) LogLevel logLevel,
    @Default({}) Map<String, dynamic> payload,
    @JsonKey(name: 'response_status', unknownEnumValue: ResponseStatus.unresponded) @Default(ResponseStatus.unresponded) ResponseStatus responseStatus,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'current_responder_id') String? currentResponderId,
    @JsonKey(name: 'current_responder_name') String? currentResponderName,
    @JsonKey(name: 'response_started_at') DateTime? responseStartedAt,
    @JsonKey(name: 'organization_id') String? organizationId,
  }) = _SystemLogModel;

  factory SystemLogModel.fromJson(Map<String, dynamic> json) =>
      _$SystemLogModelFromJson(json);
}
