// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpDataDto _$VerifyOtpDataDtoFromJson(Map<String, dynamic> json) =>
    VerifyOtpDataDto(
      challengeType: json['challenge_type'] as String?,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      sessionToken: json['session_token'] as String?,
    );

Map<String, dynamic> _$VerifyOtpDataDtoToJson(VerifyOtpDataDto instance) =>
    <String, dynamic>{
      'challenge_type': instance.challengeType,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'session_token': instance.sessionToken,
    };
