// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_status_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 로그 읽음 상태 관리 서비스
/// - 상세보기를 열면 읽음 처리
/// - 로컬 저장소에 읽은 로그 ID 목록 저장

@ProviderFor(ReadStatusService)
const readStatusServiceProvider = ReadStatusServiceProvider._();

/// 로그 읽음 상태 관리 서비스
/// - 상세보기를 열면 읽음 처리
/// - 로컬 저장소에 읽은 로그 ID 목록 저장
final class ReadStatusServiceProvider
    extends $NotifierProvider<ReadStatusService, ReadStatusState> {
  /// 로그 읽음 상태 관리 서비스
  /// - 상세보기를 열면 읽음 처리
  /// - 로컬 저장소에 읽은 로그 ID 목록 저장
  const ReadStatusServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readStatusServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readStatusServiceHash();

  @$internal
  @override
  ReadStatusService create() => ReadStatusService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReadStatusState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReadStatusState>(value),
    );
  }
}

String _$readStatusServiceHash() => r'592d186664e7d5f3010df6304981c3dbeaed30c1';

/// 로그 읽음 상태 관리 서비스
/// - 상세보기를 열면 읽음 처리
/// - 로컬 저장소에 읽은 로그 ID 목록 저장

abstract class _$ReadStatusService extends $Notifier<ReadStatusState> {
  ReadStatusState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ReadStatusState, ReadStatusState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReadStatusState, ReadStatusState>,
              ReadStatusState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
