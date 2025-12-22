import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/helpers/timestamp_converter.dart';

part 'last_chat_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LastChatModel {
  final String senderId;
  final String name;
  final String content;
  final List<String> participants;
  final bool isRead;
  final String type;

  @TimestampConverter()
  final DateTime? createdAt;

  @TimestampConverter()
  final DateTime? updatedAt;

  LastChatModel({
    required this.senderId,
    required this.name,
    required this.content,
    required this.type,
    required this.participants,
    required this.isRead,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();

  factory LastChatModel.fromJson(Map<String, dynamic> json) =>
      _$LastChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$LastChatModelToJson(this);
}
