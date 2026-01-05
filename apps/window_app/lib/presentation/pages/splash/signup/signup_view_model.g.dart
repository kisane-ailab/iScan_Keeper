// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 회원가입 ViewModel

@ProviderFor(SignupViewModel)
const signupViewModelProvider = SignupViewModelProvider._();

/// 회원가입 ViewModel
final class SignupViewModelProvider
    extends $NotifierProvider<SignupViewModel, SignupState> {
  /// 회원가입 ViewModel
  const SignupViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupViewModelHash();

  @$internal
  @override
  SignupViewModel create() => SignupViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignupState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignupState>(value),
    );
  }
}

String _$signupViewModelHash() => r'11d1321b978ed02c7ccc5ce93e3b01515edf2187';

/// 회원가입 ViewModel

abstract class _$SignupViewModel extends $Notifier<SignupState> {
  SignupState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SignupState, SignupState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SignupState, SignupState>,
              SignupState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
