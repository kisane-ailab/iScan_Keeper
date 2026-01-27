// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataset_realtime_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DatasetRealtimeService)
const datasetRealtimeServiceProvider = DatasetRealtimeServiceProvider._();

final class DatasetRealtimeServiceProvider
    extends $NotifierProvider<DatasetRealtimeService, List<DatasetEntity>> {
  const DatasetRealtimeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'datasetRealtimeServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$datasetRealtimeServiceHash();

  @$internal
  @override
  DatasetRealtimeService create() => DatasetRealtimeService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DatasetEntity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DatasetEntity>>(value),
    );
  }
}

String _$datasetRealtimeServiceHash() =>
    r'80960c5eeb2267692aab1a1c045d4f3f3201e606';

abstract class _$DatasetRealtimeService extends $Notifier<List<DatasetEntity>> {
  List<DatasetEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<DatasetEntity>, List<DatasetEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<DatasetEntity>, List<DatasetEntity>>,
              List<DatasetEntity>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 리뷰 대기 (S2) 데이터셋 개수 (Developer 뱃지용)

@ProviderFor(pendingReviewCount)
const pendingReviewCountProvider = PendingReviewCountProvider._();

/// 리뷰 대기 (S2) 데이터셋 개수 (Developer 뱃지용)

final class PendingReviewCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// 리뷰 대기 (S2) 데이터셋 개수 (Developer 뱃지용)
  const PendingReviewCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingReviewCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingReviewCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return pendingReviewCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$pendingReviewCountHash() =>
    r'60f2e20dad975dfba76431328fbfddc126fe2660';

/// 승인 대기 (S5) 데이터셋 개수 (Admin 뱃지용)

@ProviderFor(pendingApprovalCount)
const pendingApprovalCountProvider = PendingApprovalCountProvider._();

/// 승인 대기 (S5) 데이터셋 개수 (Admin 뱃지용)

final class PendingApprovalCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// 승인 대기 (S5) 데이터셋 개수 (Admin 뱃지용)
  const PendingApprovalCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingApprovalCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingApprovalCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return pendingApprovalCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$pendingApprovalCountHash() =>
    r'dbe85efd9eab463e36305e925cd3a9a81851b226';
