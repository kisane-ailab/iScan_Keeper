import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/models/enums/environment.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/domain/entities/system_log_entity.dart';
import 'package:window_app/domain/services/mute_rule_service.dart';
import 'package:window_app/domain/services/system_log_realtime_service.dart';
import 'package:window_app/presentation/pages/main/05_health_check/health_check_view_model.dart'
    show GroupingMode;

part 'alert_view_model.freezed.dart';
part 'alert_view_model.g.dart';

/// 환경별 필터 상태
@freezed
abstract class EnvironmentFilterState with _$EnvironmentFilterState {
  const factory EnvironmentFilterState({
    @Default([]) List<String> availableSources,
    @Default([]) List<String> availableSites,
    @Default([]) List<String> availableCodes,
    String? selectedSource,
    String? selectedSite,
    String? selectedCode,
    @Default({}) Set<LogLevel> selectedLogLevels,
    DateTime? startDate,
    DateTime? endDate,
    @Default(GroupingMode.none) GroupingMode groupingMode,
  }) = _EnvironmentFilterState;
}

extension EnvironmentFilterStateX on EnvironmentFilterState {
  /// 필터가 적용되어 있는지
  bool get hasFilter =>
      selectedSource != null ||
      selectedSite != null ||
      selectedCode != null ||
      selectedLogLevels.isNotEmpty ||
      startDate != null ||
      endDate != null;
}

/// Alert 화면 상태
@freezed
abstract class AlertState with _$AlertState {
  const factory AlertState({
    @Default([]) List<SystemLogEntity> productionLogs,
    @Default([]) List<SystemLogEntity> developmentLogs,
    @Default(0) int productionAlertCount,
    @Default(0) int developmentAlertCount,
    /// Production 환경 필터 상태
    @Default(EnvironmentFilterState()) EnvironmentFilterState productionFilter,
    /// Development 환경 필터 상태
    @Default(EnvironmentFilterState()) EnvironmentFilterState developmentFilter,
  }) = _AlertState;
}

extension AlertStateX on AlertState {
  /// 전체 알림 개수 (뱃지용)
  int get alertCount => productionAlertCount + developmentAlertCount;

  /// 특정 환경의 필터 상태 가져오기
  EnvironmentFilterState getFilterForEnvironment(Environment env) {
    return env == Environment.production ? productionFilter : developmentFilter;
  }
}

/// Alert ViewModel (이벤트 전용)
@riverpod
class AlertViewModel extends _$AlertViewModel {
  SystemLogRealtimeService get _service =>
      ref.read(systemLogRealtimeServiceProvider.notifier);

  // Production 필터 상태
  String? _prodSelectedSource;
  String? _prodSelectedSite;
  String? _prodSelectedCode;
  Set<LogLevel> _prodSelectedLogLevels = {};
  DateTime? _prodStartDate;
  DateTime? _prodEndDate;
  GroupingMode _prodGroupingMode = GroupingMode.none;

  // Development 필터 상태
  String? _devSelectedSource;
  String? _devSelectedSite;
  String? _devSelectedCode;
  Set<LogLevel> _devSelectedLogLevels = {};
  DateTime? _devStartDate;
  DateTime? _devEndDate;
  GroupingMode _devGroupingMode = GroupingMode.none;

  @override
  AlertState build() {
    // 서비스의 로그 목록 구독 (이벤트만 필터링)
    final allLogs = ref.watch(systemLogRealtimeServiceProvider);
    final muteRules = ref.watch(muteRuleServiceProvider);

    // 이벤트만 필터링 + mute rule에 매칭되는 로그 제외
    final eventLogs = allLogs.where((entity) {
      if (!entity.isEvent) return false;
      // mute rule에 매칭되면 제외
      final isMutedByRule = muteRules.any(
        (rule) => rule.matches(logSource: entity.source, logCode: entity.code),
      );
      return !isMutedByRule;
    }).toList();

    // 환경별 로그 분리
    final prodLogs = eventLogs.where((e) => e.isProduction).toList();
    final devLogs = eventLogs.where((e) => e.isDevelopment).toList();

    // Production 필터 상태 생성
    final prodFilter = _buildFilterState(
      logs: prodLogs,
      selectedSource: _prodSelectedSource,
      selectedSite: _prodSelectedSite,
      selectedCode: _prodSelectedCode,
      selectedLogLevels: _prodSelectedLogLevels,
      startDate: _prodStartDate,
      endDate: _prodEndDate,
      groupingMode: _prodGroupingMode,
    );

    // Development 필터 상태 생성
    final devFilter = _buildFilterState(
      logs: devLogs,
      selectedSource: _devSelectedSource,
      selectedSite: _devSelectedSite,
      selectedCode: _devSelectedCode,
      selectedLogLevels: _devSelectedLogLevels,
      startDate: _devStartDate,
      endDate: _devEndDate,
      groupingMode: _devGroupingMode,
    );

    // 필터 적용된 로그
    final filteredProdLogs = _applyFilters(
      logs: prodLogs,
      selectedSource: _prodSelectedSource,
      selectedSite: _prodSelectedSite,
      selectedCode: _prodSelectedCode,
      selectedLogLevels: _prodSelectedLogLevels,
      startDate: _prodStartDate,
      endDate: _prodEndDate,
    );

    final filteredDevLogs = _applyFilters(
      logs: devLogs,
      selectedSource: _devSelectedSource,
      selectedSite: _devSelectedSite,
      selectedCode: _devSelectedCode,
      selectedLogLevels: _devSelectedLogLevels,
      startDate: _devStartDate,
      endDate: _devEndDate,
    );

    // 미확인 상태이고 알림이 필요한 로그 개수 (필터 적용 전 전체 기준)
    final productionAlertCount = prodLogs
        .where((entity) => entity.needsNotification)
        .length;
    final developmentAlertCount = devLogs
        .where((entity) => entity.needsNotification)
        .length;

    return AlertState(
      productionLogs: filteredProdLogs,
      developmentLogs: filteredDevLogs,
      productionAlertCount: productionAlertCount,
      developmentAlertCount: developmentAlertCount,
      productionFilter: prodFilter,
      developmentFilter: devFilter,
    );
  }

  /// 필터 상태 생성 헬퍼
  EnvironmentFilterState _buildFilterState({
    required List<SystemLogEntity> logs,
    required String? selectedSource,
    required String? selectedSite,
    required String? selectedCode,
    required Set<LogLevel> selectedLogLevels,
    required DateTime? startDate,
    required DateTime? endDate,
    required GroupingMode groupingMode,
  }) {
    // 사용 가능한 source 목록 추출
    final sources = logs.map((e) => e.source).toSet().toList()..sort();

    // 선택된 source에 해당하는 site 목록 추출
    final sites = selectedSource != null
        ? (logs
            .where((e) => e.source == selectedSource && e.site != null)
            .map((e) => e.site!)
            .toSet()
            .toList()
          ..sort())
        : <String>[];

    // 선택된 source + site에 해당하는 code 목록만 추출
    final codes = selectedSource != null
        ? (logs
            .where((e) {
              if (e.source != selectedSource) return false;
              if (selectedSite != null && e.site != selectedSite) return false;
              return e.code != null;
            })
            .map((e) => e.code!)
            .toSet()
            .toList()
          ..sort())
        : <String>[];

    return EnvironmentFilterState(
      availableSources: sources,
      availableSites: sites,
      availableCodes: codes,
      selectedSource: selectedSource,
      selectedSite: selectedSite,
      selectedCode: selectedCode,
      selectedLogLevels: selectedLogLevels,
      startDate: startDate,
      endDate: endDate,
      groupingMode: groupingMode,
    );
  }

  /// 필터 적용 헬퍼
  List<SystemLogEntity> _applyFilters({
    required List<SystemLogEntity> logs,
    required String? selectedSource,
    required String? selectedSite,
    required String? selectedCode,
    required Set<LogLevel> selectedLogLevels,
    required DateTime? startDate,
    required DateTime? endDate,
  }) {
    var filteredLogs = logs;

    // Source 필터
    if (selectedSource != null) {
      filteredLogs = filteredLogs
          .where((entity) => entity.source == selectedSource)
          .toList();
    }

    // Site 필터
    if (selectedSite != null) {
      filteredLogs = filteredLogs
          .where((entity) => entity.site == selectedSite)
          .toList();
    }

    // Code 필터
    if (selectedCode != null) {
      filteredLogs = filteredLogs
          .where((entity) => entity.code == selectedCode)
          .toList();
    }

    // 로그 레벨 필터 (다중 선택)
    if (selectedLogLevels.isNotEmpty) {
      filteredLogs = filteredLogs
          .where((entity) => selectedLogLevels.contains(entity.logLevel))
          .toList();
    }

    // 기간 필터
    if (startDate != null) {
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      filteredLogs = filteredLogs
          .where((entity) => !entity.createdAt.isBefore(start))
          .toList();
    }
    if (endDate != null) {
      // 종료일의 다음날 00:00:00 이전까지 포함
      final endOfDay = DateTime(endDate.year, endDate.month, endDate.day + 1);
      filteredLogs = filteredLogs
          .where((entity) => entity.createdAt.isBefore(endOfDay))
          .toList();
    }

    return filteredLogs;
  }

  /// Source 필터 설정 (Source 변경 시 Site, Code 초기화)
  void setSourceFilter(Environment env, String? source) {
    if (env == Environment.production) {
      _prodSelectedSource = source;
      _prodSelectedSite = null;
      _prodSelectedCode = null;
    } else {
      _devSelectedSource = source;
      _devSelectedSite = null;
      _devSelectedCode = null;
    }
    ref.invalidateSelf();
  }

  /// Site 필터 설정 (Site 변경 시 Code 초기화)
  void setSiteFilter(Environment env, String? site) {
    if (env == Environment.production) {
      _prodSelectedSite = site;
      _prodSelectedCode = null;
    } else {
      _devSelectedSite = site;
      _devSelectedCode = null;
    }
    ref.invalidateSelf();
  }

  /// Code 필터 설정
  void setCodeFilter(Environment env, String? code) {
    if (env == Environment.production) {
      _prodSelectedCode = code;
    } else {
      _devSelectedCode = code;
    }
    ref.invalidateSelf();
  }

  /// 로그 레벨 토글 (다중 선택)
  void toggleLogLevel(Environment env, LogLevel level) {
    if (env == Environment.production) {
      if (_prodSelectedLogLevels.contains(level)) {
        _prodSelectedLogLevels = {..._prodSelectedLogLevels}..remove(level);
      } else {
        _prodSelectedLogLevels = {..._prodSelectedLogLevels, level};
      }
    } else {
      if (_devSelectedLogLevels.contains(level)) {
        _devSelectedLogLevels = {..._devSelectedLogLevels}..remove(level);
      } else {
        _devSelectedLogLevels = {..._devSelectedLogLevels, level};
      }
    }
    ref.invalidateSelf();
  }

  /// 로그 레벨 필터 초기화
  void clearLogLevelFilter(Environment env) {
    if (env == Environment.production) {
      _prodSelectedLogLevels = {};
    } else {
      _devSelectedLogLevels = {};
    }
    ref.invalidateSelf();
  }

  /// 시작 날짜 설정
  void setStartDate(Environment env, DateTime? date) {
    if (env == Environment.production) {
      _prodStartDate = date;
    } else {
      _devStartDate = date;
    }
    ref.invalidateSelf();
  }

  /// 종료 날짜 설정
  void setEndDate(Environment env, DateTime? date) {
    if (env == Environment.production) {
      _prodEndDate = date;
    } else {
      _devEndDate = date;
    }
    ref.invalidateSelf();
  }

  /// 날짜 필터 초기화
  void clearDateFilter(Environment env) {
    if (env == Environment.production) {
      _prodStartDate = null;
      _prodEndDate = null;
    } else {
      _devStartDate = null;
      _devEndDate = null;
    }
    ref.invalidateSelf();
  }

  /// 필터 초기화
  void clearFilters(Environment env) {
    if (env == Environment.production) {
      _prodSelectedSource = null;
      _prodSelectedSite = null;
      _prodSelectedCode = null;
      _prodSelectedLogLevels = {};
      _prodStartDate = null;
      _prodEndDate = null;
    } else {
      _devSelectedSource = null;
      _devSelectedSite = null;
      _devSelectedCode = null;
      _devSelectedLogLevels = {};
      _devStartDate = null;
      _devEndDate = null;
    }
    ref.invalidateSelf();
  }

  /// 알림 스트림 (새 알림 발생 시)
  Stream<SystemLogEntity> get alertStream => _service.alertStream;

  /// 로그 모두 지우기
  void clearLogs() {
    _service.clearLogs();
  }

  /// 로그가 긴급 알림인지 확인
  bool isAlert(SystemLogEntity entity) {
    return entity.needsNotification;
  }

  /// 그룹핑 모드 설정
  void setGroupingMode(Environment env, GroupingMode mode) {
    if (env == Environment.production) {
      _prodGroupingMode = mode;
    } else {
      _devGroupingMode = mode;
    }
    ref.invalidateSelf();
  }
}
