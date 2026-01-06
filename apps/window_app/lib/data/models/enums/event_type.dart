import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum EventType {
  event('event', '이벤트'),
  healthCheck('health_check', '헬스체크');

  const EventType(this.value, this.label);

  final String value;
  final String label;

  bool get isHealthCheck => this == EventType.healthCheck;
  bool get isEvent => this == EventType.event;

  static EventType fromString(String? value) {
    return EventType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EventType.event,
    );
  }
}
