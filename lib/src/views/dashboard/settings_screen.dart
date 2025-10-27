import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/viewmodels/profile/profile_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileViewModel>().add(GetProfileDetailsEvent());

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ProfileViewModel, ProfileState>(
              builder: (context, state) {

                if (state is ProfileDetailsLoaded) {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            state.profileData.photoUrl!,
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.profileData.name!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              state.profileData.about!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                if (state is ProfileDetailsFailure) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                return SizedBox(
                  height: 100,
                );
              },
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
