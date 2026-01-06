import 'package:window_app/data/models/enums/event_type.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/data/models/enums/response_status.dart';
import 'package:window_app/data/models/system_log_model.dart';

/// 시스템 로그 도메인 엔티티
/// - Model의 원시 데이터를 비즈니스 관점으로 해석
/// - 로컬 시간 변환 제공
/// - 비즈니스 로직 포함
class SystemLogEntity {
  final String id;
  final String source;
  final String? description;
  final EventType eventType;
  final String? errorCode;
  final LogLevel logLevel;
  final Map<String, dynamic> payload;
  final ResponseStatus responseStatus;
  final DateTime _createdAtUtc;
  final String? currentResponderId;
  final String? currentResponderName;
  final DateTime? _responseStartedAtUtc;
  final String? organizationId;

  SystemLogEntity({
    required this.id,
    required this.source,
    this.description,
    required this.eventType,
    this.errorCode,
    required this.logLevel,
    required this.payload,
    required this.responseStatus,
    required DateTime createdAt,
    this.currentResponderId,
    this.currentResponderName,
    DateTime? responseStartedAt,
    this.organizationId,
  })  : _createdAtUtc = createdAt,
        _responseStartedAtUtc = responseStartedAt;

  /// Model에서 Entity 생성
  factory SystemLogEntity.fromModel(SystemLogModel model) {
    return SystemLogEntity(
      id: model.id,
      source: model.source,
      description: model.description,
      eventType: model.eventType,
      errorCode: model.errorCode,
      logLevel: model.logLevel,
      payload: model.payload,
      responseStatus: model.responseStatus,
      createdAt: model.createdAt,
      currentResponderId: model.currentResponderId,
      currentResponderName: model.currentResponderName,
      responseStartedAt: model.responseStartedAt,
      organizationId: model.organizationId,
    );
  }

  // ===== 로컬 시간 변환 =====

  /// 생성 시간 (로컬 시간)
  DateTime get createdAt => _createdAtUtc.toLocal();

  /// 대응 시작 시간 (로컬 시간)
  DateTime? get responseStartedAt => _responseStartedAtUtc?.toLocal();

  /// 생성 시간 (UTC 원본)
  DateTime get createdAtUtc => _createdAtUtc;

  /// 대응 시작 시간 (UTC 원본)
  DateTime? get responseStartedAtUtc => _responseStartedAtUtc;

  // ===== 포맷된 시간 문자열 =====

  /// 생성 시간 포맷 (MM/dd HH:mm)
  String get formattedCreatedAt => _formatDateTime(createdAt);

  /// 대응 시작 시간 포맷 (MM/dd HH:mm 시작)
  String? get formattedResponseStartedAt {
    final time = responseStartedAt;
    if (time == null) return null;
    return '${_formatDateTime(time)} 시작';
  }

  String _formatDateTime(DateTime dt) {
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$month/$day $hour:$minute';
  }

  // ===== 비즈니스 로직 =====

  /// 헬스체크인지
  bool get isHealthCheck => eventType.isHealthCheck;

  /// 이벤트인지
  bool get isEvent => eventType.isEvent;

  /// 대응 중인지
  bool get isBeingResponded =>
      responseStatus == ResponseStatus.inProgress && currentResponderId != null;

  /// 미확인 상태인지
  bool get isUnchecked => responseStatus == ResponseStatus.unresponded;

  /// 대응 완료인지
  bool get isCompleted => responseStatus == ResponseStatus.completed;

  /// 알림이 필요한지 (warning 이상 + unchecked)
  bool get needsNotification =>
      logLevel.needsNotification && responseStatus == ResponseStatus.unresponded;

  /// 앱을 전면으로 띄워야 하는지
  bool get needsForeground => logLevel.needsForeground;

  /// 트레이 알림만 필요한지
  bool get needsTrayOnly => logLevel.needsTrayOnly;

  /// critical이고 미확인인지
  bool get isCriticalUnchecked =>
      logLevel == LogLevel.critical && responseStatus == ResponseStatus.unresponded;

  /// 이슈 정보 요약 문자열 (알림용)
  String get issueInfo {
    final buffer = StringBuffer();
    buffer.write('출처: $source');

    if (errorCode != null) {
      buffer.write(' | 코드: $errorCode');
    }

    buffer.write(' | ${logLevel.label}');

    return buffer.toString();
  }
}
