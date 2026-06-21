import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_data_dto.g.dart';

/// `data` payload of a `POST /auth/verify-otp` response. The backend returns one
/// of two shapes, told apart by [challengeType]:
///   • `none`              → authenticated (login flow): [accessToken],
///     [refreshToken].
///   • `register_password` → sign-up flow: the phone is verified, the user must
///     now set a password. Carries a [sessionToken] for that next step.
///
/// Every shape-specific field is nullable; the repository decides which set is
/// expected from [challengeType].
@JsonSerializable()
class VerifyOtpDataDto {
  const VerifyOtpDataDto({
    this.challengeType,
    this.accessToken,
    this.refreshToken,
    this.sessionToken,
  });

  @JsonKey(name: 'challenge_type')
  final String? challengeType;

  // ── challenge_type "none" (authenticated) ─────────────────────────────────
  @JsonKey(name: 'access_token')
  final String? accessToken;

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  // ── challenge_type "register_password" (set password next) ────────────────
  @JsonKey(name: 'session_token')
  final String? sessionToken;

  /// True when verification authenticated the user outright (login flow).
  bool get isAuthenticated => challengeType == 'none';

  /// True when the user still needs to set a password (sign-up flow).
  bool get requiresPasswordRegistration =>
      challengeType == 'register_password';

  /// True when the user must set a new password (forgot-password flow).
  bool get requiresPasswordReset => challengeType == 'reset_password';

  factory VerifyOtpDataDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpDataDtoToJson(this);
}
