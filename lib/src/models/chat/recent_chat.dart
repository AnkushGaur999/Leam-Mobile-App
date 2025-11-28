import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/helpers/timestamp_converter.dart';

part 'recent_chat.g.dart';

@JsonSerializable()
class RecentChat {
  final String uid;
  final String name;
  final String? imageUrl;
  final String senderId;
  final String receiverId;
  final String message;
  final bool isRead;
  final String type;

  @TimestampConverter()
  DateTime? createdAt;
  
  @TimestampConverter()
  DateTime? updatedAt;

  RecentChat({
    required this.uid,
    required this.name,
    this.imageUrl,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory RecentChat.fromJson(Map<String, dynamic> json) =>
      _$RecentChatFromJson(json);

  Map<String, dynamic> toJson() => _$RecentChatToJson(this);
}
