import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leam/src/core/config/routes/app_routes.dart';
import 'package:leam/src/viewmodels/chat/chat_list/chat_list_view_model.dart';
import 'package:leam/src/views/dashboard/widgets/chat_list_tile.dart';
import 'package:leam/src/views/dashboard/widgets/new_chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: BlocConsumer<ChatListViewModel, ChatListState>(
        listener: (context, state) {
          if (state is ChatCreated) {
            context.pushNamed(
              AppRoutes.chat,
              pathParameters: {
                "chatRoomId": state.chatRoomId,
                "userId": state.otherUserId,
              },
            );
          } else if (state is ChatCreationError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        buildWhen: (prevState, newState) =>
            newState is ChatListLoading ||
            newState is ChatListError ||
            newState is ChatListLoaded,
        builder: (context, state) {
          if (state is ChatListLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is ChatListError) {
            return Center(child: Text(state.message));
          }

          if (state is ChatListLoaded) {
            if (state.chatRooms.isEmpty) {
              return Center(child: Text('No chats yet'));
            }

            return ListView.builder(
              itemCount: state.chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = state.chatRooms[index];
                return ChatListTile(chatRoom: chatRoom);
              },
            );
          }

          return SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => NewChatScreen(),
          );
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
