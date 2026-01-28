// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_response_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 현재 로그인한 사용자의 상세 정보 Provider

@ProviderFor(currentUserDetail)
const currentUserDetailProvider = CurrentUserDetailProvider._();

/// 현재 로그인한 사용자의 상세 정보 Provider

final class CurrentUserDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserModel?>,
          UserModel?,
          FutureOr<UserModel?>
        >
    with $FutureModifier<UserModel?>, $FutureProvider<UserModel?> {
  /// 현재 로그인한 사용자의 상세 정보 Provider
  const CurrentUserDetailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserDetailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserDetailHash();

  @$internal
  @override
  $FutureProviderElement<UserModel?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserModel?> create(Ref ref) {
    return currentUserDetail(ref);
  }
}

String _$currentUserDetailHash() => r'53000443b4478d2d18307164467b0e4282b895b4';

/// 같은 조직 사용자 목록 Provider

@ProviderFor(organizationUsers)
const organizationUsersProvider = OrganizationUsersProvider._();

/// 같은 조직 사용자 목록 Provider

final class OrganizationUsersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserModel>>,
          List<UserModel>,
          FutureOr<List<UserModel>>
        >
    with $FutureModifier<List<UserModel>>, $FutureProvider<List<UserModel>> {
  /// 같은 조직 사용자 목록 Provider
  const OrganizationUsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationUsersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationUsersHash();

  @$internal
  @override
  $FutureProviderElement<List<UserModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserModel>> create(Ref ref) {
    return organizationUsers(ref);
  }
}

String _$organizationUsersHash() => r'1e1b316184e4598f3e5fa1aa3685d2ca1768f1ea';

@ProviderFor(EventResponseService)
const eventResponseServiceProvider = EventResponseServiceProvider._();

final class EventResponseServiceProvider
    extends $NotifierProvider<EventResponseService, List<String>> {
  const EventResponseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventResponseServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventResponseServiceHash();

  @$internal
  @override
  EventResponseService create() => EventResponseService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$eventResponseServiceHash() =>
    r'ae432e64fa60d0eda11e5cb6020da2bce9c6b1d2';

abstract class _$EventResponseService extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
