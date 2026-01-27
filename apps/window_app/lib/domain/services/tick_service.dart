import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tick_service.g.dart';

/// 전역 1초 타이머 - 경과시간 표시용
/// 개별 위젯에서 타이머를 만들지 않고 이 Provider를 watch
@Riverpod(keepAlive: true)
class TickService extends _$TickService {
  Timer? _timer;

  @override
  int build() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state + 1;
    });

    ref.onDispose(() {
      _timer?.cancel();
    });

    return 0;
  }
}
