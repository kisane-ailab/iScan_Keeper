import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_app/data/models/dataset_model.dart';
import 'package:window_app/domain/entities/dataset_entity.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';
import 'package:window_app/infrastructure/supabase/supabase_client.dart';

part 'dataset_realtime_service.g.dart';

@Riverpod(keepAlive: true)
class DatasetRealtimeService extends _$DatasetRealtimeService {
  RealtimeChannel? _channel;

  // 페이지네이션 상태
  static const int _pageSize = 50;
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  // 로컬 캐시
  static const String _cacheBoxName = 'datasets_realtime_cache';
  static const String _cacheKey = 'datasets';
  Box<dynamic>? _cacheBox;

  Logger get _logger => ref.read(appLoggerProvider);

  /// 더 불러올 데이터가 있는지
  bool get hasMoreData => _hasMore;

  /// 추가 로딩 중인지
  bool get isLoadingMore => _isLoadingMore;

  @override
  List<DatasetEntity> build() {
    _initAndLoad();

    ref.onDispose(() {
      _channel?.unsubscribe();
    });

    return [];
  }

  /// 초기화 및 로드 (캐시 → 서버)
  Future<void> _initAndLoad() async {
    // 1. 캐시에서 먼저 로드 (즉시 표시)
    await _loadFromCache();

    // 2. 리얼타임 리스닝 시작
    _startListening();

    // 3. 서버에서 최신 데이터 fetch
    await _fetchInitialDatasets();
  }

  /// 로컬 캐시에서 로드
  Future<void> _loadFromCache() async {
    _logger.i('=== 데이터셋 캐시 로드 시작 ===');
    try {
      _cacheBox = await Hive.openBox(_cacheBoxName);
      final cached = _cacheBox?.get(_cacheKey);

      if (cached != null && cached is List) {
        _logger.i('캐시에서 ${cached.length}건 발견');
        final datasets = <DatasetEntity>[];
        int parseFailCount = 0;

        for (final item in cached) {
          try {
            if (item is Map) {
              final map = _deepConvertMap(item);
              final model = DatasetModel.fromJson(map);
              datasets.add(DatasetEntity.fromModel(model));
            }
          } catch (e) {
            parseFailCount++;
            _logger.w('캐시 항목 파싱 실패', error: e);
          }
        }

        if (parseFailCount > 0) {
          _logger.w('캐시 파싱 실패: $parseFailCount건');
        }

        if (datasets.isNotEmpty) {
          datasets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          state = datasets;
          _logger.i('캐시에서 ${datasets.length}건 로드 완료');
        }
      } else {
        _logger.i('캐시 데이터 없음');
      }
    } catch (e) {
      _logger.w('캐시 로드 실패', error: e);
    }
  }

  /// Hive에서 가져온 Map을 재귀적으로 변환
  Map<String, dynamic> _deepConvertMap(Map map) {
    return map.map((key, value) {
      if (value is Map) {
        return MapEntry(key.toString(), _deepConvertMap(value));
      } else if (value is List) {
        return MapEntry(key.toString(), _deepConvertList(value));
      }
      return MapEntry(key.toString(), value);
    });
  }

  List<dynamic> _deepConvertList(List list) {
    return list.map((item) {
      if (item is Map) {
        return _deepConvertMap(item);
      } else if (item is List) {
        return _deepConvertList(item);
      }
      return item;
    }).toList();
  }

  /// 로컬 캐시에 저장
  Future<void> _saveToCache() async {
    try {
      if (_cacheBox == null) {
        _cacheBox = await Hive.openBox(_cacheBoxName);
      }

      final jsonList = state.map((entity) => entity.toJson()).toList();
      await _cacheBox?.put(_cacheKey, jsonList);
      await _cacheBox?.flush();

      _logger.i('데이터셋 캐시 저장 완료: ${jsonList.length}건');
    } catch (e) {
      _logger.w('캐시 저장 실패', error: e);
    }
  }

  /// 기존 데이터셋 조회
  Future<void> _fetchInitialDatasets() async {
    try {
      _logger.i('=== 데이터셋 서버 조회 시작 ===');

      _offset = 0;
      _hasMore = true;

      final client = ref.read(supabaseClientProvider);

      final response = await client
          .from('datasets')
          .select()
          .order('created_at', ascending: false)
          .range(0, _pageSize - 1);

      _hasMore = response.length >= _pageSize;
      _offset = response.length;

      _logger.i('데이터셋 조회 완료: ${response.length}건');

      final allDatasets = <DatasetEntity>[];

      for (final record in response) {
        try {
          final model = DatasetModel.fromJson(record);
          allDatasets.add(DatasetEntity.fromModel(model));
        } catch (e) {
          _logger.e('데이터셋 파싱 오류', error: e);
        }
      }

      // 캐시 데이터와 머지
      final fetchedIds = allDatasets.map((e) => e.id).toSet();
      final cachedOldDatasets =
          state.where((dataset) => !fetchedIds.contains(dataset.id)).toList();
      final mergedDatasets = [...allDatasets, ...cachedOldDatasets];

      mergedDatasets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = mergedDatasets;

      _logger.i('데이터셋 머지 완료: 총 ${mergedDatasets.length}건');

      await _saveToCache();
    } catch (e) {
      _logger.e('데이터셋 조회 실패', error: e);
    }
  }

  /// 추가 데이터셋 로딩 (무한 스크롤)
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;

    try {
      final client = ref.read(supabaseClientProvider);

      final response = await client
          .from('datasets')
          .select()
          .order('created_at', ascending: false)
          .range(_offset, _offset + _pageSize - 1);

      _hasMore = response.length >= _pageSize;
      _offset += response.length;

      final newDatasets = <DatasetEntity>[];

      for (final record in response) {
        try {
          final model = DatasetModel.fromJson(record);
          newDatasets.add(DatasetEntity.fromModel(model));
        } catch (e) {
          _logger.e('데이터셋 파싱 오류', error: e);
        }
      }

      if (newDatasets.isNotEmpty) {
        final existingIds = state.map((e) => e.id).toSet();
        final uniqueNewDatasets =
            newDatasets.where((d) => !existingIds.contains(d.id)).toList();

        final allDatasets = [...state, ...uniqueNewDatasets];
        allDatasets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        state = allDatasets;

        await _saveToCache();

        _logger.i('추가 데이터셋 로딩 완료: ${uniqueNewDatasets.length}건 추가 (총 ${state.length}건)');
      }
    } catch (e) {
      _logger.e('추가 데이터셋 로딩 실패', error: e);
    } finally {
      _isLoadingMore = false;
    }
  }

  void _startListening() {
    final client = ref.read(supabaseClientProvider);

    _channel = client
        .channel('datasets_realtime')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'datasets',
          callback: (payload) {
            _handleNewDataset(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'datasets',
          callback: (payload) {
            _handleUpdatedDataset(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'datasets',
          callback: (payload) {
            _handleDeletedDataset(payload.oldRecord);
          },
        )
        .subscribe();

    _logger.i('데이터셋 리얼타임 리스닝 시작');
  }

  void _handleNewDataset(Map<String, dynamic> record) async {
    try {
      final model = DatasetModel.fromJson(record);
      final entity = DatasetEntity.fromModel(model);

      state = [entity, ...state];
      await _saveToCache();

      _logger.i('새 데이터셋 추가: ${entity.name}');
    } catch (e) {
      _logger.e('데이터셋 파싱 오류', error: e);
    }
  }

  void _handleUpdatedDataset(Map<String, dynamic> record) async {
    try {
      final model = DatasetModel.fromJson(record);
      final entity = DatasetEntity.fromModel(model);

      final newState = state.map((d) {
        if (d.id == entity.id) {
          return entity;
        }
        return d;
      }).toList();

      state = newState;
      await _saveToCache();

      _logger.i('데이터셋 업데이트: ${entity.name} (${entity.state.label})');
    } catch (e) {
      _logger.e('데이터셋 업데이트 파싱 오류', error: e);
    }
  }

  void _handleDeletedDataset(Map<String, dynamic> oldRecord) async {
    try {
      final deletedId = oldRecord['id'] as String?;
      if (deletedId == null) {
        _logger.w('삭제된 데이터셋 ID를 찾을 수 없음');
        return;
      }

      final newState = state.where((d) => d.id != deletedId).toList();
      state = newState;
      await _saveToCache();

      _logger.i('데이터셋 삭제: $deletedId');
    } catch (e) {
      _logger.e('데이터셋 삭제 처리 오류', error: e);
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    _logger.i('데이터셋 수동 새로고침 시작');
    await _fetchInitialDatasets();
  }

  // ===== 워크플로우 액션 =====

  /// 리뷰 시작 (S2 → S3)
  Future<void> startReview(String datasetId, String reviewerId, String reviewerName) async {
    try {
      final client = ref.read(supabaseClientProvider);

      await client.functions.invoke(
        'datasets/$datasetId/start-review',
        method: HttpMethod.post,
        body: {
          'reviewer_id': reviewerId,
          'reviewer_name': reviewerName,
        },
      );

      _logger.i('리뷰 시작: $datasetId by $reviewerName');
    } catch (e) {
      _logger.e('리뷰 시작 실패', error: e);
      rethrow;
    }
  }

  /// 리뷰 완료 (S3 → S4)
  Future<void> completeReview(String datasetId, {String? reviewNote}) async {
    try {
      final client = ref.read(supabaseClientProvider);

      await client.functions.invoke(
        'datasets/$datasetId/complete-review',
        method: HttpMethod.post,
        body: {
          if (reviewNote != null) 'review_note': reviewNote,
        },
      );

      _logger.i('리뷰 완료: $datasetId');
    } catch (e) {
      _logger.e('리뷰 완료 실패', error: e);
      rethrow;
    }
  }

  /// 리뷰 제출 (S4 → S5)
  Future<void> submitReview(String datasetId) async {
    try {
      final client = ref.read(supabaseClientProvider);

      await client.functions.invoke(
        'datasets/$datasetId/submit-review',
        method: HttpMethod.post,
      );

      _logger.i('리뷰 제출: $datasetId');
    } catch (e) {
      _logger.e('리뷰 제출 실패', error: e);
      rethrow;
    }
  }

  /// 승인 (S5에서)
  Future<void> approve(String datasetId, String approverId, String approverName) async {
    try {
      final client = ref.read(supabaseClientProvider);

      await client.functions.invoke(
        'datasets/$datasetId/approve',
        method: HttpMethod.post,
        body: {
          'approver_id': approverId,
          'approver_name': approverName,
        },
      );

      _logger.i('승인: $datasetId by $approverName');
    } catch (e) {
      _logger.e('승인 실패', error: e);
      rethrow;
    }
  }

  /// 반려 (S5 → S3)
  Future<void> reject(String datasetId, String approverId, String approverName, String reason) async {
    try {
      final client = ref.read(supabaseClientProvider);

      await client.functions.invoke(
        'datasets/$datasetId/reject',
        method: HttpMethod.post,
        body: {
          'approver_id': approverId,
          'approver_name': approverName,
          'rejection_reason': reason,
        },
      );

      _logger.i('반려: $datasetId by $approverName - $reason');
    } catch (e) {
      _logger.e('반려 실패', error: e);
      rethrow;
    }
  }

  /// 퍼블리시 (S5 → S6)
  Future<void> publish(String datasetId, String publishedPath) async {
    try {
      final client = ref.read(supabaseClientProvider);

      await client.functions.invoke(
        'datasets/$datasetId/publish',
        method: HttpMethod.post,
        body: {
          'published_path': publishedPath,
        },
      );

      _logger.i('퍼블리시: $datasetId → $publishedPath');
    } catch (e) {
      _logger.e('퍼블리시 실패', error: e);
      rethrow;
    }
  }
}

/// 리뷰 대기 (S2) 데이터셋 개수 (Developer 뱃지용)
@riverpod
int pendingReviewCount(Ref ref) {
  final datasets = ref.watch(datasetRealtimeServiceProvider);
  return datasets.where((d) => d.isPendingReview).length;
}

/// 승인 대기 (S5) 데이터셋 개수 (Admin 뱃지용)
@riverpod
int pendingApprovalCount(Ref ref) {
  final datasets = ref.watch(datasetRealtimeServiceProvider);
  return datasets.where((d) => d.isPendingApproval).length;
}
