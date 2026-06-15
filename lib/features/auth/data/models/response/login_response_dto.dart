import 'package:json_annotation/json_annotation.dart';

import 'login_data_dto.dart';

part 'login_response_dto.g.dart';

@JsonSerializable()
class LoginResponseDto {
  const LoginResponseDto({
    required this.message,
    required this.verdict,
    required this.data,
  });

  final String message;
  final String verdict;
  final LoginDataDto data;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);
}
