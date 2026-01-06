import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum LogLevel {
  info('info', '정보'),
  warning('warning', '경고'),
  error('error', '에러'),
  critical('critical', '심각');

  const LogLevel(this.value, this.label);

  final String value;
  final String label;

  /// 알림이 필요한 레벨인지 (warning 이상)
  bool get needsNotification => index >= LogLevel.warning.index;

  /// 앱을 전면으로 띄워야 하는 레벨인지 (critical)
  bool get needsForeground => this == LogLevel.critical;

  /// 트레이 알림만 필요한 레벨인지 (warning, error)
  bool get needsTrayOnly => this == LogLevel.warning || this == LogLevel.error;

  static LogLevel fromString(String? value) {
    return LogLevel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LogLevel.info,
    );
  }
}
