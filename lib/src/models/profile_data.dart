import 'package:json_annotation/json_annotation.dart';

part 'profile_data.g.dart';

@JsonSerializable()
class ProfileData {
  String? uid;
  String? email;
  String? phone;
  String? name;
  String? photoUrl;
  String? gender;
  String? dob;
  String? address;
  String? city;
  String? state;
  String? country;
  String? zipCode;
  String? about;
  String? bio;
  String? fcmToken;
  bool? isVerified;
  bool? isActive;
  String? userType;
  bool? isBlocked;
  bool? isSuspended;

  ProfileData({
    this.uid,
    this.email,
    this.phone,
    this.name,
    this.photoUrl,
    this.gender,
    this.fcmToken,
    this.dob,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.about,
    this.bio,
    this.isVerified,
    this.isActive,
    this.userType,
    this.isBlocked,
    this.isSuspended,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => _$ProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}
