import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:leam/src/core/helpers/timestamp_converter.dart';

import 'chat_room_model.dart';

part 'message_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MessageModel {
  final String id;
  final String chatRoomId;
  final String name;
  final String senderId;
  final String content;
  final bool isRead;
  final MessageType type;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final Map<String, dynamic>? metadata;

  @TimestampConverter()
  DateTime? sentAt;

  @TimestampConverter()
  DateTime? deliveredAt;

  @TimestampConverter()
  DateTime? readAt;

  @TimestampConverter()
  DateTime? createdAt;

  @TimestampConverter()
  DateTime? updatedAt;

  MessageModel({
    required this.id,
    required this.chatRoomId,
    required this.name,
    required this.senderId,
    required this.content,
    required this.type,
    required this.isRead,
    this.mediaUrl,
    this.thumbnailUrl,
    this.metadata,
    this.readAt,
    final DateTime? sentAt,
    final DateTime? deliveredAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) : sentAt = sentAt ?? DateTime.now(),
       deliveredAt = deliveredAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory MessageModel.fromJson(Map<String, dynamic> json, String id) =>
      _$MessageModelFromJson(json)..copyWith(id: id);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  MessageStatus get status {
    if (readAt != null) return MessageStatus.read;
    if (deliveredAt != null) return MessageStatus.delivered;
    return MessageStatus.sent;
  }

  MessageModel copyWith({
    DateTime? deliveredAt,
    DateTime? readAt,
    required String id,
  }) {
    return MessageModel(
      id: id,
      chatRoomId: chatRoomId,
      senderId: senderId,
      content: content,
      type: type,
      name: name,
      isRead: isRead,
      sentAt: sentAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
      mediaUrl: mediaUrl,
      thumbnailUrl: thumbnailUrl,
      metadata: metadata,
    );
  }
}
