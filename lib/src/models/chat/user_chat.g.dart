// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserChat _$UserChatFromJson(Map<String, dynamic> json) => UserChat(
  name: json['name'] as String,
  senderId: json['senderId'] as String,
  receiverId: json['receiverId'] as String,
  message: json['message'] as String,
  type: json['type'] as String,
  isRead: json['isRead'] as bool,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserChatToJson(UserChat instance) => <String, dynamic>{
  'name': instance.name,
  'senderId': instance.senderId,
  'receiverId': instance.receiverId,
  'message': instance.message,
  'isRead': instance.isRead,
  'type': instance.type,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
