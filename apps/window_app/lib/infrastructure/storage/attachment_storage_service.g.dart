// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_storage_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AttachmentStorageService Provider

@ProviderFor(attachmentStorageService)
const attachmentStorageServiceProvider = AttachmentStorageServiceProvider._();

/// AttachmentStorageService Provider

final class AttachmentStorageServiceProvider
    extends
        $FunctionalProvider<
          AttachmentStorageService,
          AttachmentStorageService,
          AttachmentStorageService
        >
    with $Provider<AttachmentStorageService> {
  /// AttachmentStorageService Provider
  const AttachmentStorageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attachmentStorageServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attachmentStorageServiceHash();

  @$internal
  @override
  $ProviderElement<AttachmentStorageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AttachmentStorageService create(Ref ref) {
    return attachmentStorageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttachmentStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttachmentStorageService>(value),
    );
  }
}

String _$attachmentStorageServiceHash() =>
    r'a9019fed20ad3d647eaf5be73ee23cd71c5e70c2';
