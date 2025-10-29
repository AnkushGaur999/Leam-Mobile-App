import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leam/src/config/di/service_locator.dart';
import 'package:leam/src/config/routes/app_routes.dart';
import 'package:leam/src/models/chat/recent_chat.dart';
import 'package:leam/src/repositories/chat_repository.dart';
import 'package:leam/src/views/dashboard/widgets/new_chat_screen.dart';

class Chat {
  final String avatarUrl;
  final String name;
  final String message;
  final String time;
  final int unreadCount;

  Chat({
    required this.avatarUrl,
    required this.name,
    required this.message,
    required this.time,
    this.unreadCount = 0,
  });
}

class AllChatScreen extends StatelessWidget {
  const AllChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatRepository chatRepository = ChatRepositoryImpl(
      auth: firebaseAuth,
      firestore: firebaseFirestore,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: StreamBuilder(
        stream: chatRepository.getRecentChats(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            final recentChatList =
                snapshots.data?.docs
                    .map((value) => RecentChat.fromJson(value.data()))
                    .toList() ??
                [];

            return ListView.builder(
              itemCount: recentChatList.length,
              itemBuilder: (context, index) {
                final chat = recentChatList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg",
                    ),
                    radius: 25,
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
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "3:00 PM",
                        style: TextStyle(
                          color: //chat.unreadCount > 0 ? Colors.green :
                              Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      // if (chat.unreadCount > 0) const SizedBox(height: 5),
                      // if (chat.unreadCount > 0)
                      //   CircleAvatar(
                      //     backgroundColor: Colors.green,
                      //     radius: 10,
                      //     child: Text(
                      //       chat.unreadCount.toString(),
                      //       style: const TextStyle(
                      //           color: Colors.white, fontSize: 12),
                      //     ),
                      //   ),
                    ],
                  ),
                  onTap: () {
                    context.pushNamed(AppRoutes.chat);
                  },
                );
              },
            );
          }

          return SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.85,
              child: NewChatScreen(),
            ),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
