import 'package:json_annotation/json_annotation.dart';

part 'sign_up_request_dto.g.dart';

@JsonSerializable()
class SignUpRequestDto {
  const SignUpRequestDto({
    required this.phone,
    required this.language,
    this.verify,
    this.statusUpdate,
  });

  final String phone;
  final String language;
  final bool? verify;

  @JsonKey(name: 'status_update')
  final bool? statusUpdate;

  factory SignUpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestDtoToJson(this);
}
