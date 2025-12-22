import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/models/chat/chat_room_model.dart';
import 'package:leam/src/models/chat/message_model.dart';
import 'package:leam/src/repositories/chat_repository.dart';

import '../../core/data/data_state.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatViewModel extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  StreamSubscription<List<MessageModel>>? _messagesSubscription;

  ChatViewModel({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(ChatInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<MessagesUpdatedEvent>(_onMessagesUpdated);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkMessagesAsReadEvent>(_onMarkAsRead);
    on<MarkMessagesAsDeliveredEvent>(_onMarkAsDelivered);
    on<DeleteMessageEvent>(_onDeleteMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    try {
      // Mark messages as delivered when opening chat
      await _chatRepository.markMessagesAsDelivered(event.chatRoomId);

      await _messagesSubscription?.cancel();

      _messagesSubscription = _chatRepository
          .getMessages(event.chatRoomId)
          .listen(
            (messages) {
              add(MessagesUpdatedEvent(messages));
            },
            onError: (error) {
              add(MessagesUpdatedEvent([]));
            },
          );
    } catch (e) {
      emit(ChatError('Failed to load messages: $e'));
    }
  }

  void _onMessagesUpdated(MessagesUpdatedEvent event, Emitter<ChatState> emit) {
    emit(ChatLoaded(messages: event.messages));
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      emit(currentState.copyWith(isSendingMessage: true));
    }

    final result = await _chatRepository.sendMessage(
      chatRoomId: event.chatRoomId,
      content: event.content,
      type: event.type,
      mediaUrl: event.mediaUrl,
      thumbnailUrl: event.thumbnailUrl,
      metadata: event.metadata,
    );

    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      emit(currentState.copyWith(isSendingMessage: false));
    }

    if (result is DataError) {
      emit(MessageSendError(result.message ?? 'Failed to send message'));
    }
  }

  Future<void> _onMarkAsRead(
    MarkMessagesAsReadEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _chatRepository.markMessagesAsRead(event.chatRoomId);
  }

  Future<void> _onMarkAsDelivered(
    MarkMessagesAsDeliveredEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _chatRepository.markMessagesAsDelivered(event.chatRoomId);
  }

  Future<void> _onDeleteMessage(
    DeleteMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.deleteMessage(
      event.chatRoomId,
      event.messageId,
    );

<<<<<<< Updated upstream
  Future<void> _onLoadUserChats(
    GetUserChatsEvent event,
    Emitter<ChatStates> emit,
  ) async {
    emit(UserChatsLoading());
    // await emit.onEach<QuerySnapshot>(
    //   chatRepository.getUserChats(chatId: event.userId),
    //   onData: (snapshot) {
    //     final chats = snapshot.docs
    //         .map(
    //           (doc) => UserChat.fromJson(doc.data()! as Map<String, dynamic>),
    //         )
    //         .toList();
    //     emit(UserChatsLoaded(chats: chats.reversed.toList()));
    //     chatRepository.updateMessageStatus(chatId: event.userId);
    //   },
    //   onError: (error, stackTrace) =>
    //       emit(UserChatsError(message: error.toString())),
    // );


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
=======
    if (result is DataSuccess) {
      emit(MessageDeleted());
    } else if (result is DataError) {
      emit(MessageDeleteError(result.message ?? 'Failed to delete message'));
    }
>>>>>>> Stashed changes
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
