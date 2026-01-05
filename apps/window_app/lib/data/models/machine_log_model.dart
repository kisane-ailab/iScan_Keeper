import 'package:freezed_annotation/freezed_annotation.dart';

part 'machine_log_model.freezed.dart';
part 'machine_log_model.g.dart';

@freezed
abstract class MachineLogModel with _$MachineLogModel {
  const factory MachineLogModel({
    required String id,
    @JsonKey(name: 'ip_address') required String ipAddress,
    @JsonKey(name: 'port_number') required int portNumber,
    @JsonKey(name: 'status_code') required int statusCode,
    @JsonKey(name: 'response_status') required String responseStatus,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _MachineLogModel;

  factory MachineLogModel.fromJson(Map<String, dynamic> json) =>
      _$MachineLogModelFromJson(json);
}
