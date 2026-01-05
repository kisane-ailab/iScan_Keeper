/// 로컬 스토리지 추상 인터페이스
abstract class LocalStorage {
  /// String 값 조회
  String? getString(String key);

  /// String 값 저장
  Future<bool> setString(String key, String value);

  /// int 값 조회
  int? getInt(String key);

  /// int 값 저장
  Future<bool> setInt(String key, int value);

  /// bool 값 조회
  bool? getBool(String key);

  /// bool 값 저장
  Future<bool> setBool(String key, bool value);

  /// double 값 조회
  double? getDouble(String key);

  /// double 값 저장
  Future<bool> setDouble(String key, double value);

  /// StringList 값 조회
  List<String>? getStringList(String key);

  /// StringList 값 저장
  Future<bool> setStringList(String key, List<String> value);

  /// 키 삭제
  Future<bool> remove(String key);

  /// 키 존재 여부 확인
  bool containsKey(String key);

  /// 모든 데이터 삭제
  Future<bool> clear();
}
