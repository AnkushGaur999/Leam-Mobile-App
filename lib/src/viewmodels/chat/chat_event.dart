part of 'chat_view_model.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
}

class LoadMessagesEvent extends ChatEvent {
  final String chatRoomId;

  const LoadMessagesEvent(this.chatRoomId);

  @override
  List<Object?> get props => [chatRoomId];
}

final class MessagesUpdatedEvent extends ChatEvent {
  final List<MessageModel> messages;

  const MessagesUpdatedEvent(this.messages);

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String chatRoomId;
  final String content;
  final MessageType type;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final Map<String, dynamic>? metadata;

  const SendMessageEvent({
    required this.chatRoomId,
    required this.content,
    this.type = MessageType.text,
    this.mediaUrl,
    this.thumbnailUrl,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    chatRoomId,
    content,
    type,
    mediaUrl,
    thumbnailUrl,
    metadata,
  ];
}

final class MarkMessagesAsReadEvent extends ChatEvent {
  final String chatRoomId;

  const MarkMessagesAsReadEvent(this.chatRoomId);

  @override
  List<Object?> get props => [chatRoomId];
}

final class MarkMessagesAsDeliveredEvent extends ChatEvent {
  final String chatRoomId;

  const MarkMessagesAsDeliveredEvent(this.chatRoomId);

  @override
  List<Object?> get props => [chatRoomId];
}

final class DeleteMessageEvent extends ChatEvent {
  final String chatRoomId;
  final String messageId;

  const DeleteMessageEvent(this.chatRoomId, this.messageId);

  @override
  List<Object?> get props => [chatRoomId, messageId];
}
