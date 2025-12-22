// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  id: json['id'] as String,
  chatRoomId: json['chatRoomId'] as String,
  name: json['name'] as String,
  senderId: json['senderId'] as String,
  content: json['content'] as String,
  type: $enumDecode(_$MessageTypeEnumMap, json['type']),
  isRead: json['isRead'] as bool,
  mediaUrl: json['mediaUrl'] as String?,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  readAt: const TimestampConverter().fromJson(json['readAt'] as Timestamp?),
  sentAt: const TimestampConverter().fromJson(json['sentAt'] as Timestamp?),
  deliveredAt: const TimestampConverter().fromJson(
    json['deliveredAt'] as Timestamp?,
  ),
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp?,
  ),
  updatedAt: const TimestampConverter().fromJson(
    json['updatedAt'] as Timestamp?,
  ),
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatRoomId': instance.chatRoomId,
      'name': instance.name,
      'senderId': instance.senderId,
      'content': instance.content,
      'isRead': instance.isRead,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'mediaUrl': instance.mediaUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'metadata': instance.metadata,
      'sentAt': const TimestampConverter().toJson(instance.sentAt),
      'deliveredAt': const TimestampConverter().toJson(instance.deliveredAt),
      'readAt': const TimestampConverter().toJson(instance.readAt),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.video: 'video',
  MessageType.audio: 'audio',
  MessageType.document: 'document',
};
