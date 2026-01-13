import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/datasources/remote/user_remote_datasource.dart';
import 'package:window_app/domain/repositories/user_repository.dart';

part 'user_repository_impl.g.dart';

/// User Repository 구현체
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource _remoteDatasource;

  UserRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<Map<String, dynamic>>> getUsers({String? status}) async {
    return await _remoteDatasource.getUsers(status: status);
  }

  @override
  Future<Map<String, dynamic>?> getUser(String userId) async {
    return await _remoteDatasource.getUser(userId);
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableUsers() async {
    return await _remoteDatasource.getAvailableUsers();
  }

  @override
  Future<List<Map<String, dynamic>>> getUsersByOrganization(String organizationId) async {
    return await _remoteDatasource.getUsersByOrganization(organizationId);
  }

  @override
  Future<Map<String, dynamic>> updateStatus({
    required String userId,
    required String status,
  }) async {
    return await _remoteDatasource.updateStatus(
      userId: userId,
      status: status,
    );
  }

  @override
  Future<Map<String, dynamic>> createUser({
    required String id,
    required String name,
    required String email,
  }) async {
    return await _remoteDatasource.createUser(
      id: id,
      name: name,
      email: email,
    );
  }
}

/// UserRepository Provider
@riverpod
UserRepository userRepository(Ref ref) {
  final remoteDatasource = ref.watch(userRemoteDatasourceProvider);
  return UserRepositoryImpl(remoteDatasource);
}
