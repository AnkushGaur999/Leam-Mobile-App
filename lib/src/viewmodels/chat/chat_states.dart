part of 'chat_view_model.dart';

sealed class ChatStates extends Equatable {}

final class ChatInitial extends ChatStates {
  @override
  List<Object> get props => [];
}


///
/// Recent Chats States
///

class RecentChatsLoading extends ChatStates {
  @override
  List<Object?> get props => [];
}

class RecentChatsLoaded extends ChatStates {
  final List<RecentChat> chats;

  RecentChatsLoaded({required this.chats});

  @override
  List<Object?> get props => [chats];
}

class RecentChatsError extends ChatStates {
  final String message;

  RecentChatsError({required this.message});

  @override
  List<Object?> get props => [message];
}

///
/// Get A Users All Chats
///

class UserChatsLoading extends ChatStates {
  @override
  List<Object?> get props => [];
}

class UserChatsLoaded extends ChatStates {
  final List<UserChat> chats;

  UserChatsLoaded({required this.chats});

  @override
  List<Object?> get props => [chats];
}

class UserChatsError extends ChatStates {
  final String message;

  UserChatsError({required this.message});

  @override
  List<Object?> get props => [message];
}

///
