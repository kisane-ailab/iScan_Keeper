import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:window_app/data/models/enums/event_type.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/data/models/enums/response_status.dart';

part 'event_log_model.freezed.dart';
part 'event_log_model.g.dart';

@freezed
abstract class EventLogModel with _$EventLogModel {
  const factory EventLogModel({
    required String id,
    required String source,
    @JsonKey(name: 'event_type') @Default(EventType.event) EventType eventType,
    @JsonKey(name: 'error_code') String? errorCode,
    @JsonKey(name: 'log_level') @Default(LogLevel.info) LogLevel logLevel,
    @Default({}) Map<String, dynamic> payload,
    @JsonKey(name: 'response_status') @Default(ResponseStatus.unchecked) ResponseStatus responseStatus,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // 대응자 정보
    @JsonKey(name: 'current_responder_id') String? currentResponderId,
    @JsonKey(name: 'current_responder_name') String? currentResponderName,
    @JsonKey(name: 'response_started_at') DateTime? responseStartedAt,
  }) = _EventLogModel;

  const EventLogModel._();

  /// 헬스체크인지
  bool get isHealthCheck => eventType.isHealthCheck;

  /// 이벤트인지
  bool get isEvent => eventType.isEvent;

  /// 대응 중인지
  bool get isBeingResponded => responseStatus == ResponseStatus.inProgress && currentResponderId != null;

  /// 미확인 상태인지
  bool get isUnchecked => responseStatus == ResponseStatus.unchecked;

  /// 알림이 필요한지 (warning 이상 + unchecked)
  bool get needsNotification =>
      logLevel.needsNotification && responseStatus == ResponseStatus.unchecked;

  /// 앱을 전면으로 띄워야 하는지
  bool get needsForeground => logLevel.needsForeground;

  /// 트레이 알림만 필요한지
  bool get needsTrayOnly => logLevel.needsTrayOnly;

  /// critical이고 미확인인지
  bool get isCriticalUnchecked =>
      logLevel == LogLevel.critical && responseStatus == ResponseStatus.unchecked;

  factory EventLogModel.fromJson(Map<String, dynamic> json) =>
      _$EventLogModelFromJson(json);
}
