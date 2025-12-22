import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/models/chat/chat_room_model.dart';
import 'package:leam/src/repositories/chat_repository.dart';
import 'package:leam/src/viewmodels/chat/chat_view_model.dart';
import 'package:leam/src/viewmodels/user/user_view_model.dart';
import 'package:leam/src/views/dashboard/widgets/chat_app_bar.dart';
import 'package:leam/src/views/dashboard/widgets/message_bubble.dart';

class ChatScreen extends StatelessWidget {
  final String chatRoomId;
  final String userId;

  const ChatScreen({super.key, required this.chatRoomId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatViewModel(chatRepository: context.read<ChatRepository>())
            ..add(LoadMessagesEvent(chatRoomId)),
      child: _ChatScreenContent(chatRoomId: chatRoomId, userId: userId),
    );
  }
}

class _ChatScreenContent extends StatefulWidget {
  final String chatRoomId;
  final String userId;

  const _ChatScreenContent({required this.chatRoomId, required this.userId});

  @override
  State<_ChatScreenContent> createState() => _ChatScreenContentState();
}

class _ChatScreenContentState extends State<_ChatScreenContent>
    with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<ChatViewModel>().add(
        MarkMessagesAsReadEvent(widget.chatRoomId),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    context.read<ChatViewModel>().add(
      SendMessageEvent(
        chatRoomId: widget.chatRoomId,
        content: message,
        type: MessageType.text,
      ),
    );

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade300,
              child: ClipOval(
                child: Image.network(
                  widget.image ?? "",
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
            SizedBox(width: 20),
            Text(
              widget.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
=======
      appBar: ChatAppBar(
        otherUserId: widget.userId,
        onVideoCallPressed: () {
          // TODO: Implement video call
          //  print('Video call pressed');
        },
        onVoiceCallPressed: () {
          // TODO: Implement voice call
          //  print('Voice call pressed');
        },
        onViewProfilePressed: () {
          // TODO: Navigate to user profile
          //   print('View profile pressed');
        },
        onSearchPressed: () {
          // TODO: Search in chat
          //  print('Search pressed');
        },
        onMutePressed: () {
          // TODO: Mute notifications
          //  print('Mute pressed');
        },
        onClearChatPressed: () {
          // TODO: Clear chat
          //  print('Clear chat pressed');
        },
>>>>>>> Stashed changes
      ),
      body: SafeArea(
        child: Column(
          spacing: 10,
          children: [
            Expanded(
              child: BlocConsumer<ChatViewModel, ChatState>(
                listener: (context, state) {
                  if (state is MessageSendError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }

                  if (state is ChatLoaded) {
                    // Mark as read when new messages arrive
                    context.read<ChatViewModel>().add(
                      MarkMessagesAsReadEvent(widget.chatRoomId),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is ChatLoaded) {
                    if (state.messages.isEmpty) {
                      return Center(child: Text('No messages yet'));
                    }

                    return ListView.builder(
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];

                        final currentUserid = context
                            .read<ChatRepository>()
                            .currentUserId;

                        return MessageBubble(
                          message: message,
                          currentUserId: currentUserid,
                        );
                      },
                    );
                  }

                  return SizedBox.shrink();
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return BlocBuilder<ChatViewModel, ChatState>(
      builder: (context, state) {
        final isSending = state is ChatLoaded && state.isSendingMessage;

        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                onPressed: () {
                  _showAttachmentOptions(context);
                },
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  enabled: !isSending,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: isSending
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.send, color: Colors.white),
                  onPressed: isSending ? null : _sendMessage,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Share',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildAttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement gallery picker
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.pink,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement camera
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.insert_drive_file,
                  label: 'Document',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement document picker
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.location_on,
                  label: 'Location',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement location sharing
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.mic,
                  label: 'Audio',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement audio recording
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.contacts,
                  label: 'Contact',
                  color: Colors.teal,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement contact sharing
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

// 5. Update user status in app lifecycle
class MyAppLifecycleObserver extends WidgetsBindingObserver {
  final UserViewModel userBloc;

  MyAppLifecycleObserver(this.userBloc);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      userBloc.add(UpdateUserStatusEvent(true));
    } else if (state == AppLifecycleState.paused) {
      userBloc.add(UpdateUserStatusEvent(false));
    }
  }
}
