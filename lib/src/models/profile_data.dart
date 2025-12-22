import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:leam/src/core/helpers/timestamp_converter.dart';

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
  bool? isOnline;
  String? about;
  String? bio;
  bool? isVerified;
  bool? isActive;
  String? userType;
  bool? isBlocked;
  bool? isSuspended;

  @TimestampConverter()
  DateTime? createdAt;

  @TimestampConverter()
  DateTime? deletedAt;

  @TimestampConverter()
  DateTime? lastSeen;

  @TimestampConverter()
  DateTime? updatedAt;

  ProfileData({
    this.uid,
    this.email,
    this.phone = "",
    this.name,
<<<<<<< Updated upstream
    this.photoUrl,
    this.gender,
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
=======
    this.photoUrl = "",
    this.gender = "",
    this.fcmToken,
    this.dob = "",
    this.address = "",
    this.city = "",
    this.state = "",
    this.country = "",
    this.zipCode = "",
    this.about = "Hey! Let's Lean..",
    this.bio = "",
    this.isVerified= false,
    this.isActive = true,
    this.isOnline = true,
    this.userType = "customer",
    this.isBlocked = false,
    this.isSuspended = false,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final DateTime? lastSeen,
    this.deletedAt,
  }): createdAt = createdAt ?? DateTime.now(),
        lastSeen =lastSeen ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
>>>>>>> Stashed changes

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}
