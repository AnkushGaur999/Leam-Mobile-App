import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/config/di/service_locator.dart';
import 'package:leam/src/core/utils/time_date_formatter.dart';
import 'package:leam/src/viewmodels/chat/chat_view_model.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Chat Screen')),
      body: Column(
        children: [
          StreamBuilder(
            stream: firebaseFirestore
                .collection("chats")
                .doc("ankugaur999@gmail.com_test123@gmail.com")
                .collection("messages")
                .orderBy("createdAt", descending: false)
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      final message =
                          snapshots.data!.docs[index]['message'] ?? "";
                      final timeStamp =
                          snapshots.data!.docs[index]['createdAt'] ?? "";

                      final isMe =
                          snapshots.data!.docs[index]['senderId'] ==
                          "ankugaur999@gmail.com";

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
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(message, style: TextStyle(fontSize: 16)),
                                Text(
                                  getTimeFromTimeStamp(timeStamp),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }

              return SizedBox();
            },
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    context.read<ChatViewModel>().add(
                      SendMessageEvent(
                        message: controller.text,
                        receiverId: "test123@gmail.com",
                      ),
                    );

                    controller.clear();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
