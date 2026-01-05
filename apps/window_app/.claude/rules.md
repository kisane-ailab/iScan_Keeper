# 프로젝트 코딩 규칙

## Import 규칙

### 필수: 절대경로(패키지) Import 사용
- **반드시** `package:window_app/...` 형태의 절대경로 import 사용
- 상대경로 import (`../`, `./`) 사용 금지

### 올바른 예시 (절대경로)
```dart
import 'package:window_app/domain/services/telegram_service.dart';
import 'package:window_app/data/repositories/telegram_repository_impl.dart';
import 'package:window_app/infrastructure/network/dio/dio_provider.dart';
```

### 금지된 예시 (상대경로)
```dart
// 사용 금지
import '../../../domain/services/telegram_service.dart';
import '../../repositories/telegram_repository_impl.dart';
import '../dio/dio_provider.dart';
```

## Riverpod Provider 규칙

### 필수: 코드 제네레이션 사용
- **반드시** `@riverpod` 어노테이션을 사용한 코드 제네레이션 형태로 Provider 작성
- 구형 Provider 문법 사용 금지

### 올바른 예시 (코드 제네레이션)
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_provider.g.dart';

// 일반 Provider
@riverpod
MyClass myClass(Ref ref) {
  return MyClass();
}

// keepAlive Provider (앱 생명주기 동안 유지)
@Riverpod(keepAlive: true)
MyClass myClass(Ref ref) {
  return MyClass();
}

// Async Provider
@riverpod
Future<MyClass> myClass(Ref ref) async {
  return await someAsyncOperation();
}

// Notifier Provider
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  MyState build() {
    return MyState();
  }
}
```

### 금지된 예시 (구형 문법)
```dart
// 사용 금지
final myProvider = Provider<MyClass>((ref) {
  return MyClass();
});

// 사용 금지
final myFutureProvider = FutureProvider<MyClass>((ref) async {
  return await someAsyncOperation();
});

// 사용 금지
final myStateProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier();
});
```

### main.dart에서 override가 필요한 경우
- SharedPreferences 등 앱 시작 전 초기화가 필요한 경우에도 @riverpod 사용
- `throw UnimplementedError`로 정의하고 main.dart에서 override

```dart
// infrastructure/storage/shared_preferences_provider.dart
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
}

// main.dart
final container = ProviderContainer(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
  ],
);
```

## ViewModel State 규칙

### 필수: Freezed 사용
- ViewModel의 State 클래스는 **반드시** `@freezed` 어노테이션을 사용
- 수동으로 `copyWith` 작성 금지

### 올바른 예시 (Freezed)
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_view_model.freezed.dart';

@freezed
class MyState with _$MyState {
  const factory MyState({
    @Default(false) bool isLoading,
    @Default(0) double progress,
    String? error,
  }) = _MyState;
}
```

### 금지된 예시 (수동 copyWith)
```dart
// 사용 금지
class MyState {
  final bool isLoading;
  final double progress;

  const MyState({this.isLoading = false, this.progress = 0});

  MyState copyWith({bool? isLoading, double? progress}) {
    return MyState(
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
    );
  }
}
```

## 네이밍 컨벤션

### 레이어별 클래스 네이밍

#### Data Layer (`data/`)
| 용도 | 접미사 | 예시 |
|------|--------|------|
| DB/API DTO | `*Model` | `MachineLogModel`, `UserModel` |
| Repository 구현체 | `*RepositoryImpl` | `TelegramRepositoryImpl` |
| 원격 데이터소스 | `*RemoteDatasource` | `TelegramRemoteDatasource` |
| 로컬 데이터소스 | `*LocalDatasource` | `TelegramLocalDatasource` |

#### Domain Layer (`domain/`)
| 용도 | 접미사 | 예시 |
|------|--------|------|
| 비즈니스 엔티티 | `*Entity` | `MachineLogEntity`, `UserEntity` |
| 비즈니스 로직 | `*Service` | `MachineLogRealtimeService` |
| 유스케이스 | `*Usecase` | `GetTelegramUpdatesUsecase` |
| Repository 인터페이스 | `*Repository` | `TelegramRepository` |

#### Infrastructure Layer (`infrastructure/`)
| 용도 | 접미사 | 예시 |
|------|--------|------|
| 외부 SDK 래퍼 | `*Client` | `SupabaseClient` |
| 시스템 리소스 관리 | `*Manager` | `AppTrayManager` |
| 이벤트/알림 처리 | `*Handler` | `NotificationHandler` |
| 컨트롤러 래퍼 | `*Controller` | `AppWebViewController` |
| 초기화 유틸 | `*Initializer` | `SupabaseInitializer` |

### Model vs Entity 구분

#### Model (순수 데이터)
- **위치**: `data/models/`
- **용도**: DB 테이블/API 응답과 1:1 매핑되는 DTO
- **특징**: `@JsonKey`, `@freezed` 사용, 비즈니스 로직 없음

```dart
// data/models/machine_log_model.dart
@freezed
abstract class MachineLogModel with _$MachineLogModel {
  const factory MachineLogModel({
    required String id,
    @JsonKey(name: 'ip_address') required String ipAddress,
    @JsonKey(name: 'status_code') required int statusCode,
  }) = _MachineLogModel;

  factory MachineLogModel.fromJson(Map<String, dynamic> json) =>
      _$MachineLogModelFromJson(json);
}
```

#### Entity (도메인 해석)
- **위치**: `domain/entities/`
- **용도**: 비즈니스 로직이 포함된 도메인 객체
- **특징**: 순수 Dart, 비즈니스 메서드 포함, 외부 의존성 없음

```dart
// domain/entities/machine_log_entity.dart
class MachineLogEntity {
  final String id;
  final String ipAddress;
  final int statusCode;
  final DateTime createdAt;

  MachineLogEntity({...});

  // 비즈니스 로직
  bool get isCritical => statusCode >= 500;
  bool get needsAttention => isCritical && !isHandled;
  Duration get responseTime => DateTime.now().difference(createdAt);
}
```

### Service 사용 규칙

**중요: `Service`라는 표현은 Domain Layer에서만 사용**

```dart
// 올바른 예시
domain/services/machine_log_realtime_service.dart  // ✅ Domain Service
domain/services/telegram_service.dart               // ✅ Domain Service

// 금지된 예시
infrastructure/supabase/supabase_service.dart       // ❌ → supabase_client.dart
infrastructure/notification/notification_service.dart // ❌ → notification_handler.dart
```

## Logger 사용 규칙

### 패키지
- `logger` 패키지 사용 (색상/이모지 지원)
- 커스텀 인터페이스 없이 직접 사용

### Provider (Riverpod 환경)
```dart
import 'package:logger/logger.dart';
import 'package:window_app/infrastructure/logger/app_logger.dart';

// Notifier/ViewModel 내부
Logger get _logger => ref.read(appLoggerProvider);

_logger.d('디버그 메시지');
_logger.i('정보 메시지');
_logger.w('경고 메시지');
_logger.e('에러 메시지', error: e, stackTrace: st);
```

### Static 사용 (Riverpod 외부)
```dart
import 'package:window_app/infrastructure/logger/app_logger.dart';

// 전역 logger 인스턴스 직접 사용
logger.i('정보 메시지');
logger.e('에러 메시지', error: e);
```

### 로그 메시지 규칙
- **반드시 한글로 작성**
- 간결하고 명확하게 작성
- 변수 값은 `$variable` 형태로 포함

```dart
// 올바른 예시
logger.i('업데이트 조회 시작, 강제새로고침: $forceRefresh');
logger.e('원격 데이터 조회 실패', error: e);
logger.w('차단된 도메인: $host');

// 금지된 예시
logger.i('getUpdates called');  // ❌ 영어
logger.e('Failed to fetch');    // ❌ 영어
```

## 함수 파라미터 규칙

### 기본 규칙
1. `context`, `ref`는 **항상 positional parameter**
2. 인수가 **1개**면 → **positional**
3. 인수가 **2개 이상**이면 → **named** (context, ref 제외)
4. 패키지에서 정의된 형태라 변경 불가 시 → 패키지 형식 따르고 주석 추가

### 예시

```dart
// 인수 1개 - positional
void doSomething(String value) {}
void loadData(int id) {}

// 인수 2개 이상 - named
void updateUser({required String name, required int age}) {}
void fetchData({required String url, int? timeout, bool? cache}) {}

// context, ref + 인수 1개 - context/ref는 positional, 나머지도 positional
void onTap(BuildContext context, WidgetRef ref, String id) {}

// context, ref + 인수 2개 이상 - context/ref는 positional, 나머지는 named
void onSubmit(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required String description,
}) {}

// 패키지 형식 따라야 하는 경우 - 주석 추가
/// [Package Override] go_router 콜백 형식
void onRedirect(BuildContext context, GoRouterState state) {}
```

## BasePage / BaseShell 라이프사이클 규칙

### 위치
- **BasePage**: `presentation/layout/base_page.dart` - 일반 화면용 추상 클래스
- **BaseShell**: `presentation/layout/base_shell.dart` - 쉘 레이아웃용 추상 클래스
- 구현체 (MainShell 등)는 해당 페이지 폴더에 위치

### 라이프사이클 메서드 시그니처
- `context`, `ref`는 positional parameter
- 추가 인수는 함수 파라미터 규칙에 따름 (1개면 positional, 2개 이상이면 named)

```dart
// 추가 인수 없음
void onDispose(BuildContext context, WidgetRef ref) {}
void onResumed(BuildContext context, WidgetRef ref) {}

// 추가 인수 1개 - positional (optional이면 [] 사용)
void onInit(
  BuildContext context,
  WidgetRef ref, [
  List<StreamSubscription>? subscriptions,
]) {}
```

### Stream 구독 관리
- `onInit`의 `subscriptions` 파라미터에 추가하면 자동으로 dispose 시 취소됨
- 별도의 `useEffect` 사용 금지 - `on~` 메서드 오버라이드로 처리

```dart
// 금지된 예시 - useEffect 직접 사용
class MyScreen extends BasePage {
  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    useEffect(() {  // ❌ 금지
      final sub = stream.listen(...);
      return sub.cancel;
    }, []);
    return Container();
  }
}

// 올바른 예시 - onInit 오버라이드
class MyScreen extends BasePage {
  @override
  void onInit(BuildContext context, WidgetRef ref, [
    List<StreamSubscription>? subscriptions,
  ]) {
    final sub = stream.listen(...);
    subscriptions?.add(sub);  // ✅ 자동 관리
  }
}
```

## 빌드 명령어
```bash
dart run build_runner build --delete-conflicting-outputs
```
