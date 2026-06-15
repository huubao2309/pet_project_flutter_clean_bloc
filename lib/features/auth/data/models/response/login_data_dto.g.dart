// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginDataDto _$LoginDataDtoFromJson(Map<String, dynamic> json) => LoginDataDto(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      userInfo: UserDto.fromJson(json['user_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginDataDtoToJson(LoginDataDto instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user_info': instance.userInfo,
    };
