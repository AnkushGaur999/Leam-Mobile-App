import 'package:json_annotation/json_annotation.dart';

part 'sign_up_request.g.dart';

@JsonSerializable()
class SignUpRequest {
  final String fName;
  final String lName;
  final String email;
  final String? mobile;
  final String password;

  const SignUpRequest({
    required this.fName,
    required this.lName,
    required this.email,
    required this.mobile,
    required this.password,
  });

  factory SignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
}
