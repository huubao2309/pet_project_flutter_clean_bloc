import 'package:json_annotation/json_annotation.dart';

import 'user_dto.dart';

part 'login_data_dto.g.dart';

@JsonSerializable()
class LoginDataDto {
  const LoginDataDto({
    required this.accessToken,
    required this.refreshToken,
    required this.userInfo,
  });

  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  @JsonKey(name: 'user_info')
  final UserDto userInfo;

  factory LoginDataDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataDtoToJson(this);
}
