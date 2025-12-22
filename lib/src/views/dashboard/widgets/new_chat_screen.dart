import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/viewmodels/chat/chat_list/chat_list_view_model.dart';
import 'package:leam/src/viewmodels/user/user_view_model.dart';

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select User')),
      body: BlocBuilder<UserViewModel, UserState>(
        bloc: context.read<UserViewModel>()..add(LoadAllUsersEvent()),
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is UserError) {
            return Center(child: Text(state.message));
          }

          if (state is UsersLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: user.photoUrl == null
                        ? Text(user.name[0].toUpperCase())
                        : null,
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.about ?? ""),
                  onTap: () {
                    context.read<ChatListViewModel>().add(
                      CreateChatEvent(user.uid),
                    );
                    Navigator.pop(context);
                  },
                );
              },
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
