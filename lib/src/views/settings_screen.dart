import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/75.jpg',
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ankush Gaur', // Dummy name
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Flutter Developer', // Dummy status/bio
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),

            // Settings List
            _buildSettingsItem(
              context,
              icon: Icons.vpn_key,
              title: 'Account',
              subtitle: 'Privacy, security, change number',
            ),
            _buildSettingsItem(
              context,
              icon: Icons.chat,
              title: 'Chats',
              subtitle: 'Theme, wallpapers, chat history',
            ),
            _buildSettingsItem(
              context,
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Message, group & call tones',
            ),
            _buildSettingsItem(
              context,
              icon: Icons.data_usage,
              title: 'Storage and data',
              subtitle: 'Network usage, auto-download',
            ),
            _buildSettingsItem(
              context,
              icon: Icons.help_outline,
              title: 'Help',
              subtitle: 'Help centre, contact us, privacy policy',
            ),
            const Divider(),
            _buildSettingsItem(
              context,
              icon: Icons.people,
              title: 'Invite a friend',
            ),
            _buildSettingsItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(color: Colors.grey))
          : null,
      onTap: onTap ?? () {},
    );
  }
}
