// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_rule_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Mute 규칙 서비스
/// 규칙 목록을 관리하고, 로그가 규칙에 매칭되는지 확인

@ProviderFor(MuteRuleService)
const muteRuleServiceProvider = MuteRuleServiceProvider._();

/// Mute 규칙 서비스
/// 규칙 목록을 관리하고, 로그가 규칙에 매칭되는지 확인
final class MuteRuleServiceProvider
    extends $NotifierProvider<MuteRuleService, List<MuteRule>> {
  /// Mute 규칙 서비스
  /// 규칙 목록을 관리하고, 로그가 규칙에 매칭되는지 확인
  const MuteRuleServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'muteRuleServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$muteRuleServiceHash();

  @$internal
  @override
  MuteRuleService create() => MuteRuleService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MuteRule> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MuteRule>>(value),
    );
  }
}

String _$muteRuleServiceHash() => r'348ccb835ae162e2cf5d4e53b0d4ac8f4f515887';

/// Mute 규칙 서비스
/// 규칙 목록을 관리하고, 로그가 규칙에 매칭되는지 확인

abstract class _$MuteRuleService extends $Notifier<List<MuteRule>> {
  List<MuteRule> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<MuteRule>, List<MuteRule>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<MuteRule>, List<MuteRule>>,
              List<MuteRule>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
