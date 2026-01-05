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