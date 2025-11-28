// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentChat _$RecentChatFromJson(Map<String, dynamic> json) => RecentChat(
  uid: json['uid'] as String,
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String?,
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

Map<String, dynamic> _$RecentChatToJson(RecentChat instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'message': instance.message,
      'isRead': instance.isRead,
      'type': instance.type,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
