
import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_request.g.dart';

@JsonSerializable()
class VerifyOtpRequest{
  @JsonKey(name: 'otp')
  final String otp;

  @JsonKey(name: 'mobile_number')
  final String mobileNumber;

  VerifyOtpRequest({
    required this.otp,
    required this.mobileNumber,
  });

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) => _$VerifyOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);


}