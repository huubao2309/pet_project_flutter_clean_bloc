// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileDto _$UserProfileDtoFromJson(Map<String, dynamic> json) =>
    UserProfileDto(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$UserProfileDtoToJson(UserProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
    };
