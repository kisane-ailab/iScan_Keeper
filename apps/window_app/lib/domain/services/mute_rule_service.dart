import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_app/data/datasources/local/mute_rule_local_datasource.dart';
import 'package:window_app/data/models/mute_rule_model.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';

part 'mute_rule_service.g.dart';

/// Mute 규칙 서비스
/// 규칙 목록을 관리하고, 로그가 규칙에 매칭되는지 확인
@riverpod
class MuteRuleService extends _$MuteRuleService {
  MuteRuleLocalDatasource get _datasource =>
      ref.read(muteRuleLocalDatasourceProvider);

  @override
  List<MuteRule> build() {
    // SharedPreferences가 준비될 때까지 빈 리스트 반환
    final prefsAsync = ref.watch(sharedPreferencesProvider);
    if (!prefsAsync.hasValue) {
      return [];
    }
    return _datasource.getRules();
  }

  /// 규칙 추가
  Future<MuteRule?> addRule({String? source, String? code}) async {
    try {
      final rule = await _datasource.addRule(source: source, code: code);
      ref.invalidateSelf();
      return rule;
    } catch (e) {
      logger.e('Failed to add mute rule: $e');
      return null;
    }
  }

  /// 규칙 삭제
  Future<void> removeRule(String id) async {
    await _datasource.removeRule(id);
    ref.invalidateSelf();
  }

  /// 모든 규칙 삭제
  Future<void> clearRules() async {
    await _datasource.clearRules();
    ref.invalidateSelf();
  }

  /// 로그가 규칙에 매칭되는지 확인
  bool isLogMutedByRule({required String source, String? code}) {
    return state.any((rule) => rule.matches(logSource: source, logCode: code));
  }
}
