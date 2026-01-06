import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';

part 'user_remote_datasource.g.dart';

/// User Remote DataSource 인터페이스
abstract class UserRemoteDatasource {
  /// 사용자 목록 조회
  Future<List<Map<String, dynamic>>> getUsers({String? status});

  /// 사용자 상세 조회
  Future<Map<String, dynamic>?> getUser(String userId);

  /// 대기중인 사용자 목록
  Future<List<Map<String, dynamic>>> getAvailableUsers();

  /// 사용자 상태 변경
  Future<Map<String, dynamic>> updateStatus({
    required String userId,
    required String status,
  });

  /// 사용자 생성
  Future<Map<String, dynamic>> createUser({
    required String id,
    required String name,
    required String email,
  });
}

/// User Remote DataSource 구현체
class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final SupabaseClient _client;

  UserRemoteDatasourceImpl(this._client);

  @override
  Future<List<Map<String, dynamic>>> getUsers({String? status}) async {
    var query = _client.from('users').select();

    if (status != null && ['available', 'busy', 'offline'].contains(status)) {
      query = query.eq('status', status);
    }

    final result = await query.order('name');
    return List<Map<String, dynamic>>.from(result);
  }

  @override
  Future<Map<String, dynamic>?> getUser(String userId) async {
    return await _client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableUsers() async {
    final result = await _client
        .from('users')
        .select()
        .eq('status', 'available')
        .order('name');

    return List<Map<String, dynamic>>.from(result);
  }

  @override
  Future<Map<String, dynamic>> updateStatus({
    required String userId,
    required String status,
  }) async {
    logger.d('사용자 상태 변경: userId=$userId, status=$status');

    final result = await _client
        .from('users')
        .update({'status': status})
        .eq('id', userId)
        .select()
        .single();

    logger.i('사용자 상태 변경 완료: $userId → $status');
    return result;
  }

  @override
  Future<Map<String, dynamic>> createUser({
    required String id,
    required String name,
    required String email,
  }) async {
    logger.d('사용자 생성: name=$name, email=$email');

    final result = await _client.from('users').insert({
      'id': id,
      'name': name,
      'email': email,
      'status': 'offline',
    }).select().single();

    logger.i('사용자 생성 완료: $id');
    return result;
  }
}

/// UserRemoteDatasource Provider
@riverpod
UserRemoteDatasource userRemoteDatasource(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return UserRemoteDatasourceImpl(client);
}
