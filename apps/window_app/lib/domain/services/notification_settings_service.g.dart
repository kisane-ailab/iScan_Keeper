// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationSettingsService)
const notificationSettingsServiceProvider =
    NotificationSettingsServiceProvider._();

final class NotificationSettingsServiceProvider
    extends
        $NotifierProvider<NotificationSettingsService, NotificationSettings> {
  const NotificationSettingsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSettingsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSettingsServiceHash();

  @$internal
  @override
  NotificationSettingsService create() => NotificationSettingsService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationSettings>(value),
    );
  }
}

String _$notificationSettingsServiceHash() =>
    r'3479603f624798f39aa8107cbd68b93496380334';

abstract class _$NotificationSettingsService
    extends $Notifier<NotificationSettings> {
  NotificationSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NotificationSettings, NotificationSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NotificationSettings, NotificationSettings>,
              NotificationSettings,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
