import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/models/chat/recent_chat.dart';
import 'package:leam/src/models/chat/user_chat.dart';
import 'package:leam/src/repositories/chat_repository.dart';

part 'chat_events.dart';

part 'chat_states.dart';

class ChatViewModel extends Bloc<ChatEvents, ChatStates> {
  final ChatRepository chatRepository;

  StreamSubscription? _messagesSubscription;

  ChatViewModel({required this.chatRepository}) : super(ChatInitial()) {
    on<SendMessageEvent>(_sendMessage);
    on<LoadRecentChatsEvent>(_onLoadRecentChats);
    on<GetUserChatsEvent>(_onLoadUserChats);
    on<_OnMessageUpdateEvent>(_onMessagesUpdated);
    on<StopUserChatsEvent>(_onStopUserChats);

    add(LoadRecentChatsEvent());
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

  Future<void> _onLoadRecentChats(
    LoadRecentChatsEvent event,
    Emitter<ChatStates> emit,
  ) async {
    await emit.onEach<QuerySnapshot>(
      chatRepository.getRecentChats(),
      onData: (snapshot) {
        final chats = snapshot.docs
            .map(
              (doc) => RecentChat.fromJson(doc.data()! as Map<String, dynamic>),
            )
            .toList();
        emit(RecentChatsLoaded(chats: chats));
      },
      onError: (error, stackTrace) =>
          emit(RecentChatsError(message: error.toString())),
    );
  }

  Future<void> _onLoadUserChats(
    GetUserChatsEvent event,
    Emitter<ChatStates> emit,
  ) async {
    emit(UserChatsLoading());

    _messagesSubscription = chatRepository
        .getUserChats(chatId: event.userId)
        .listen((snapshot) {
          final chats = snapshot.docs
              .map((doc) => UserChat.fromJson(doc.data()))
              .toList();

          add(_OnMessageUpdateEvent(chats.toList()));

          chatRepository.updateMessageStatus(chatId: event.userId);
        }, onError: (error) => emit(UserChatsError(message: error.toString())));
  }

  void _onMessagesUpdated(
    _OnMessageUpdateEvent event,
    Emitter<ChatStates> emit,
  ) {
    emit(UserChatsLoaded(chats: event.chats));
  }

  Future<void> _onStopUserChats(
    StopUserChatsEvent event,
    Emitter<ChatStates> emit,
  ) async {
    await _messagesSubscription?.cancel();
    _messagesSubscription = null;
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
