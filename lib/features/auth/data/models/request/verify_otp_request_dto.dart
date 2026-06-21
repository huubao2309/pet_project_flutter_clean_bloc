import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_request_dto.g.dart';

/// Request body for `POST /auth/verify-otp`: the code the user typed plus the
/// session token issued by the login / sign-up step that opened the OTP screen.
@JsonSerializable()
class VerifyOtpRequestDto {
  const VerifyOtpRequestDto({
    required this.code,
    required this.sessionToken,
  });

  @JsonKey(name: 'otp')
  final String code;

  @JsonKey(name: 'session_token')
  final String sessionToken;

  factory VerifyOtpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpRequestDtoToJson(this);
}
