import 'package:flutter/material.dart';
import 'package:leam/src/core/constants/app_colors.dart';

// Dummy Status Model
class Status {
  final String name;
  final String avatarUrl;
  final String time;
  final bool isViewed;
  final int statusCount;

  Status({
    required this.name,
    required this.avatarUrl,
    required this.time,
    this.isViewed = false,
    this.statusCount = 1,
  });
}

class AllStatusScreen extends StatelessWidget {
  const AllStatusScreen({super.key});

  // Dummy data
  static final myStatus = Status(
    name: 'My Status',
    avatarUrl: 'https://randomuser.me/api/portraits/men/75.jpg', // Replace with user's avatar
    time: 'Tap to add status update',
  );

  static final List<Status> recentUpdates = [
    Status(
      name: 'John Doe',
      avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      time: '15 minutes ago',
      statusCount: 2,
    ),
    Status(
      name: 'Jane Smith',
      avatarUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
      time: '45 minutes ago',
    ),
  ];

  static final List<Status> viewedUpdates = [
    Status(
      name: 'Sam Wilson',
      avatarUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
      time: '2 hours ago',
      isViewed: true,
    ),
    Status(
      name: 'Emily Brown',
      avatarUrl: 'https://randomuser.me/api/portraits/women/4.jpg',
      time: '5 hours ago',
      isViewed: true,
      statusCount: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMyStatus(),
            _buildSectionHeader('Recent updates'),
            ...recentUpdates.map((status) => _buildStatusItem(status)),
            _buildSectionHeader('Viewed updates'),
            ...viewedUpdates.map((status) => _buildStatusItem(status)),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'edit_status',
            onPressed: () {
              // TODO: Implement text status creation
            },
            child: const Icon(Icons.edit),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'camera_status',
            onPressed: () {
              // TODO: Implement camera status creation
            },
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }

  Widget _buildMyStatus() {
    return ListTile(
      leading: Stack(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/75.jpg'), // Replace with user's avatar
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.primaryColor,
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      title: const Text(
        'My Status',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('Tap to add status update'),
      onTap: () {

      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildStatusItem(Status status) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: status.isViewed ? Colors.grey : AppColors.primaryColor,
            width: 2.5,
          ),
        ),
        child: CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(status.avatarUrl),
        ),
      ),
      title: Text(
        status.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(status.time),
      onTap: () {

      },
    );
  }
}
