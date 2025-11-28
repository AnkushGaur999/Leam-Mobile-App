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
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp?,
  ),
  updatedAt: const TimestampConverter().fromJson(
    json['updatedAt'] as Timestamp?,
  ),
);

Map<String, dynamic> _$UserChatToJson(UserChat instance) => <String, dynamic>{
  'name': instance.name,
  'senderId': instance.senderId,
  'receiverId': instance.receiverId,
  'message': instance.message,
  'isRead': instance.isRead,
  'type': instance.type,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
