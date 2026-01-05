import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_view_model.freezed.dart';
part 'settings_view_model.g.dart';

/// Settings 화면 상태
@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState() = _SettingsState;
}

/// Settings ViewModel
@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  @override
  SettingsState build() {
    return const SettingsState();
  }
}
