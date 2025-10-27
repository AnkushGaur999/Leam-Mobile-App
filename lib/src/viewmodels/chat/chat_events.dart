part of 'chat_view_model.dart';

sealed class ChatEvent extends Equatable {}

final class SendMessageEvent extends ChatEvent {
  final String message;
  final String receiverId;

  SendMessageEvent({required this.message, required this.receiverId});

  @override
  List<Object?> get props => [message, receiverId];
}
