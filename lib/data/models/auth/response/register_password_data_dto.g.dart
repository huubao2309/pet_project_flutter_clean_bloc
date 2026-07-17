// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_password_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterPasswordDataDto _$RegisterPasswordDataDtoFromJson(
        Map<String, dynamic> json) =>
    RegisterPasswordDataDto(
      challengeType: json['challenge_type'] as String?,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );

Map<String, dynamic> _$RegisterPasswordDataDtoToJson(
        RegisterPasswordDataDto instance) =>
    <String, dynamic>{
      'challenge_type': instance.challengeType,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };
