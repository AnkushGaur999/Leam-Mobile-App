part of 'chat_view_model.dart';

sealed class ChatEvents extends Equatable {
  const ChatEvents();
}

final class SendMessageEvent extends ChatEvents {
  final String message;
  final String receiverId;

  const SendMessageEvent({required this.message, required this.receiverId});

  @override
  List<Object?> get props => [message, receiverId];
}

final class LoadRecentChatsEvent extends ChatEvents {
  @override
  List<Object?> get props => [];
}


final class GetUserChatsEvent extends ChatEvents {
  final String userId;

  const GetUserChatsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final class StopUserChatsEvent extends ChatEvents {
  @override
  List<Object?> get props => [];
}


final class _OnMessageUpdateEvent extends ChatEvents {
  final List<UserChat> chats;
  const _OnMessageUpdateEvent(this.chats);
  @override
  List<Object?> get props => [chats];
}

