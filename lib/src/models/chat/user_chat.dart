import 'package:json_annotation/json_annotation.dart';

part 'user_chat.g.dart';

@JsonSerializable()
class UserChat {
  final String name;
  final String senderId;
  final String receiverId;
  final String message;
  final bool isRead;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserChat({
    required this.name,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory UserChat.fromJson(Map<String, dynamic> json) =>
      _$UserChatFromJson(json);

  Map<String, dynamic> toJson() => _$UserChatToJson(this);
}
