import 'package:flutter/material.dart';

// Dummy Call Model
enum CallType { incoming, outgoing, missed }

class Call {
  final String name;
  final String avatarUrl;
  final String time;
  final CallType type;
  final bool isVideoCall;

  Call({
    required this.name,
    required this.avatarUrl,
    required this.time,
    required this.type,
    this.isVideoCall = false,
  });
}

class AllCallsScreen extends StatelessWidget {
  const AllCallsScreen({super.key});

  // Dummy data
  static final List<Call> _dummyCalls = [
    Call(
      name: 'Alice',
      avatarUrl: 'https://randomuser.me/api/portraits/women/34.jpg',
      time: 'Today, 11:30 AM',
      type: CallType.incoming,
      isVideoCall: true,
    ),
    Call(
      name: 'Bob',
      avatarUrl: 'https://randomuser.me/api/portraits/men/45.jpg',
      time: 'Today, 9:45 AM',
      type: CallType.outgoing,
    ),
    Call(
      name: 'Charlie',
      avatarUrl: 'https://randomuser.me/api/portraits/women/47.jpg',
      time: 'Yesterday, 8:15 PM',
      type: CallType.missed,
      isVideoCall: true,
    ),
    Call(
      name: 'David',
      avatarUrl: 'https://randomuser.me/api/portraits/men/50.jpg',
      time: 'Yesterday, 6:30 PM',
      type: CallType.incoming,
    ),
    Call(
      name: 'Eve',
      avatarUrl: 'https://randomuser.me/api/portraits/women/55.jpg',
      time: '2 days ago',
      type: CallType.outgoing,
      isVideoCall: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calls'),
      ),
      body: ListView.builder(
        itemCount: _dummyCalls.length + 1, // +1 for the "Create call link" header
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCreateCallLink();
          }
          final call = _dummyCalls[index - 1];
          return _buildCallItem(call);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new call functionality
        },
        child: const Icon(Icons.add_ic_call),
      ),
    );
  }

  Widget _buildCreateCallLink() {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.green,
        child: Icon(Icons.link, color: Colors.white),
      ),
      title: const Text(
        'Create call link',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('Share a link for your WhatsApp call'),
      onTap: () {
        // TODO: Implement create call link functionality
      },
    );
  }

  Widget _buildCallItem(Call call) {
    IconData typeIcon;
    Color typeColor;

    switch (call.type) {
      case CallType.incoming:
        typeIcon = Icons.call_received;
        typeColor = Colors.green;
        break;
      case CallType.outgoing:
        typeIcon = Icons.call_made;
        typeColor = Colors.green;
        break;
      case CallType.missed:
        typeIcon = Icons.call_missed;
        typeColor = Colors.red;
        break;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(call.avatarUrl),
        radius: 25,
      ),
      title: Text(
        call.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: call.type == CallType.missed ? Colors.red : Colors.black,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(typeIcon, color: typeColor, size: 16),
          const SizedBox(width: 5),
          Text(call.time),
        ],
      ),
      trailing: IconButton(
        icon: Icon(call.isVideoCall ? Icons.videocam : Icons.call, color: Colors.green),
        onPressed: () {
          // TODO: Implement call functionality
        },
      ),
      onTap: () {
        // TODO: Navigate to call details screen
      },
    );
  }
}
