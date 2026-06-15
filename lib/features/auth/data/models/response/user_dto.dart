import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user_entity.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  const UserDto({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
  });

  final String id;
  final String fullName;
  final String phone;
  final String? email;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  UserEntity toEntity() => UserEntity(
        id: id,
        fullName: fullName,
        phone: phone,
        email: email,
      );
}
