import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum LogCategory {
  event('event', '이벤트'),
  healthCheck('health_check', '헬스체크');

  const LogCategory(this.value, this.label);

  final String value;
  final String label;

  bool get isHealthCheck => this == LogCategory.healthCheck;
  bool get isEvent => this == LogCategory.event;

  static LogCategory fromString(String? value) {
    return LogCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LogCategory.event,
    );
  }
}
