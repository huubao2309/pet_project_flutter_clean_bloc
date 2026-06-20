import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_profile.dart';

part 'user_profile_dto.g.dart';

/// Serialization model for the profile payload (`data` of the get-profile
/// response). Field names match the backend's `user_info` shape.
@JsonSerializable()
class UserProfileDto {
  const UserProfileDto({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
  });

  final String id;
  final String fullName;
  final String phone;
  final String? email;

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileDtoToJson(this);

  UserProfile toEntity() => UserProfile(
        id: id,
        fullName: fullName,
        phone: phone,
        email: email,
      );
}
