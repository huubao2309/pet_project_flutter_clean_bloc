// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_challenge_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpChallengeDto _$OtpChallengeDtoFromJson(Map<String, dynamic> json) =>
    OtpChallengeDto(
      challengeType: json['challenge_type'] as String?,
      sessionToken: json['session_token'] as String?,
      otpResendSecs: (json['otp_resend_secs'] as num?)?.toInt(),
      otpEnableResendSecs: (json['otp_enable_resend_secs'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OtpChallengeDtoToJson(OtpChallengeDto instance) =>
    <String, dynamic>{
      'challenge_type': instance.challengeType,
      'session_token': instance.sessionToken,
      'otp_resend_secs': instance.otpResendSecs,
      'otp_enable_resend_secs': instance.otpEnableResendSecs,
    };
