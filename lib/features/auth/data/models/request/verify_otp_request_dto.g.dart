// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpRequestDto _$VerifyOtpRequestDtoFromJson(Map<String, dynamic> json) =>
    VerifyOtpRequestDto(
      code: json['otp'] as String,
      sessionToken: json['session_token'] as String,
    );

Map<String, dynamic> _$VerifyOtpRequestDtoToJson(
        VerifyOtpRequestDto instance) =>
    <String, dynamic>{
      'otp': instance.code,
      'session_token': instance.sessionToken,
    };
