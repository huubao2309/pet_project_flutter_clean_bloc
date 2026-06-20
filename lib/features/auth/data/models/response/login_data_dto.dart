import 'package:json_annotation/json_annotation.dart';

part 'login_data_dto.g.dart';

/// Login response payload. The backend returns one of two shapes, told apart by
/// [challengeType]:
///   • `none`        → authenticated: [accessToken], [refreshToken]. Login does
///     NOT return the user profile — it is fetched separately after sign-in.
///   • `verify_otp`  → an OTP step is required first: [sessionToken],
///     [otpResendSecs], [otpValiditySecs] (no tokens yet).
///
/// Every shape-specific field is nullable; the repository decides which set is
/// expected from [challengeType] and fails fast if the contract is violated.
@JsonSerializable()
class LoginDataDto {
  const LoginDataDto({
    this.challengeType,
    this.accessToken,
    this.refreshToken,
    this.sessionToken,
    this.otpResendSecs,
    this.otpEnableResendSecs,
  });

  @JsonKey(name: 'challenge_type')
  final String? challengeType;

  // ── challenge_type "none" (authenticated) ─────────────────────────────────
  @JsonKey(name: 'access_token')
  final String? accessToken;

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  // ── challenge_type "verify_otp" (OTP step required) ───────────────────────
  @JsonKey(name: 'session_token')
  final String? sessionToken;

  @JsonKey(name: 'otp_resend_secs')
  final int? otpResendSecs;

  /// Seconds the "Resend" button stays disabled after the OTP screen opens.
  /// When the backend omits it (null) the button is enabled immediately.
  @JsonKey(name: 'otp_enable_resend_secs')
  final int? otpEnableResendSecs;

  factory LoginDataDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataDtoToJson(this);
}
