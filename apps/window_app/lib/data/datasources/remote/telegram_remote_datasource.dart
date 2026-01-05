import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/network/dio/dio_provider.dart';

part 'telegram_remote_datasource.g.dart';

/// Telegram Remote DataSource
abstract class TelegramRemoteDataSource {
  static const String baseUrl = 'https://api.telegram.org';
  static const String token = '7522648066:AAGjwQBys6Arqv8_xB462tea2OvhQxla57M';

  /// GET /bot{token}/getUpdates
  Future<dynamic> getUpdates(String token);
}

/// Telegram Remote DataSource 구현체 (curl 사용)
/// Windows SSL 문제로 curl.exe 사용
class TelegramRemoteDataSourceCurlImpl implements TelegramRemoteDataSource {
  TelegramRemoteDataSourceCurlImpl();

  @override
  Future<dynamic> getUpdates(String token) async {
    final url = '${TelegramRemoteDataSource.baseUrl}/bot$token/getUpdates';
    logger.d('API 호출: $url');

    if (Platform.isWindows) {
      return await _fetchWithCurl(url);
    } else {
      return await _fetchWithCurlUnix(url);
    }
  }

  /// Windows curl.exe를 사용한 HTTP GET (SSL 검증 무시)
  Future<dynamic> _fetchWithCurl(String url) async {
    final result = await Process.run(
      'curl.exe',
      ['-s', '-k', url], // -k: SSL 인증서 검증 무시
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );

    if (result.exitCode != 0) {
      logger.e('curl 실패: ${result.stderr}');
      throw Exception('Failed to fetch: ${result.stderr}');
    }

    final jsonStr = (result.stdout as String).trim();

    if (jsonStr.isEmpty) {
      throw Exception('Empty response from server');
    }

    return jsonDecode(jsonStr);
  }

  /// curl을 사용한 HTTP GET (macOS/Linux)
  Future<dynamic> _fetchWithCurlUnix(String url) async {
    final result = await Process.run(
      'curl',
      ['-s', '-k', url],
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );

    if (result.exitCode != 0) {
      throw Exception('Failed to fetch: ${result.stderr}');
    }

    return jsonDecode(result.stdout as String);
  }
}

/// Telegram Remote DataSource 구현체 (Dio 사용)
/// SSL 문제가 해결되면 이 구현체로 전환
class TelegramRemoteDataSourceDioImpl implements TelegramRemoteDataSource {
  final Dio _dio;

  TelegramRemoteDataSourceDioImpl(this._dio);

  @override
  Future<dynamic> getUpdates(String token) async {
    final response = await _dio.get(
      '${TelegramRemoteDataSource.baseUrl}/bot$token/getUpdates',
    );
    return response.data;
  }
}

/// TelegramRemoteDataSource Provider (curl 사용)
@riverpod
TelegramRemoteDataSource telegramRemoteDataSource(Ref ref) {
  // curl 사용 (SSL 문제 우회)
  // return TelegramRemoteDataSourceCurlImpl();

  // Dio 사용 (SSL 문제 해결 후 주석 해제)
  final dio = ref.watch(dioProvider);
  return TelegramRemoteDataSourceDioImpl(dio);
}
