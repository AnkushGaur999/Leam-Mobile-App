import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:leam/src/core/helpers/timestamp_converter.dart';

part 'chat_room_model.g.dart';

enum MessageType { text, image, video, audio, document }

enum MessageStatus { sent, delivered, read }

@JsonSerializable()
class ChatRoomModel {
  final String id;
  final List<String> participantIds;
  final String? lastMessageContent;
  final MessageType? lastMessageType;
  final String? lastMessageSenderId;

  final Map<String, int> unreadCounts;

  @TimestampConverter()
  DateTime? lastMessageTime;

  @TimestampConverter()
  DateTime? createdAt;

  @TimestampConverter()
  DateTime? updatedAt;

  ChatRoomModel({
    required this.id,
    required this.participantIds,
    this.lastMessageContent,
    this.lastMessageType,
    this.lastMessageSenderId,
    this.lastMessageTime,
    required this.unreadCounts,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json, String id) =>
      _$ChatRoomModelFromJson(json).copyWith(id: id);

  Map<String, dynamic> toJson() => _$ChatRoomModelToJson(this);

  String getOtherParticipantId(String currentUserId) {
    return participantIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
  }

  int getUnreadCount(String userId) {
    return unreadCounts[userId] ?? 0;
  }

  ChatRoomModel copyWith({String? id}) {
    return ChatRoomModel(
      id: id ?? this.id,
      participantIds: participantIds,
      lastMessageContent: lastMessageContent,
      lastMessageType: lastMessageType,
      lastMessageSenderId: lastMessageSenderId,
      lastMessageTime: lastMessageTime,
      unreadCounts: unreadCounts,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
