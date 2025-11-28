import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/config/di/service_locator.dart';
import 'package:leam/src/core/constants/app_colors.dart';
import 'package:leam/src/core/utils/time_date_formatter.dart';
import 'package:leam/src/viewmodels/chat/chat_view_model.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String? image;
  final String id;

  const ChatScreen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  late final ChatViewModel _chatViewModel;

  @override
  void initState() {
    super.initState();

    if (mounted) {
     _chatViewModel = context.read<ChatViewModel>();
     _chatViewModel.add(GetUserChatsEvent(userId: widget.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatViewModel, ChatStates>(
                buildWhen: (previous, current) =>
                    current is UserChatsLoaded ||
                    current is UserChatsLoading ||
                    current is UserChatsError,
                builder: (context, state) {
                  if (state is UserChatsLoaded) {
                    if (state.chats.isEmpty) {
                      return Center(child: Text("'Say Hii! 👋'"));
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        final isMe =
                            state.chats[index].senderId ==
                            firebaseAuth.currentUser!.email;

                        return Wrap(
                          alignment: isMe
                              ? WrapAlignment.end
                              : WrapAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              margin: EdgeInsets.fromLTRB(
                                isMe ? 100 : 10,
                                10,
                                !isMe ? 100 : 10,
                                10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.chats[index].message,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 8,
                                    children: [
                                      Text(
                                        getTimeFromDateTime(
                                          state.chats[index].createdAt!,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                         ),
                                      ),

                                      if (isMe)
                                        Icon(
                                          Icons.done_all,
                                          color: state.chats[index].isRead
                                              ? Colors.green
                                              : Colors.grey.shade600,
                                          size: 14,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return SizedBox();
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      context.read<ChatViewModel>().add(
                        SendMessageEvent(
                          message: _controller.text,
                          receiverId: widget.id,
                        ),
                      );

                      _controller.clear();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chatViewModel.add(StopUserChatsEvent());
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
