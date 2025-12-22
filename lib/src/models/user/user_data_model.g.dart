// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDataModel _$UserDataModelFromJson(Map<String, dynamic> json) =>
    UserDataModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      gender: json['gender'] as String?,
      about: json['about'] as String?,
      isOnline: json['isOnline'] as bool?,
      bio: json['bio'] as String?,
      lastSeen: const TimestampConverter().fromJson(
        json['lastSeen'] as Timestamp?,
      ),
    );

Map<String, dynamic> _$UserDataModelToJson(UserDataModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'phone': instance.phone,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'gender': instance.gender,
      'about': instance.about,
      'isOnline': instance.isOnline,
      'bio': instance.bio,
      'lastSeen': const TimestampConverter().toJson(instance.lastSeen),
    };
