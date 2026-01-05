import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_log_model.freezed.dart';
part 'event_log_model.g.dart';

@freezed
abstract class EventLogModel with _$EventLogModel {
  const factory EventLogModel({
    required String id,
    required String source,
    @JsonKey(name: 'event_type') @Default('event') String eventType,
    @JsonKey(name: 'error_code') String? errorCode,
    @JsonKey(name: 'log_level') @Default('info') String logLevel,
    @Default({}) Map<String, dynamic> payload,
    @JsonKey(name: 'response_status') @Default('unchecked') String responseStatus,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _EventLogModel;

  const EventLogModel._();

  bool get isHealthCheck => eventType == 'health_check';
  bool get isEvent => eventType == 'event';

  factory EventLogModel.fromJson(Map<String, dynamic> json) =>
      _$EventLogModelFromJson(json);
}
