import 'package:json_annotation/json_annotation.dart';

part 'register_password_request_dto.g.dart';

/// Request body for `POST /auth/register-password`: the chosen password plus the
/// session token issued by the verify-otp step of the sign-up flow.
@JsonSerializable()
class RegisterPasswordRequestDto {
  const RegisterPasswordRequestDto({
    required this.password,
    required this.sessionToken,
  });

  final String password;

  @JsonKey(name: 'session_token')
  final String sessionToken;

  factory RegisterPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterPasswordRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterPasswordRequestDtoToJson(this);
}
