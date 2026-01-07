// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_updater_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 앱 업데이터 서비스

@ProviderFor(AppUpdaterService)
const appUpdaterServiceProvider = AppUpdaterServiceProvider._();

/// 앱 업데이터 서비스
final class AppUpdaterServiceProvider
    extends $NotifierProvider<AppUpdaterService, AppUpdateState> {
  /// 앱 업데이터 서비스
  const AppUpdaterServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUpdaterServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appUpdaterServiceHash();

  @$internal
  @override
  AppUpdaterService create() => AppUpdaterService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppUpdateState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppUpdateState>(value),
    );
  }
}

String _$appUpdaterServiceHash() => r'4deacdf621c5e0804b9170c3e0b439acdaccc580';

/// 앱 업데이터 서비스

abstract class _$AppUpdaterService extends $Notifier<AppUpdateState> {
  AppUpdateState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppUpdateState, AppUpdateState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppUpdateState, AppUpdateState>,
              AppUpdateState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
