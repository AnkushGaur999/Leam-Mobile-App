import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leam/src/config/di/service_locator.dart';
import 'package:leam/src/config/routes/app_routes.dart';
import 'package:leam/src/core/constants/app_colors.dart';
import 'package:leam/src/viewmodels/chat/chat_view_model.dart';
import 'package:leam/src/viewmodels/user/user_view_model.dart';
import 'package:leam/src/views/dashboard/widgets/new_chat_screen.dart';

class AllChatScreen extends StatefulWidget {
  const AllChatScreen({super.key});

  @override
  State<AllChatScreen> createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    context.read<ChatViewModel>().add(LoadRecentChatsEvent());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => context.pushNamed(AppRoutes.profile),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade300,
              child: ClipOval(
                child: Image.network(
                  firebaseAuth.currentUser!.photoURL ?? "",
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                  cacheHeight: 100,
                  cacheWidth: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, size: 30);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const CircularProgressIndicator(strokeWidth: 2);
                  },
                ),
              ),
            )
          ),
        ),
        title: const Text(
          'Chats',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ChatViewModel, ChatStates>(
          buildWhen: (previous, current) => current is RecentChatsLoaded,
          builder: (context, states) {
            if (states is RecentChatsLoaded) {
              final recentChatList = states.chats;

              if (recentChatList.isEmpty) {
                return const Center(child: Text("'Say Hii! 👋'"));
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: recentChatList.length,
                  itemBuilder: (context, index) {
                    final chat = recentChatList[index];

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey.shade300,
                        child: ClipOval(
                          child: Image.network(
                            chat.imageUrl ?? "",
                            width: 50,
                            height: 50,
                            cacheHeight: 100,
                            cacheWidth: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person, size: 30);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const CircularProgressIndicator(strokeWidth: 2);
                            },
                          ),
                        ),
                      ),
                      title: Text(
                        chat.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        chat.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "3:00 PM",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        final Map<String, dynamic> userData = {
                          'id': chat.uid,
                          'name': chat.name,
                          'image': chat.imageUrl,
                        };
                        context.pushNamed(AppRoutes.chat, extra: userData);
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UserViewModel>().add(GetAllUsersEvent());
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: const NewChatScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
