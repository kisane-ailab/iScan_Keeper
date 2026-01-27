// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 워크플로우 ViewModel

@ProviderFor(WorkflowViewModel)
const workflowViewModelProvider = WorkflowViewModelProvider._();

/// 워크플로우 ViewModel
final class WorkflowViewModelProvider
    extends $NotifierProvider<WorkflowViewModel, WorkflowState> {
  /// 워크플로우 ViewModel
  const WorkflowViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workflowViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workflowViewModelHash();

  @$internal
  @override
  WorkflowViewModel create() => WorkflowViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkflowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkflowState>(value),
    );
  }
}

String _$workflowViewModelHash() => r'f2820d78f0cfae18117fb05f9e0e73d712d0cb69';

/// 워크플로우 ViewModel

abstract class _$WorkflowViewModel extends $Notifier<WorkflowState> {
  WorkflowState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WorkflowState, WorkflowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkflowState, WorkflowState>,
              WorkflowState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
