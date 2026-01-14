import 'package:window_app/data/models/enums/environment.dart';
import 'package:window_app/data/models/enums/log_category.dart';
import 'package:window_app/data/models/enums/log_level.dart';
import 'package:window_app/data/models/enums/response_status.dart';
import 'package:window_app/data/models/system_log_model.dart';

/// ?쒖뒪??濡쒓렇 ?꾨찓???뷀떚??
/// - Model???먯떆 ?곗씠?곕? 鍮꾩쫰?덉뒪 愿?먯쑝濡??댁꽍
/// - 濡쒖뺄 ?쒓컙 蹂???쒓났
/// - 鍮꾩쫰?덉뒪 濡쒖쭅 ?ы븿
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

  /// Model?먯꽌 Entity ?앹꽦
  /// EdgeManager ?뚯뒪??寃쎌슦 site媛 null?대㈃ payload.dbKey瑜??ъ슜
  factory SystemLogEntity.fromModel(SystemLogModel model) {
    // EdgeManager??寃쎌슦 site媛 ?놁쑝硫?payload.dbKey ?ъ슜
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

  // ===== 濡쒖뺄 ?쒓컙 蹂??=====

  /// ?앹꽦 ?쒓컙 (濡쒖뺄 ?쒓컙)
  DateTime get createdAt => _createdAtUtc.toLocal();

  /// ?낅뜲?댄듃 ?쒓컙 (濡쒖뺄 ?쒓컙) - ?놁쑝硫??앹꽦 ?쒓컙 諛섑솚
  DateTime get updatedAt => (_updatedAtUtc ?? _createdAtUtc).toLocal();

  /// ????쒖옉 ?쒓컙 (濡쒖뺄 ?쒓컙)
  DateTime? get responseStartedAt => _responseStartedAtUtc?.toLocal();

  /// ?앹꽦 ?쒓컙 (UTC ?먮낯)
  DateTime get createdAtUtc => _createdAtUtc;

  /// ?낅뜲?댄듃 ?쒓컙 (UTC ?먮낯)
  DateTime? get updatedAtUtc => _updatedAtUtc;

  /// ????쒖옉 ?쒓컙 (UTC ?먮낯)
  DateTime? get responseStartedAtUtc => _responseStartedAtUtc;

  // ===== ?щ㎎???쒓컙 臾몄옄??=====

  /// ?앹꽦 ?쒓컙 ?щ㎎ (MM/dd HH:mm)
  String get formattedCreatedAt => _formatDateTime(createdAt);

  /// ?낅뜲?댄듃 ?쒓컙 ?щ㎎ (MM/dd HH:mm)
  String get formattedUpdatedAt => _formatDateTime(updatedAt);

  /// ????쒖옉 ?쒓컙 ?щ㎎ (MM/dd HH:mm ?쒖옉)
  String? get formattedResponseStartedAt {
    final time = responseStartedAt;
    if (time == null) return null;
    return '${_formatDateTime(time)} ?쒖옉';
  }

  /// ???寃쎄낵 ?쒓컙 (Duration)
  Duration? get responseElapsedDuration {
    final time = responseStartedAt;
    if (time == null) return null;
    return DateTime.now().difference(time);
  }

  /// ???寃쎄낵 ?쒓컙 ?щ㎎ (HH:mm:ss ?먮뒗 mm:ss)
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

  /// 諛쒖깮 ??寃쎄낵 ?쒓컙 (Duration)
  Duration get createdElapsedDuration {
    return DateTime.now().difference(createdAt);
  }

  /// 諛쒖깮 ??寃쎄낵 ?쒓컙 ?щ㎎ (HH:mm:ss ?먮뒗 mm:ss)
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
    return '$month/$day $hour:$minute';
  }

  // ===== 鍮꾩쫰?덉뒪 濡쒖쭅 =====

  /// ?ъ뒪泥댄겕?몄?
  bool get isHealthCheck => category.isHealthCheck;

  /// ?대깽?몄씤吏
  bool get isEvent => category.isEvent;

  /// 媛쒕컻 ?섍꼍?몄?
  bool get isDevelopment => environment.isDevelopment;

  /// ?댁쁺 ?섍꼍?몄?
  bool get isProduction => environment.isProduction;

  /// ???以묒씤吏
  bool get isBeingResponded =>
      responseStatus == ResponseStatus.inProgress && currentResponderId != null;

  /// 誘명솗???곹깭?몄?
  bool get isUnchecked => responseStatus == ResponseStatus.unresponded;

  /// ????꾨즺?몄?
  bool get isCompleted => responseStatus == ResponseStatus.completed;

  /// ?뚮┝???꾩슂?쒖? (warning ?댁긽 + unchecked)
  bool get needsNotification =>
      logLevel.needsNotification && responseStatus == ResponseStatus.unresponded;

  /// ?깆쓣 ?꾨㈃?쇰줈 ?꾩썙???섎뒗吏
  bool get needsForeground => logLevel.needsForeground;

  /// ?몃젅???뚮┝留??꾩슂?쒖?
  bool get needsTrayOnly => logLevel.needsTrayOnly;

  /// critical?닿퀬 誘명솗?몄씤吏
  bool get isCriticalUnchecked =>
      logLevel == LogLevel.critical && responseStatus == ResponseStatus.unresponded;

  /// ?좊떦??嫄댁씤吏 (愿由ъ옄媛 ?좊떦)
  bool get isAssigned => assignedById != null;

  /// ?먯썝??嫄댁씤吏 (蹂몄씤??????쒖옉)
  bool get isVolunteered => isBeingResponded && assignedById == null;

  /// ?뚮┝ 臾댁떆 ?곹깭?몄?
  bool get isMutedLog => isMuted == true;

  /// ?댁뒋 ?뺣낫 ?붿빟 臾몄옄??(?뚮┝??
  String get issueInfo {
    final buffer = StringBuffer();
    buffer.write('異쒖쿂: $source');

    if (code != null) {
      buffer.write(' | 肄붾뱶: $code');
    }

    buffer.write(' | ${logLevel.label}');

    return buffer.toString();
  }
}