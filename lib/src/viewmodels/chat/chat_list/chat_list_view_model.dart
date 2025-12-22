import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/models/chat/chat_room_model.dart';
import 'package:leam/src/repositories/chat_repository.dart';

part 'chat_list_event.dart';

part 'chat_list_state.dart';

class ChatListViewModel extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository _chatRepository;
  StreamSubscription<List<ChatRoomModel>>? _chatRoomsSubscription;

  ChatListViewModel({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(ChatListInitial()) {
    on<LoadChatListEvent>(_onLoadChatList);
    on<ChatListUpdatedEvent>(_onChatListUpdated);
    on<CreateChatEvent>(_onCreateChat);

    add(LoadChatListEvent());
  }

  Future<void> _onLoadChatList(
    LoadChatListEvent event,
    Emitter<ChatListState> emit,
  ) async {
    emit(ChatListLoading());

    try {
      await _chatRoomsSubscription?.cancel();

      _chatRoomsSubscription = _chatRepository.getChatRooms().listen(
        (chatRooms) {
          add(ChatListUpdatedEvent(chatRooms));
        },
        onError: (error) {
          add(ChatListUpdatedEvent([]));
        },
      );
    } catch (e) {
      emit(ChatListError('Failed to load chats: $e'));
    }
  }

  void _onChatListUpdated(
    ChatListUpdatedEvent event,
    Emitter<ChatListState> emit,
  ) {
    emit(ChatListLoaded(event.chatRooms));
  }

  Future<void> _onCreateChat(
    CreateChatEvent event,
    Emitter<ChatListState> emit,
  ) async {
    emit(ChatCreating());

    final result = await _chatRepository.createChatRoom(event.otherUserId);

    if (result is DataSuccess<String>) {
      emit(ChatCreated(result.data!, event.otherUserId));
    } else if (result is DataError) {
      emit(ChatCreationError(result.message ?? 'Failed to create chat'));
    }
  }

  @override
  Future<void> close() {
    _chatRoomsSubscription?.cancel();
    return super.close();
  }
}
