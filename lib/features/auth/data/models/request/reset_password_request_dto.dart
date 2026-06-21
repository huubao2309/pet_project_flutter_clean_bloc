import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request_dto.g.dart';

@JsonSerializable()
class ResetPasswordRequestDto {
  const ResetPasswordRequestDto({
    required this.newPassword,
    required this.sessionToken,
  });

  @JsonKey(name: 'password')
  final String newPassword;

  @JsonKey(name: 'session_token')
  final String sessionToken;

  factory ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestDtoToJson(this);
}
