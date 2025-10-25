// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) =>
    SignUpRequest(
      fName: json['fName'] as String,
      lName: json['lName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) =>
    <String, dynamic>{
      'fName': instance.fName,
      'lName': instance.lName,
      'email': instance.email,
      'password': instance.password,
    };
