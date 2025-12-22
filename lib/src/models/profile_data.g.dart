// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
  uid: json['uid'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String? ?? "",
  name: json['name'] as String?,
<<<<<<< Updated upstream
  photoUrl: json['photoUrl'] as String?,
  gender: json['gender'] as String?,
  dob: json['dob'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String?,
  country: json['country'] as String?,
  zipCode: json['zipCode'] as String?,
  about: json['about'] as String?,
  bio: json['bio'] as String?,
  isVerified: json['isVerified'] as bool?,
  isActive: json['isActive'] as bool?,
  userType: json['userType'] as String?,
  isBlocked: json['isBlocked'] as bool?,
  isSuspended: json['isSuspended'] as bool?,
=======
  photoUrl: json['photoUrl'] as String? ?? "",
  gender: json['gender'] as String? ?? "",
  fcmToken: json['fcmToken'] as String?,
  dob: json['dob'] as String? ?? "",
  address: json['address'] as String? ?? "",
  city: json['city'] as String? ?? "",
  state: json['state'] as String? ?? "",
  country: json['country'] as String? ?? "",
  zipCode: json['zipCode'] as String? ?? "",
  about: json['about'] as String? ?? "Hey! Let's Lean..",
  bio: json['bio'] as String? ?? "",
  isVerified: json['isVerified'] as bool? ?? false,
  isActive: json['isActive'] as bool? ?? true,
  isOnline: json['isOnline'] as bool? ?? true,
  userType: json['userType'] as String? ?? "customer",
  isBlocked: json['isBlocked'] as bool? ?? false,
  isSuspended: json['isSuspended'] as bool? ?? false,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp?,
  ),
  updatedAt: const TimestampConverter().fromJson(
    json['updatedAt'] as Timestamp?,
  ),
  lastSeen: const TimestampConverter().fromJson(json['lastSeen'] as Timestamp?),
  deletedAt: const TimestampConverter().fromJson(
    json['deletedAt'] as Timestamp?,
  ),
>>>>>>> Stashed changes
);

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'phone': instance.phone,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'gender': instance.gender,
      'dob': instance.dob,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'zipCode': instance.zipCode,
      'isOnline': instance.isOnline,
      'about': instance.about,
      'bio': instance.bio,
      'isVerified': instance.isVerified,
      'isActive': instance.isActive,
      'userType': instance.userType,
      'isBlocked': instance.isBlocked,
      'isSuspended': instance.isSuspended,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'deletedAt': const TimestampConverter().toJson(instance.deletedAt),
      'lastSeen': const TimestampConverter().toJson(instance.lastSeen),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
