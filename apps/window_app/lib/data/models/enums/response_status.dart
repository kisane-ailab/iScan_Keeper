import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum ResponseStatus {
  unresponded('unresponded', '미대응'),
  inProgress('in_progress', '대응중'),
  completed('completed', '완료');

  const ResponseStatus(this.value, this.label);

  final String value;
  final String label;

  static ResponseStatus fromString(String? value) {
    return ResponseStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ResponseStatus.unresponded,
    );
  }
}
