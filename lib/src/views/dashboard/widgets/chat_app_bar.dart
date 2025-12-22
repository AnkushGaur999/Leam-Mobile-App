import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/core/helpers/chat_user.dart';
import 'package:leam/src/models/user/user_data_model.dart';
import 'package:leam/src/repositories/user_repository.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String otherUserId;
  final VoidCallback? onVideoCallPressed;
  final VoidCallback? onVoiceCallPressed;
  final VoidCallback? onViewProfilePressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onMutePressed;
  final VoidCallback? onClearChatPressed;

  const ChatAppBar({
    super.key,
    required this.otherUserId,
    this.onVideoCallPressed,
    this.onVoiceCallPressed,
    this.onViewProfilePressed,
    this.onSearchPressed,
    this.onMutePressed,
    this.onClearChatPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: FutureBuilder<DataState<UserDataModel>>(
        future: context.read<UserRepository>().getUser(otherUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _LoadingAppBarTitle();
          }

          if (!snapshot.hasData || snapshot.data is DataError) {
            return _ErrorAppBarTitle();
          }

          final userResult = snapshot.data as DataSuccess<UserDataModel>;
          final otherUser = userResult.data!;

          return _UserAppBarTitle(user: otherUser, onTap: onViewProfilePressed);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: onVideoCallPressed,
          tooltip: 'Video call',
        ),
        IconButton(
          icon: Icon(Icons.call),
          onPressed: onVoiceCallPressed,
          tooltip: 'Voice call',
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          tooltip: 'More options',
          onSelected: (value) => _handleMenuAction(value),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'view_profile',
              child: Row(
                children: [
                  Icon(Icons.person, size: 20, color: Colors.grey),
                  SizedBox(width: 12),
                  Text('View Profile'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'search',
              child: Row(
                children: [
                  Icon(Icons.search, size: 20, color: Colors.grey),
                  SizedBox(width: 12),
                  Text('Search'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'mute',
              child: Row(
                children: [
                  Icon(Icons.notifications_off, size: 20, color: Colors.grey),
                  SizedBox(width: 12),
                  Text('Mute Notifications'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                  SizedBox(width: 12),
                  Text('Clear Chat'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'view_profile':
        onViewProfilePressed?.call();
        break;
      case 'search':
        onSearchPressed?.call();
        break;
      case 'mute':
        onMutePressed?.call();
        break;
      case 'clear':
        onClearChatPressed?.call();
        break;
    }
  }
}

// ==================== USER APP BAR TITLE ====================

class _UserAppBarTitle extends StatelessWidget {
  final UserDataModel user;
  final VoidCallback? onTap;

  const _UserAppBarTitle({required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    user.photoUrl != null && user.photoUrl!.isNotEmpty
                    ? NetworkImage(user.photoUrl!)
                    : null,
                child: user.photoUrl == null || user.photoUrl!.isEmpty
                    ? Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              // Online status indicator
              if (user.isOnline!)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  getStatusText(user),
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== LOADING APP BAR TITLE ====================

class _LoadingAppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white24,
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 4),
            Container(
              width: 60,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ==================== ERROR APP BAR TITLE ====================

class _ErrorAppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, color: Colors.white70, size: 24),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'User',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Unable to load user info',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
