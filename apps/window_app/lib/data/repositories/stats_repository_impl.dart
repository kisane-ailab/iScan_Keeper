import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/datasources/remote/stats_remote_datasource.dart';
import 'package:window_app/domain/repositories/stats_repository.dart';

part 'stats_repository_impl.g.dart';

/// Stats Repository 구현체
class StatsRepositoryImpl implements StatsRepository {
  final StatsRemoteDatasource _remoteDatasource;

  StatsRepositoryImpl(this._remoteDatasource);

  @override
  Future<Map<String, dynamic>> getUserStats({
    required String userId,
    String? from,
    String? to,
  }) async {
    return await _remoteDatasource.getUserStats(
      userId: userId,
      from: from,
      to: to,
    );
  }

  @override
  Future<Map<String, dynamic>> getDailyStats({
    String? from,
    String? to,
  }) async {
    return await _remoteDatasource.getDailyStats(
      from: from,
      to: to,
    );
  }

  @override
  Future<Map<String, dynamic>> getOverviewStats() async {
    return await _remoteDatasource.getOverviewStats();
  }

  @override
  Future<Map<String, dynamic>> getResponsesByUser({
    required String userId,
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    return await _remoteDatasource.getResponsesByUser(
      userId: userId,
      page: page,
      limit: limit,
      status: status,
    );
  }

  @override
  Future<Map<String, dynamic>> getResponsesByDate({
    int page = 1,
    int limit = 20,
    String? from,
    String? to,
    String? status,
    String? userId,
  }) async {
    return await _remoteDatasource.getResponsesByDate(
      page: page,
      limit: limit,
      from: from,
      to: to,
      status: status,
      userId: userId,
    );
  }
}

/// StatsRepository Provider
@riverpod
StatsRepository statsRepository(Ref ref) {
  final remoteDatasource = ref.watch(statsRemoteDatasourceProvider);
  return StatsRepositoryImpl(remoteDatasource);
}
