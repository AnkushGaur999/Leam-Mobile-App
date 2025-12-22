
part of 'chat_view_model.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

final class ChatInitial extends ChatState {
  const ChatInitial();

  @override
  List<Object?> get props => [];
}

final class ChatLoading extends ChatState {
  const ChatLoading();

  @override
  List<Object?> get props => [];
}

final class ChatLoaded extends ChatState {
  final List<MessageModel> messages;
  final bool isSendingMessage;

  const ChatLoaded({required this.messages, this.isSendingMessage = false});

  ChatLoaded copyWith({List<MessageModel>? messages, bool? isSendingMessage}) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
    );
  }

  @override
  List<Object?> get props => [messages, isSendingMessage];
}

final class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

final class MessageSent extends ChatState {
  @override
  List<Object?> get props => [];
}

final class MessageSendError extends ChatState {
  final String message;

  const MessageSendError(this.message);

  @override
  List<Object?> get props => [message];
}

final class MessageDeleted extends ChatState {
  @override
  List<Object?> get props => [];
}

final class MessageDeleteError extends ChatState {
  final String message;

  const MessageDeleteError(this.message);

  @override
  List<Object?> get props => [message];
}
