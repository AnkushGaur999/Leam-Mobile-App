
part of 'chat_list_view_model.dart';

sealed class ChatListState extends Equatable {
  const ChatListState();
}

final class ChatListInitial extends ChatListState {
  const ChatListInitial();

  @override
  List<Object?> get props => [];
}

final class ChatListLoading extends ChatListState {
  const ChatListLoading();

  @override
  List<Object?> get props => [];
}

final class ChatListLoaded extends ChatListState {
  final List<ChatRoomModel> chatRooms;

  const ChatListLoaded(this.chatRooms);

  @override
  List<Object?> get props => [chatRooms];
}

final class ChatListError extends ChatListState {
  final String message;

  const ChatListError(this.message);

  @override
  List<Object?> get props => [message];
}

final class ChatCreating extends ChatListState {
  const ChatCreating();

  @override
  List<Object?> get props => [];
}

final class ChatCreated extends ChatListState {
  final String chatRoomId;
  final String otherUserId;

  const ChatCreated(this.chatRoomId, this.otherUserId);

  @override
  List<Object?> get props => [chatRoomId];
}

final class ChatCreationError extends ChatListState {
  final String message;

  const ChatCreationError(this.message);

  @override
  List<Object?> get props => [message];
}
