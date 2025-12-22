// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LastChatModel _$LastChatModelFromJson(Map<String, dynamic> json) =>
    LastChatModel(
      senderId: json['senderId'] as String,
      name: json['name'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isRead: json['isRead'] as bool,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp?,
      ),
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp?,
      ),
    );

Map<String, dynamic> _$LastChatModelToJson(LastChatModel instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'name': instance.name,
      'content': instance.content,
      'participants': instance.participants,
      'isRead': instance.isRead,
      'type': instance.type,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
