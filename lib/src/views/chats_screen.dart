import 'package:flutter/material.dart';

// Dummy Chat Model
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

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  // Dummy Data
  static final List<Chat> _dummyChats = [
    Chat(
      avatarUrl: 'https://randomuser.me/api/portraits/women/34.jpg',
      name: 'Alice',
      message: 'Hey, how are you?',
      time: '10:30 AM',
      unreadCount: 2,
    ),
    Chat(
      avatarUrl: 'https://randomuser.me/api/portraits/men/45.jpg',
      name: 'Bob',
      message: 'Can you send me the file?',
      time: '9:45 AM',
    ),
    Chat(
      avatarUrl: 'https://randomuser.me/api/portraits/women/47.jpg',
      name: 'Charlie',
      message: 'See you tomorrow!',
      time: 'Yesterday',
    ),
    Chat(
      avatarUrl: 'https://randomuser.me/api/portraits/men/50.jpg',
      name: 'David',
      message: 'Thanks for your help!',
      time: 'Yesterday',
      unreadCount: 1,
    ),
    Chat(
      avatarUrl: 'https://randomuser.me/api/portraits/women/55.jpg',
      name: 'Eve',
      message: 'Let\'s catch up later.',
      time: '2 days ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _dummyChats.length,
        itemBuilder: (context, index) {
          final chat = _dummyChats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chat.avatarUrl),
              radius: 25,
            ),
            title: Text(
              chat.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(chat.message, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.time,
                  style: TextStyle(
                    color: chat.unreadCount > 0 ? Colors.green : Colors.grey,
                    fontSize: 12,
                  ),
                ),
                if (chat.unreadCount > 0)
                  const SizedBox(height: 5),
                if (chat.unreadCount > 0)
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 10,
                    child: Text(
                      chat.unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            onTap: () {
              // TODO: Navigate to the chat details screen
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
