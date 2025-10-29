import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/repositories/chat_repository.dart';

part 'chat_events.dart';

part 'chat_states.dart';

class ChatViewModel extends Bloc<ChatEvents, ChatStates> {
  final ChatRepository chatRepository;

  ChatViewModel({required this.chatRepository}) : super(ChatInitial()) {
    on<SendMessageEvent>(_sendMessage);
  }

  Future<void> _sendMessage(
    SendMessageEvent event,
    Emitter<ChatStates> emit,
  ) async {
    chatRepository.sendMessage(
      message: event.message,
      receiverId: event.receiverId,
    );
  }
}
