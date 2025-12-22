// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpResponse _$VerifyOtpResponseFromJson(Map<String, dynamic> json) =>
    VerifyOtpResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : VerifyResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VerifyOtpResponseToJson(VerifyOtpResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

VerifyResponseData _$VerifyResponseDataFromJson(Map<String, dynamic> json) =>
    VerifyResponseData(
      otp: json['otp'] as String?,
      userId: json['user_id'] as String?,
      token: json['token'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      userType: json['user_type'] as String?,
      profilePic: json['profile_pic'] as String?,
      isVerified: json['is_verified'] as bool?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
    );

Map<String, dynamic> _$VerifyResponseDataToJson(VerifyResponseData instance) =>
    <String, dynamic>{
      'otp': instance.otp,
      'user_id': instance.userId,
      'token': instance.token,
      'name': instance.name,
      'email': instance.email,
      'mobile': instance.mobile,
      'user_type': instance.userType,
      'profile_pic': instance.profilePic,
      'is_verified': instance.isVerified,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
    };
