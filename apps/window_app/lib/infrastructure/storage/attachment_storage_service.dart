import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/storage/image_compressor.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';

part 'attachment_storage_service.g.dart';

/// 첨부파일 정보
class AttachmentInfo {
  final String id;
  final String url;
  final String type;
  final String name;
  final int size;

  AttachmentInfo({
    required this.id,
    required this.url,
    required this.type,
    required this.name,
    required this.size,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'type': type,
        'name': name,
        'size': size,
      };

  factory AttachmentInfo.fromJson(Map<String, dynamic> json) => AttachmentInfo(
        id: json['id'] as String,
        url: json['url'] as String,
        type: json['type'] as String,
        name: json['name'] as String,
        size: json['size'] as int,
      );
}

/// 첨부파일 Storage 서비스
///
/// Supabase Storage를 사용하여 이미지를 업로드하고 관리합니다.
/// 버킷: response-attachments
/// 경로: {organization_id}/{response_log_id}/{timestamp}_{uuid}.jpg
class AttachmentStorageService {
  final SupabaseClient _client;
  static const String bucketName = 'response-attachments';
  static const _uuid = Uuid();

  AttachmentStorageService(this._client);

  /// 이미지를 업로드하고 AttachmentInfo를 반환합니다.
  ///
  /// [imageBytes] 이미지 바이트 데이터
  /// [fileName] 원본 파일명
  /// [organizationId] 조직 ID (경로 구성용)
  /// [responseLogId] 대응 로그 ID (경로 구성용, 선택적)
  ///
  /// Returns AttachmentInfo 또는 실패 시 null
  Future<AttachmentInfo?> uploadImage({
    required Uint8List imageBytes,
    required String fileName,
    required String organizationId,
    String? responseLogId,
  }) async {
    try {
      // 파일 확장자 검증
      if (!ImageCompressor.isValidImageExtension(fileName)) {
        logger.w('지원하지 않는 이미지 형식: $fileName');
        return null;
      }

      // 이미지 압축 (항상 JPEG으로 변환됨)
      final compressedBytes = await ImageCompressor.compress(imageBytes, fileName);

      // 고유 파일명 생성 (압축 후 항상 jpg)
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueId = _uuid.v4().substring(0, 8);
      final storagePath = responseLogId != null
          ? '$organizationId/$responseLogId/${timestamp}_$uniqueId.jpg'
          : '$organizationId/temp/${timestamp}_$uniqueId.jpg';

      logger.d('이미지 업로드 시작: $storagePath (${compressedBytes.length} bytes)');

      // Storage 업로드 (JPEG로 통일)
      await _client.storage.from(bucketName).uploadBinary(
            storagePath,
            compressedBytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );

      // Public URL 가져오기
      final publicUrl = _client.storage.from(bucketName).getPublicUrl(storagePath);

      final attachment = AttachmentInfo(
        id: _uuid.v4(),
        url: publicUrl,
        type: 'image',
        name: fileName,
        size: compressedBytes.length,
      );

      logger.i('이미지 업로드 완료: ${attachment.url}');
      return attachment;
    } catch (e) {
      logger.e('이미지 업로드 실패', error: e);
      return null;
    }
  }

  /// 여러 이미지를 업로드합니다.
  Future<List<AttachmentInfo>> uploadImages({
    required List<(Uint8List bytes, String fileName)> images,
    required String organizationId,
    String? responseLogId,
  }) async {
    final results = <AttachmentInfo>[];

    for (final (bytes, fileName) in images) {
      final attachment = await uploadImage(
        imageBytes: bytes,
        fileName: fileName,
        organizationId: organizationId,
        responseLogId: responseLogId,
      );
      if (attachment != null) {
        results.add(attachment);
      }
    }

    return results;
  }

  /// 첨부파일을 삭제합니다.
  Future<bool> deleteAttachment(String url) async {
    try {
      // URL에서 경로 추출
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;

      // storage/v1/object/public/response-attachments/ 이후의 경로
      final bucketIndex = pathSegments.indexOf(bucketName);
      if (bucketIndex == -1 || bucketIndex >= pathSegments.length - 1) {
        logger.w('잘못된 Storage URL: $url');
        return false;
      }

      final storagePath = pathSegments.sublist(bucketIndex + 1).join('/');
      logger.d('첨부파일 삭제: $storagePath');

      await _client.storage.from(bucketName).remove([storagePath]);

      logger.i('첨부파일 삭제 완료: $storagePath');
      return true;
    } catch (e) {
      logger.e('첨부파일 삭제 실패', error: e);
      return false;
    }
  }

  /// 여러 첨부파일을 삭제합니다.
  Future<void> deleteAttachments(List<String> urls) async {
    for (final url in urls) {
      await deleteAttachment(url);
    }
  }
}

/// AttachmentStorageService Provider
@riverpod
AttachmentStorageService attachmentStorageService(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return AttachmentStorageService(client);
}
