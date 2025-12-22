import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:leam/src/core/helpers/timestamp_converter.dart';

part 'user_data_model.g.dart';

@JsonSerializable()
class UserDataModel {
  final String uid;
  final String email;
  final String? phone;
  final String name;
  final String? photoUrl;
  final String? gender;
  final String? about;
  final bool? isOnline;
  final String? bio;

  @TimestampConverter()
  final DateTime? lastSeen;

  UserDataModel({
    required this.uid,
    required this.email,
    this.phone,
    required this.name,
    this.photoUrl,
    this.gender,
    this.about,
    this.isOnline,
    this.bio,
    this.lastSeen,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);
}
