// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => _NotificationSettings(
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
  showHealthCheck: json['showHealthCheck'] as bool? ?? false,
);

Map<String, dynamic> _$NotificationSettingsToJson(
  _NotificationSettings instance,
) => <String, dynamic>{
  'warningAction': _$NotificationActionEnumMap[instance.warningAction]!,
  'errorAction': _$NotificationActionEnumMap[instance.errorAction]!,
  'criticalAction': _$NotificationActionEnumMap[instance.criticalAction]!,
  'showHealthCheck': instance.showHealthCheck,
};

const _$NotificationActionEnumMap = {
  NotificationAction.none: 'none',
  NotificationAction.trayOnly: 'trayOnly',
  NotificationAction.foreground: 'foreground',
  NotificationAction.alwaysOnTop: 'alwaysOnTop',
};
