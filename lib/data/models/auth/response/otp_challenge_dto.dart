import 'package:json_annotation/json_annotation.dart';

import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/otp_challenge.dart';

part 'otp_challenge_dto.g.dart';

/// Serialization model for an OTP-challenge `data` payload. Used by responses
/// that may carry a `challenge_type: "verify_otp"` step (currently sign-up).
///
/// Every field is nullable: when the backend returns no challenge the values
/// are simply absent and [requiresOtpVerification] is false.
@JsonSerializable()
class OtpChallengeDto {
  const OtpChallengeDto({
    this.challengeType,
    this.sessionToken,
    this.otpResendSecs,
    this.otpEnableResendSecs,
  });

  @JsonKey(name: 'challenge_type')
  final String? challengeType;

  @JsonKey(name: 'session_token')
  final String? sessionToken;

  @JsonKey(name: 'otp_resend_secs')
  final int? otpResendSecs;

  /// Seconds the "Resend" button stays disabled; null → enabled immediately.
  @JsonKey(name: 'otp_enable_resend_secs')
  final int? otpEnableResendSecs;

  factory OtpChallengeDto.fromJson(Map<String, dynamic> json) =>
      _$OtpChallengeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OtpChallengeDtoToJson(this);

  /// True when the response requires an OTP verification step next.
  bool get requiresOtpVerification => challengeType == 'verify_otp';

  OtpChallenge toEntity() => OtpChallenge(
        resendSecs: otpResendSecs ?? 0,
        // Missing/null → 0 → the "Resend" button is enabled immediately.
        enableResendSecs: otpEnableResendSecs ?? 0,
      );
}
