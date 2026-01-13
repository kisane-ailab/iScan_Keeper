// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 인증 서비스

@ProviderFor(AuthService)
const authServiceProvider = AuthServiceProvider._();

/// 인증 서비스
final class AuthServiceProvider
    extends $NotifierProvider<AuthService, AuthState> {
  /// 인증 서비스
  const AuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceHash();

  @$internal
  @override
  AuthService create() => AuthService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authServiceHash() => r'990e09f67f69b3988c871c56edc60b0112f5276a';

/// 인증 서비스

abstract class _$AuthService extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 인증 로딩 상태 Provider

@ProviderFor(isAuthLoading)
const isAuthLoadingProvider = IsAuthLoadingProvider._();

/// 인증 로딩 상태 Provider

final class IsAuthLoadingProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 인증 로딩 상태 Provider
  const IsAuthLoadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isAuthLoadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isAuthLoadingHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isAuthLoading(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isAuthLoadingHash() => r'4452055e43822f1138e5ba927e0b7f5fdcf8481c';

/// 로그인 상태 Provider

@ProviderFor(isLoggedIn)
const isLoggedInProvider = IsLoggedInProvider._();

/// 로그인 상태 Provider

final class IsLoggedInProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 로그인 상태 Provider
  const IsLoggedInProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isLoggedInProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isLoggedInHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isLoggedIn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isLoggedInHash() => r'5b55e3b4c61d788ad9c2cf331ed33cb3b928798c';

/// 현재 사용자 Provider

@ProviderFor(currentUser)
const currentUserProvider = CurrentUserProvider._();

/// 현재 사용자 Provider

final class CurrentUserProvider extends $FunctionalProvider<User?, User?, User?>
    with $Provider<User?> {
  /// 현재 사용자 Provider
  const CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  User? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(User? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<User?>(value),
    );
  }
}

String _$currentUserHash() => r'e041fc373917d3fc20b5fd72b2879dcc3ced5546';

/// 이메일 인증 완료 여부 Provider

@ProviderFor(isEmailConfirmed)
const isEmailConfirmedProvider = IsEmailConfirmedProvider._();

/// 이메일 인증 완료 여부 Provider

final class IsEmailConfirmedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 이메일 인증 완료 여부 Provider
  const IsEmailConfirmedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isEmailConfirmedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isEmailConfirmedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isEmailConfirmed(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isEmailConfirmedHash() => r'4e02871e1c7cba0305ba71c6ef4df3650819d34b';

/// 인증 대기 중인 이메일 (회원가입 직후 사용)

@ProviderFor(PendingVerificationEmail)
const pendingVerificationEmailProvider = PendingVerificationEmailProvider._();

/// 인증 대기 중인 이메일 (회원가입 직후 사용)
final class PendingVerificationEmailProvider
    extends $NotifierProvider<PendingVerificationEmail, String?> {
  /// 인증 대기 중인 이메일 (회원가입 직후 사용)
  const PendingVerificationEmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingVerificationEmailProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingVerificationEmailHash();

  @$internal
  @override
  PendingVerificationEmail create() => PendingVerificationEmail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pendingVerificationEmailHash() =>
    r'1fb394d9f1d0998cf89483e211be3f4ef76fcf56';

/// 인증 대기 중인 이메일 (회원가입 직후 사용)

abstract class _$PendingVerificationEmail extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
