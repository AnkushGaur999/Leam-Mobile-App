import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:leam/src/core/config/routes/app_routes.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/models/chat/chat_room_model.dart';
import 'package:leam/src/models/user/user_data_model.dart';
import 'package:leam/src/repositories/chat_repository.dart';
import 'package:leam/src/repositories/user_repository.dart';

class ChatListTile extends StatelessWidget {
  final ChatRoomModel chatRoom;

  const ChatListTile({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<ChatRepository>().currentUserId;
    final otherUserId = chatRoom.getOtherParticipantId(currentUserId);
    final unreadCount = chatRoom.getUnreadCount(currentUserId);

    return FutureBuilder<DataState<UserDataModel>>(
      future: context.read<UserRepository>().getUser(otherUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildLoadingTile();
        }

        final result = snapshot.data!;
        if (result is DataError) {
          return _buildErrorTile();
        }

        final otherUser = (result as DataSuccess<UserDataModel>).data!;

        return ListTile(
          leading: _buildAvatar(otherUser),
          title: Text(
            otherUser.name,
            style: TextStyle(
              fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: _buildSubtitle(chatRoom, currentUserId),
          trailing: _buildTrailing(chatRoom, unreadCount),
          onTap: () {
            context.pushNamed(
              AppRoutes.chat,
              pathParameters: {
                "chatRoomId": chatRoom.id,
                "userId": otherUserId,
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAvatar(UserDataModel user) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: user.photoUrl != null
              ? NetworkImage(user.photoUrl!)
              : null,
          child: user.photoUrl == null
              ? Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              : null,
        ),
        if (user.isOnline!)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubtitle(ChatRoomModel chatRoom, String currentUserId) {
    if (chatRoom.lastMessageContent == null) {
      return Text('No messages yet', style: TextStyle(color: Colors.grey));
    }

    final isMyMessage = chatRoom.lastMessageSenderId == currentUserId;
    final prefix = isMyMessage ? 'You: ' : '';

    String content;
    if (chatRoom.lastMessageType == MessageType.image) {
      content = '📷 Photo';
    } else if (chatRoom.lastMessageType == MessageType.video) {
      content = '🎥 Video';
    } else if (chatRoom.lastMessageType == MessageType.audio) {
      content = '🎵 Audio';
    } else if (chatRoom.lastMessageType == MessageType.document) {
      content = '📄 Document';
    } else {
      content = chatRoom.lastMessageContent!;
    }

    return Text(
      '$prefix$content',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.grey[600],
        fontWeight: chatRoom.getUnreadCount(currentUserId) > 0
            ? FontWeight.w600
            : FontWeight.normal,
      ),
    );
  }

  Widget _buildTrailing(ChatRoomModel chatRoom, int unreadCount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (chatRoom.lastMessageTime != null)
          Text(
            _formatTime(chatRoom.lastMessageTime!),
            style: TextStyle(
              fontSize: 12,
              color: unreadCount > 0 ? Colors.blue : Colors.grey,
              fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        if (unreadCount > 0) ...[
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              unreadCount > 99 ? '99+' : '$unreadCount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(time);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(time);
    } else {
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }

  Widget _buildLoadingTile() {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: SizedBox(),
      ),
      title: Container(height: 14, width: 100, color: Colors.grey[300]),
      subtitle: Container(height: 12, width: 150, color: Colors.grey[200]),
    );
  }

  Widget _buildErrorTile() {
    return ListTile(
      leading: CircleAvatar(child: Icon(Icons.error)),
      title: Text('Error loading user'),
      subtitle: Text('Tap to retry'),
    );
  }
}
