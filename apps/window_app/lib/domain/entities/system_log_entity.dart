import 'package:window_app/data/models/enums/environment.dart';
import 'package:window_app/data/models/enums/log_category.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/data/models/enums/response_status.dart';
import 'package:window_app/data/models/system_log_model.dart';

/// 시스템 로그 엔티티
/// - Model에서 시스템 데이터를 비즈니스 관점으로 해석
/// - 로컬 시간 변환 지원
/// - 비즈니스 로직 포함
class SystemLogEntity {
  final String id;
  final String source;
  final String? description;
  final LogCategory category;
  final String? code;
  final LogLevel logLevel;
  final Environment environment;
  final Map<String, dynamic> payload;
  final Map<String, dynamic> attachments;
  final ResponseStatus responseStatus;
  final DateTime _createdAtUtc;
  final DateTime? _updatedAtUtc;
  final String? currentResponderId;
  final String? currentResponderName;
  final DateTime? _responseStartedAtUtc;
  final String? organizationId;
  final String? assignedById;
  final String? assignedByName;
  final bool? isMuted;
  final String? site;

  SystemLogEntity({
    required this.id,
    required this.source,
    this.description,
    required this.category,
    this.code,
    required this.logLevel,
    required this.environment,
    required this.payload,
    required this.attachments,
    required this.responseStatus,
    required DateTime createdAt,
    DateTime? updatedAt,
    this.currentResponderId,
    this.currentResponderName,
    DateTime? responseStartedAt,
    this.organizationId,
    this.assignedById,
    this.assignedByName,
    this.isMuted,
    this.site,
  })  : _createdAtUtc = createdAt,
        _updatedAtUtc = updatedAt,
        _responseStartedAtUtc = responseStartedAt;

  /// Model에서 Entity 생성
  /// EdgeManager 케이스의 경우 site가 null이면 payload.dbKey를 사용
  factory SystemLogEntity.fromModel(SystemLogModel model) {
    // EdgeManager의 경우 site가 없으면 payload.dbKey 사용
    String? site = model.site;
    if (site == null && model.source == 'EdgeManager') {
      site = model.payload['dbKey'] as String?;
    }

    return SystemLogEntity(
      id: model.id,
      source: model.source,
      description: model.description,
      category: model.category,
      code: model.code,
      logLevel: model.logLevel,
      environment: model.environment,
      payload: model.payload,
      attachments: model.attachments,
      responseStatus: model.responseStatus,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      currentResponderId: model.currentResponderId,
      currentResponderName: model.currentResponderName,
      responseStartedAt: model.responseStartedAt,
      organizationId: model.organizationId,
      assignedById: model.assignedById,
      assignedByName: model.assignedByName,
      isMuted: model.isMuted,
      site: site,
    );
  }

  // ===== 로컬 시간 변환 =====

  /// 생성 시간 (로컬 시간)
  DateTime get createdAt => _createdAtUtc.toLocal();

  /// 업데이트 시간 (로컬 시간) - 없으면 생성 시간 반환
  DateTime get updatedAt => (_updatedAtUtc ?? _createdAtUtc).toLocal();

  /// 대응 시작 시간 (로컬 시간)
  DateTime? get responseStartedAt => _responseStartedAtUtc?.toLocal();

  /// 생성 시간 (UTC 원본)
  DateTime get createdAtUtc => _createdAtUtc;

  /// 업데이트 시간 (UTC 원본)
  DateTime? get updatedAtUtc => _updatedAtUtc;

  /// 대응 시작 시간 (UTC 원본)
  DateTime? get responseStartedAtUtc => _responseStartedAtUtc;

  // ===== 포맷된 시간 문자열 =====

  /// 생성 시간 포맷 (MM/dd HH:mm:ss)
  String get formattedCreatedAt => _formatDateTime(createdAt);

  /// 업데이트 시간 포맷 (MM/dd HH:mm:ss)
  String get formattedUpdatedAt => _formatDateTime(updatedAt);

  /// 대응 시작 시간 포맷 (MM/dd HH:mm:ss 시작)
  String? get formattedResponseStartedAt {
    final time = responseStartedAt;
    if (time == null) return null;
    return '${_formatDateTime(time)} 시작';
  }

  /// 대응 경과 시간 (Duration)
  Duration? get responseElapsedDuration {
    final time = responseStartedAt;
    if (time == null) return null;
    return DateTime.now().difference(time);
  }

  /// 대응 경과 시간 포맷 (HH:mm:ss 또는 mm:ss)
  String? get formattedElapsedTime {
    final duration = responseElapsedDuration;
    if (duration == null) return null;

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// 발생 후 경과 시간 (Duration)
  Duration get createdElapsedDuration {
    return DateTime.now().difference(createdAt);
  }

  /// 발생 후 경과 시간 포맷 (HH:mm:ss 또는 mm:ss)
  String get formattedCreatedElapsedTime {
    final duration = createdElapsedDuration;

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dt) {
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final second = dt.second.toString().padLeft(2, '0');
    return '$month/$day $hour:$minute:$second';
  }

  // ===== 비즈니스 로직 =====

  /// 헬스체크인지
  bool get isHealthCheck => category.isHealthCheck;

  /// 이벤트인지
  bool get isEvent => category.isEvent;

  /// 개발 환경인지
  bool get isDevelopment => environment.isDevelopment;

  /// 운영 환경인지
  bool get isProduction => environment.isProduction;

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

  /// 앱을 전면으로 올려야 하는지
  bool get needsForeground => logLevel.needsForeground;

  /// 트레이 알림만 필요한지
  bool get needsTrayOnly => logLevel.needsTrayOnly;

  /// critical이고 미확인인지
  bool get isCriticalUnchecked =>
      logLevel == LogLevel.critical && responseStatus == ResponseStatus.unresponded;

  /// 할당된 건인지 (관리자가 할당)
  bool get isAssigned => assignedById != null;

  /// 자원한 건인지 (본인이 대응 시작)
  bool get isVolunteered => isBeingResponded && assignedById == null;

  /// 알림 무시 상태인지
  bool get isMutedLog => isMuted == true;

  /// 이슈 정보 요약 문자열 (알림용)
  String get issueInfo {
    final buffer = StringBuffer();
    buffer.write('출처: $source');

    if (code != null) {
      buffer.write(' | 코드: $code');
    }

    buffer.write(' | ${logLevel.label}');

    return buffer.toString();
  }

  /// Entity → JSON (캐시 저장용)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'description': description,
      'category': category.value,
      'code': code,
      'log_level': logLevel.value,
      'environment': environment.value,
      'payload': payload,
      'attachments': attachments,
      'response_status': responseStatus.value,
      'created_at': _createdAtUtc.toIso8601String(),
      'updated_at': _updatedAtUtc?.toIso8601String(),
      'current_responder_id': currentResponderId,
      'current_responder_name': currentResponderName,
      'response_started_at': _responseStartedAtUtc?.toIso8601String(),
      'organization_id': organizationId,
      'assigned_by_id': assignedById,
      'assigned_by_name': assignedByName,
      'is_muted': isMuted,
      'site': site,
    };
  }
}
