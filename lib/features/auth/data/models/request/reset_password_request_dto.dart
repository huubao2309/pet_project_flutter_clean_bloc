import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request_dto.g.dart';

@JsonSerializable()
class ResetPasswordRequestDto {
  const ResetPasswordRequestDto({
    required this.newPassword,
    required this.token,
  });

  @JsonKey(name: 'password')
  final String newPassword;
  final String token;

  factory ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestDtoToJson(this);
}
