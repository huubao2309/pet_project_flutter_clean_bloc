// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequestDto _$SignUpRequestDtoFromJson(Map<String, dynamic> json) =>
    SignUpRequestDto(
      email: json['email'] as String,
      password: json['password'] as String,
      language: json['language'] as String,
      verify: json['verify'] as bool?,
      statusUpdate: json['status_update'] as bool?,
    );

Map<String, dynamic> _$SignUpRequestDtoToJson(SignUpRequestDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'language': instance.language,
      'verify': instance.verify,
      'status_update': instance.statusUpdate,
    };
