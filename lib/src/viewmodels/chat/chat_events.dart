part of 'chat_view_model.dart';

sealed class ChatEvents extends Equatable {}

final class SendMessageEvent extends ChatEvents {
  final String message;
  final String receiverId;

  SendMessageEvent({required this.message, required this.receiverId});

  @override
  List<Object?> get props => [message, receiverId];
}
