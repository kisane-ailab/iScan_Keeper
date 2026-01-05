import 'package:dio/dio.dart';

/// 에러 처리 인터셉터
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 에러 타입별 처리
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        // 타임아웃 에러 처리
        break;
      case DioExceptionType.badResponse:
        // HTTP 에러 응답 처리
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          // 인증 에러 처리
        } else if (statusCode == 403) {
          // 권한 에러 처리
        } else if (statusCode == 404) {
          // Not Found 처리
        } else if (statusCode != null && statusCode >= 500) {
          // 서버 에러 처리
        }
        break;
      case DioExceptionType.cancel:
        // 요청 취소됨
        break;
      case DioExceptionType.connectionError:
        // 네트워크 연결 에러
        break;
      default:
        break;
    }

    handler.next(err);
  }
}
