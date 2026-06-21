import 'package:json_annotation/json_annotation.dart';

part 'change_password_request_dto.g.dart';

@JsonSerializable()
class ChangePasswordRequestDto {
  const ChangePasswordRequestDto({
    required this.currentPassword,
    required this.newPassword,
  });

  @JsonKey(name: 'current_password')
  final String currentPassword;

  @JsonKey(name: 'new_password')
  final String newPassword;

  factory ChangePasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestDtoToJson(this);
}
