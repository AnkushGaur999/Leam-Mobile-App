
part of 'chat_list_view_model.dart';

sealed class ChatListEvent extends Equatable {
  const ChatListEvent();
}

final class LoadChatListEvent extends ChatListEvent {

  const LoadChatListEvent();

  @override
  List<Object?> get props => [];
}

final class ChatListUpdatedEvent extends ChatListEvent {
  final List<ChatRoomModel> chatRooms;
  const ChatListUpdatedEvent(this.chatRooms);

  @override
  List<Object?> get props => [chatRooms];
}

final class CreateChatEvent extends ChatListEvent {
  final String otherUserId;
  const CreateChatEvent(this.otherUserId);

  @override
  List<Object?> get props => [];
}