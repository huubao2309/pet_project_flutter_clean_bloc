import 'package:json_annotation/json_annotation.dart';

part 'register_password_data_dto.g.dart';

/// `data` payload of a `POST /auth/register-password` response. On success the
/// account is fully created and signed in, so the backend returns the auth
/// tokens (the same shape as a `challenge_type: "none"` login).
@JsonSerializable()
class RegisterPasswordDataDto {
  const RegisterPasswordDataDto({
    this.challengeType,
    this.accessToken,
    this.refreshToken,
  });

  @JsonKey(name: 'challenge_type')
  final String? challengeType;

  @JsonKey(name: 'access_token')
  final String? accessToken;

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  factory RegisterPasswordDataDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterPasswordDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterPasswordDataDtoToJson(this);
}
