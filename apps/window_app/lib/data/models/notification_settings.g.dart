// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnvironmentNotificationSettings _$EnvironmentNotificationSettingsFromJson(
  Map<String, dynamic> json,
) => _EnvironmentNotificationSettings(
  warningAction:
      $enumDecodeNullable(_$NotificationActionEnumMap, json['warningAction']) ??
      NotificationAction.trayOnly,
  errorAction:
      $enumDecodeNullable(_$NotificationActionEnumMap, json['errorAction']) ??
      NotificationAction.foreground,
  criticalAction:
      $enumDecodeNullable(
        _$NotificationActionEnumMap,
        json['criticalAction'],
      ) ??
      NotificationAction.alwaysOnTop,
);

Map<String, dynamic> _$EnvironmentNotificationSettingsToJson(
  _EnvironmentNotificationSettings instance,
) => <String, dynamic>{
  'warningAction': _$NotificationActionEnumMap[instance.warningAction]!,
  'errorAction': _$NotificationActionEnumMap[instance.errorAction]!,
  'criticalAction': _$NotificationActionEnumMap[instance.criticalAction]!,
};

const _$NotificationActionEnumMap = {
  NotificationAction.none: 'none',
  NotificationAction.trayOnly: 'trayOnly',
  NotificationAction.foreground: 'foreground',
  NotificationAction.alwaysOnTop: 'alwaysOnTop',
};

_NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => _NotificationSettings(
  production: json['production'] == null
      ? const EnvironmentNotificationSettings()
      : EnvironmentNotificationSettings.fromJson(
          json['production'] as Map<String, dynamic>,
        ),
  development: json['development'] == null
      ? const EnvironmentNotificationSettings(
          warningAction: NotificationAction.none,
          errorAction: NotificationAction.trayOnly,
          criticalAction: NotificationAction.foreground,
        )
      : EnvironmentNotificationSettings.fromJson(
          json['development'] as Map<String, dynamic>,
        ),
  showHealthCheck: json['showHealthCheck'] as bool? ?? false,
);

Map<String, dynamic> _$NotificationSettingsToJson(
  _NotificationSettings instance,
) => <String, dynamic>{
  'production': instance.production,
  'development': instance.development,
  'showHealthCheck': instance.showHealthCheck,
};
