
import 'package:json_annotation/json_annotation.dart';

part 'recent_chat.g.dart';

@JsonSerializable()
class RecentChat{

  final String name;
  final String? imageUrl;
  final String senderId;
  final String receiverId;
  final String message;
  final bool isRead;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  RecentChat({
    required this.name,
    this.imageUrl,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory RecentChat.fromJson(Map<String, dynamic> json) => _$RecentChatFromJson(json);

  Map<String, dynamic> toJson() => _$RecentChatToJson(this);


}