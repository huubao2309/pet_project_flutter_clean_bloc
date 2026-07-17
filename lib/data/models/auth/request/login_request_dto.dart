import 'package:json_annotation/json_annotation.dart';

part 'login_request_dto.g.dart';

@JsonSerializable()
class LoginRequestDto {
  const LoginRequestDto({
    required this.phone,
    required this.password,
  });

  final String phone;
  final String password;

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}
