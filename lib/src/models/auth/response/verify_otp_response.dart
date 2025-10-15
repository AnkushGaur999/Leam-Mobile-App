import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_response.g.dart';

@JsonSerializable()
class VerifyOtpResponse {
  @JsonKey(name: "status")
  bool? status;

  @JsonKey(name: "message")
  String? message;

  @JsonKey(name: "data")
  VerifyResponseData? data;

  VerifyOtpResponse({this.status, this.message, this.data});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);
}

@JsonSerializable()
class VerifyResponseData {
  @JsonKey(name: "otp")
  String? otp;

  @JsonKey(name: "user_id")
  String? userId;

  @JsonKey(name: "token")
  String? token;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "mobile")
  String? mobile;

  @JsonKey(name: "user_type")
  String? userType;

  @JsonKey(name: "profile_pic")
  String? profilePic;

  @JsonKey(name: "is_verified")
  bool? isVerified;

  @JsonKey(name: "is_active")
  bool? isActive;

  @JsonKey(name: "created_at")
  String? createdAt;

  @JsonKey(name: "updated_at")
  String? updatedAt;

  @JsonKey(name: "deleted_at")
  String? deletedAt;

  VerifyResponseData({
    this.otp,
    this.userId,
    this.token,
    this.name,
    this.email,
    this.mobile,
    this.userType,
    this.profilePic,
    this.isVerified,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory VerifyResponseData.fromJson(Map<String, dynamic> json) =>
      _$VerifyResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyResponseDataToJson(this);

  @override
  String toString() {
    return 'VerifyResponseData(otp: $otp, userId: $userId, token: $token, name: $name, email: $email, mobile: $mobile, userType: $userType, profilePic: $profilePic, isVerified: $isVerified, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }
}
