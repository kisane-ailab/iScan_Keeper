import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/domain/services/system_log_realtime_service.dart';

part 'health_check_view_model.freezed.dart';
part 'health_check_view_model.g.dart';

/// HealthCheck 화면 상태
@freezed
abstract class HealthCheckState with _$HealthCheckState {
  const factory HealthCheckState({
    @Default([]) List<SystemLogEntity> productionLogs,
    @Default([]) List<SystemLogEntity> developmentLogs,
    @Default(0) int productionAlertCount,
    @Default(0) int developmentAlertCount,
    /// 필터링에 사용 가능한 source 목록
    @Default([]) List<String> availableSources,
    /// 필터링에 사용 가능한 code 목록
    @Default([]) List<String> availableCodes,
    /// 선택된 source 필터 (null이면 전체)
    String? selectedSource,
    /// 선택된 code 필터 (null이면 전체)
    String? selectedCode,
    /// 선택된 로그 레벨 필터 (빈 Set이면 전체)
    @Default({}) Set<LogLevel> selectedLogLevels,
    /// 시작 날짜 필터 (null이면 제한 없음)
    DateTime? startDate,
    /// 종료 날짜 필터 (null이면 제한 없음)
    DateTime? endDate,
  }) = _HealthCheckState;
}

extension HealthCheckStateX on HealthCheckState {
  /// 전체 알림 개수 (뱃지용)
  int get alertCount => productionAlertCount + developmentAlertCount;

  /// 필터가 적용되어 있는지
  bool get hasFilter =>
      selectedSource != null ||
      selectedCode != null ||
      selectedLogLevels.isNotEmpty ||
      startDate != null ||
      endDate != null;
}

/// HealthCheck ViewModel
@riverpod
class HealthCheckViewModel extends _$HealthCheckViewModel {
  // 필터 상태 유지용
  String? _selectedSource;
  String? _selectedCode;
  Set<LogLevel> _selectedLogLevels = {};
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  HealthCheckState build() {
    // 서비스의 로그 목록 구독 (health_check만 필터링)
    final allLogs = ref.watch(systemLogRealtimeServiceProvider);
    final healthCheckLogs =
        allLogs.where((entity) => entity.isHealthCheck).toList();

    // 사용 가능한 source 목록 추출
    final sources = healthCheckLogs.map((e) => e.source).toSet().toList()..sort();

    // 선택된 source에 해당하는 code 목록만 추출
    final codes = _selectedSource != null
        ? (healthCheckLogs
            .where((e) => e.source == _selectedSource && e.code != null)
            .map((e) => e.code!)
            .toSet()
            .toList()
          ..sort())
        : <String>[];

    // 필터 적용
    var filteredLogs = healthCheckLogs;

    // Source 필터
    if (_selectedSource != null) {
      filteredLogs = filteredLogs
          .where((entity) => entity.source == _selectedSource)
          .toList();
    }

    // Code 필터
    if (_selectedCode != null) {
      filteredLogs = filteredLogs
          .where((entity) => entity.code == _selectedCode)
          .toList();
    }

    // 로그 레벨 필터 (다중 선택)
    if (_selectedLogLevels.isNotEmpty) {
      filteredLogs = filteredLogs
          .where((entity) => _selectedLogLevels.contains(entity.logLevel))
          .toList();
    }

    // 기간 필터
    if (_startDate != null) {
      final start = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
      filteredLogs = filteredLogs
          .where((entity) => !entity.createdAt.isBefore(start))
          .toList();
    }
    if (_endDate != null) {
      // 종료일의 다음날 00:00:00 이전까지 포함
      final endOfDay = DateTime(_endDate!.year, _endDate!.month, _endDate!.day + 1);
      filteredLogs = filteredLogs
          .where((entity) => entity.createdAt.isBefore(endOfDay))
          .toList();
    }

    // Production/Development 분리
    final productionLogs =
        filteredLogs.where((entity) => entity.isProduction).toList();
    final developmentLogs =
        filteredLogs.where((entity) => entity.isDevelopment).toList();

    // 미확인 상태이고 알림이 필요한 로그 개수 (필터 적용 전 전체 기준)
    final productionAlertCount = healthCheckLogs
        .where((entity) => entity.isProduction && entity.needsNotification)
        .length;
    final developmentAlertCount = healthCheckLogs
        .where((entity) => entity.isDevelopment && entity.needsNotification)
        .length;

    return HealthCheckState(
      productionLogs: productionLogs,
      developmentLogs: developmentLogs,
      productionAlertCount: productionAlertCount,
      developmentAlertCount: developmentAlertCount,
      availableSources: sources,
      availableCodes: codes,
      selectedSource: _selectedSource,
      selectedCode: _selectedCode,
      selectedLogLevels: _selectedLogLevels,
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  /// Source 필터 설정 (Source 변경 시 Code 초기화)
  void setSourceFilter(String? source) {
    _selectedSource = source;
    _selectedCode = null; // Source 변경 시 Code 초기화
    ref.invalidateSelf();
  }

  /// Code 필터 설정
  void setCodeFilter(String? code) {
    _selectedCode = code;
    ref.invalidateSelf();
  }

  /// 로그 레벨 토글 (다중 선택)
  void toggleLogLevel(LogLevel level) {
    if (_selectedLogLevels.contains(level)) {
      _selectedLogLevels = {..._selectedLogLevels}..remove(level);
    } else {
      _selectedLogLevels = {..._selectedLogLevels, level};
    }
    ref.invalidateSelf();
  }

  /// 로그 레벨 필터 초기화
  void clearLogLevelFilter() {
    _selectedLogLevels = {};
    ref.invalidateSelf();
  }

  /// 시작 날짜 설정
  void setStartDate(DateTime? date) {
    _startDate = date;
    ref.invalidateSelf();
  }

  /// 종료 날짜 설정
  void setEndDate(DateTime? date) {
    _endDate = date;
    ref.invalidateSelf();
  }

  /// 날짜 필터 초기화
  void clearDateFilter() {
    _startDate = null;
    _endDate = null;
    ref.invalidateSelf();
  }

  /// 필터 초기화
  void clearFilters() {
    _selectedSource = null;
    _selectedCode = null;
    _selectedLogLevels = {};
    _startDate = null;
    _endDate = null;
    ref.invalidateSelf();
  }
}
