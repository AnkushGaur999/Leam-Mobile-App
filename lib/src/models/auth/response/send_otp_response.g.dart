// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendOtpResponse _$SendOtpResponseFromJson(Map<String, dynamic> json) =>
    SendOtpResponse(
      json['status'] as bool?,
      json['message'] as String?,
      json['data'] == null
          ? null
          : SendOtpResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SendOtpResponseToJson(SendOtpResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

SendOtpResponseData _$SendOtpResponseDataFromJson(Map<String, dynamic> json) =>
    SendOtpResponseData(json['otp'] as String?, json['expiry'] as String?);

Map<String, dynamic> _$SendOtpResponseDataToJson(
  SendOtpResponseData instance,
) => <String, dynamic>{'otp': instance.otp, 'expiry': instance.expiry};
