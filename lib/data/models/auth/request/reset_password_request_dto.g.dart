// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordRequestDto _$ResetPasswordRequestDtoFromJson(
        Map<String, dynamic> json) =>
    ResetPasswordRequestDto(
      newPassword: json['password'] as String,
      sessionToken: json['session_token'] as String,
    );

Map<String, dynamic> _$ResetPasswordRequestDtoToJson(
        ResetPasswordRequestDto instance) =>
    <String, dynamic>{
      'password': instance.newPassword,
      'session_token': instance.sessionToken,
    };
