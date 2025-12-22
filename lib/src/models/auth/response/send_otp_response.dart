
import 'package:json_annotation/json_annotation.dart';

part 'send_otp_response.g.dart';

@JsonSerializable()
class SendOtpResponse{

  @JsonKey(name: 'status')
  final bool? status;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final SendOtpResponseData? data;



  SendOtpResponse(this.status, this.message, this.data);

  Map<String, dynamic> toJson() => _$SendOtpResponseToJson(this);

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) => _$SendOtpResponseFromJson(json);

}

@JsonSerializable()
class SendOtpResponseData{

  @JsonKey(name: 'otp')
  String? otp;

  @JsonKey(name: 'expiry')
  String? expiry;

  SendOtpResponseData(this.otp, this.expiry);

  factory SendOtpResponseData.fromJson(Map<String, dynamic> json) => _$SendOtpResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpResponseDataToJson(this);

  @override
  String toString() {
    return 'SendOtpResponseData{otp: $otp, expiry: $expiry}';
}







}