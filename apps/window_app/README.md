# window_app

iScan Keeper Flutter Windows 앱

> fvm 사용을 권장합니다. 아래 명령어는 모두 fvm 기반입니다.

## IDE 설정

VS Code 또는 Cursor 사용 시 폴더로 열지 말고 **워크스페이스 파일**로 여세요:

```
window_app.code-workspace
```

워크스페이스 파일로 열어야 프로젝트 설정과 확장 권장사항이 올바르게 적용됩니다.

## 실행

```bash
fvm flutter run
```

## 빌드

```bash
fvm flutter build windows
```

## 환경변수

`.env` 파일은 팀 노션의 iScanKeeper 관련 문서를 참고하세요.

## 코드 제네레이션

`.env` 변경 시 또는 Riverpod, Freezed 등 코드 생성이 필요할 때:

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

watch 모드:
```bash
fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

## 로컬 캐시

앱은 오프라인 지원 및 빠른 로딩을 위해 Hive 로컬 캐시를 사용합니다.

### 캐시 파일 위치
```
%USERPROFILE%\Documents\
```

### 캐시 파일 설명

| 파일명 | 설명 |
|--------|------|
| `system_logs_realtime_cache.hive` | 이벤트/헬스체크 로그 캐시. 앱 시작 시 서버 데이터 로드 전까지 이 캐시를 먼저 표시 |
| `datasets_realtime_cache.hive` | 데이터셋 워크플로우 캐시. 리뷰/승인 대기 중인 데이터셋 목록 |
| `read_status_cache.hive` | 읽음 상태 캐시. 사용자가 확인한 이벤트/헬스체크 ID 목록 (뱃지 카운트용) |

### 캐시 삭제

릴리즈 테스트 또는 문제 발생 시 캐시를 삭제하려면:

```bash
# 배치파일 실행
clear_cache.bat
```

또는 수동으로:
```bash
del "%USERPROFILE%\Documents\*_cache.hive" 2>nul
del "%USERPROFILE%\Documents\*_cache.lock" 2>nul
```

## 응급조치 (문제 발생 시)

```bash
fvm flutter clean
fvm flutter pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

그래도 안되면 windows 폴더 삭제 후 재생성:
```bash
rm -rf windows
fvm flutter create --platforms=windows .
```