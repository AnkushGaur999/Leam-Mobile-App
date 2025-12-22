// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomModel _$ChatRoomModelFromJson(Map<String, dynamic> json) =>
    ChatRoomModel(
      id: json['id'] as String,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastMessageContent: json['lastMessageContent'] as String?,
      lastMessageType: $enumDecodeNullable(
        _$MessageTypeEnumMap,
        json['lastMessageType'],
      ),
      lastMessageSenderId: json['lastMessageSenderId'] as String?,
      lastMessageTime: const TimestampConverter().fromJson(
        json['lastMessageTime'] as Timestamp?,
      ),
      unreadCounts: Map<String, int>.from(json['unreadCounts'] as Map),
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp?,
      ),
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp?,
      ),
    );

Map<String, dynamic> _$ChatRoomModelToJson(ChatRoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participantIds': instance.participantIds,
      'lastMessageContent': instance.lastMessageContent,
      'lastMessageType': _$MessageTypeEnumMap[instance.lastMessageType],
      'lastMessageSenderId': instance.lastMessageSenderId,
      'unreadCounts': instance.unreadCounts,
      'lastMessageTime': const TimestampConverter().toJson(
        instance.lastMessageTime,
      ),
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
