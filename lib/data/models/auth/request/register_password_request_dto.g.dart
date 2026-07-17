// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_password_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterPasswordRequestDto _$RegisterPasswordRequestDtoFromJson(
        Map<String, dynamic> json) =>
    RegisterPasswordRequestDto(
      password: json['password'] as String,
      sessionToken: json['session_token'] as String,
    );

Map<String, dynamic> _$RegisterPasswordRequestDtoToJson(
        RegisterPasswordRequestDto instance) =>
    <String, dynamic>{
      'password': instance.password,
      'session_token': instance.sessionToken,
    };
