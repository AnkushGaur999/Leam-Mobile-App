import 'package:json_annotation/json_annotation.dart';

part 'send_otp_request.g.dart';

@JsonSerializable()
class SendOtpRequest {
  final String phoneNumber;
  final String deviceId;

  SendOtpRequest({required this.phoneNumber, required this.deviceId});

  factory SendOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$SendOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpRequestToJson(this);

  @override
  String toString() {
    return 'SendOtpRequest{phoneNumber: $phoneNumber, deviceId: $deviceId}';
  }
}
