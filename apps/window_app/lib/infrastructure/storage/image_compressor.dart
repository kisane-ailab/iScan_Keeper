import 'dart:typed_data';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';

/// 이미지 압축 유틸리티
///
/// 설정:
/// - 최대 크기: 1920x1080
/// - JPEG 품질: 80%
/// - 목표 파일 크기: 500KB 이하
class ImageCompressor {
  static const int maxWidth = 1920;
  static const int maxHeight = 1080;
  static const int quality = 80;
  static const int targetSizeKb = 500;

  /// 이미지 바이트를 압축합니다.
  ///
  /// [imageBytes] 원본 이미지 바이트
  /// [fileName] 파일명 (확장자 추출용)
  ///
  /// Returns 압축된 이미지 바이트
  static Future<Uint8List> compress(Uint8List imageBytes, String fileName) async {
    try {
      logger.d('이미지 압축 시작: ${imageBytes.length} bytes');

      // 이미 목표 크기 이하면 압축 생략
      if (imageBytes.length <= targetSizeKb * 1024) {
        logger.d('이미지가 이미 목표 크기 이하: ${imageBytes.length} bytes');
        return imageBytes;
      }

      final input = ImageFile(
        rawBytes: imageBytes,
        filePath: fileName,
      );

      final config = Configuration(
        outputType: ImageOutputType.jpg,
        quality: quality,
      );

      final output = await compressor.compress(ImageFileConfiguration(
        input: input,
        config: config,
      ));

      logger.i('이미지 압축 완료: ${imageBytes.length} → ${output.rawBytes.length} bytes '
          '(${(output.rawBytes.length / imageBytes.length * 100).toStringAsFixed(1)}%)');

      return output.rawBytes;
    } catch (e) {
      logger.e('이미지 압축 실패', error: e);
      // 압축 실패 시 원본 반환
      return imageBytes;
    }
  }

  /// 이미지 파일 확장자가 유효한지 확인합니다.
  static bool isValidImageExtension(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext);
  }

  /// MIME 타입을 반환합니다.
  static String getMimeType(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      default:
        return 'image/jpeg';
    }
  }
}
