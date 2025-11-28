import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leam/src/config/routes/app_routes.dart';
import 'package:leam/src/core/constants/app_colors.dart';
import 'package:leam/src/viewmodels/user/user_view_model.dart';

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "New Chat",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Search",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            onChanged: (value) {
              if (value.isNotEmpty) {
                context.read<UserViewModel>().add(SearchUserEvent(value));
              } else {
                context.read<UserViewModel>().add(GetAllUsersEvent());
              }
            },
          ),

          SizedBox(height: 10),

          BlocBuilder<UserViewModel, UserStates>(
            builder: (context, state) {
              if (state is AllUserLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is AllUserLoaded) {
                return Expanded(
                  child: state.users.isEmpty
                      ? const Center(child: Text("No users found"))
                      : ListView.builder(
                          itemCount: state.users.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  state.users[index].photoUrl ??
                                      "https://randomuser.me/api/portraits/women/34.jpg",
                                ),
                                radius: 25,
                              ),
                              title: Text(
                                state.users[index].name!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                state.users[index].about!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Icon(Icons.add),
                              onTap: () {
                                final Map<String, dynamic> userData = {
                                  'id': state.users[index].email,
                                  'name': state.users[index].name,
                                  'image': state.users[index].photoUrl,
                                };

                                context.pop();
                                context.pushNamed(
                                  AppRoutes.chat,
                                  extra: userData,
                                );
                              },
                            );
                          },
                        ),
                );
              }

              if (state is AllUserError) {
                return Center(child: Text(state.message));
              }

              return SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
