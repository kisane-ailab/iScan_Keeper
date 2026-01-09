import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum Environment {
  development('development', '개발'),
  production('production', '운영');

  const Environment(this.value, this.label);

  final String value;
  final String label;

  bool get isDevelopment => this == Environment.development;
  bool get isProduction => this == Environment.production;

  static Environment fromString(String? value) {
    return Environment.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Environment.production,
    );
  }
}
