import 'package:dio/dio.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/infrastructure/network/interceptors/error_interceptor.dart';
import 'package:window_app/infrastructure/network/interceptors/logging_interceptor.dart';

part 'dio_provider.g.dart';

/// Dio Provider
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Windows 네이티브 HTTP 클라이언트 사용 (SSL 문제 해결)
  dio.httpClientAdapter = NativeAdapter();

  dio.interceptors.addAll([
    loggingInterceptor(),
    ErrorInterceptor(),
  ]);

  return dio;
}
