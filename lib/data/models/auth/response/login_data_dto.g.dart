// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginDataDto _$LoginDataDtoFromJson(Map<String, dynamic> json) => LoginDataDto(
      challengeType: json['challenge_type'] as String?,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      sessionToken: json['session_token'] as String?,
      otpResendSecs: (json['otp_resend_secs'] as num?)?.toInt(),
      otpEnableResendSecs: (json['otp_enable_resend_secs'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginDataDtoToJson(LoginDataDto instance) =>
    <String, dynamic>{
      'challenge_type': instance.challengeType,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'session_token': instance.sessionToken,
      'otp_resend_secs': instance.otpResendSecs,
      'otp_enable_resend_secs': instance.otpEnableResendSecs,
    };
