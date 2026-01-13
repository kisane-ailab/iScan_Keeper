import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:window_app/data/models/mute_rule_model.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';

part 'mute_rule_local_datasource.g.dart';

const _kMuteRulesKey = 'mute_rules';

/// MuteRule 로컬 저장소
class MuteRuleLocalDatasource {
  final SharedPreferences _prefs;
  final _uuid = const Uuid();

  MuteRuleLocalDatasource(this._prefs);

  /// 모든 규칙 조회
  List<MuteRule> getRules() {
    final jsonString = _prefs.getString(_kMuteRulesKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((e) => MuteRule.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      logger.e('Failed to parse mute rules: $e');
      return [];
    }
  }

  /// 규칙 추가
  Future<MuteRule> addRule({String? source, String? code}) async {
    final rules = getRules();

    // 중복 체크
    final isDuplicate = rules.any(
      (r) => r.source == source && r.code == code,
    );
    if (isDuplicate) {
      throw Exception('이미 동일한 규칙이 존재합니다');
    }

    final newRule = MuteRule(
      id: _uuid.v4(),
      source: source,
      code: code,
      createdAt: DateTime.now(),
    );

    rules.add(newRule);
    await _saveRules(rules);

    logger.i('Mute rule added: ${newRule.description}');
    return newRule;
  }

  /// 규칙 삭제
  Future<void> removeRule(String id) async {
    final rules = getRules();
    rules.removeWhere((r) => r.id == id);
    await _saveRules(rules);

    logger.i('Mute rule removed: $id');
  }

  /// 모든 규칙 삭제
  Future<void> clearRules() async {
    await _prefs.remove(_kMuteRulesKey);
    logger.i('All mute rules cleared');
  }

  /// 로그가 규칙에 매칭되는지 확인
  bool isLogMutedByRule({required String source, String? code}) {
    final rules = getRules();
    return rules.any((rule) => rule.matches(logSource: source, logCode: code));
  }

  Future<void> _saveRules(List<MuteRule> rules) async {
    final jsonList = rules.map((r) => r.toJson()).toList();
    await _prefs.setString(_kMuteRulesKey, json.encode(jsonList));
  }
}

/// SharedPreferences Provider
@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return await SharedPreferences.getInstance();
}

/// MuteRuleLocalDatasource Provider
@riverpod
MuteRuleLocalDatasource muteRuleLocalDatasource(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider).requireValue;
  return MuteRuleLocalDatasource(prefs);
}
