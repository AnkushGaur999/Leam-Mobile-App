import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leam/src/core/constants/app_colors.dart';
import 'package:leam/src/models/chat/chat_room_model.dart';
import 'package:leam/src/models/chat/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final String currentUserId;

  const MessageBubble({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  bool get isMe => message.senderId == currentUserId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContent(),
                  SizedBox(height: 4),
                  _buildTimestampAndStatus(),
                ],
              ),
            ),
          ),
          if (isMe) SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        );
      case MessageType.image:
        return _buildImageMessage();
      case MessageType.video:
        return _buildVideoMessage();
      case MessageType.audio:
        return _buildAudioMessage();
      case MessageType.document:
        return _buildDocumentMessage();
    }
  }

  Widget _buildImageMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.mediaUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              message.mediaUrl!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
        if (message.content.isNotEmpty) ...[
          SizedBox(height: 8),
          Text(
            message.content,
            style: TextStyle(color: isMe ? Colors.white : Colors.black87),
          ),
        ],
      ],
    );
  }

  Widget _buildVideoMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (message.thumbnailUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  message.thumbnailUrl!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: 200,
                height: 200,
                color: Colors.black26,
                child: Icon(Icons.videocam, size: 64, color: Colors.white),
              ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_arrow, color: Colors.white, size: 32),
            ),
          ],
        ),
        if (message.content.isNotEmpty) ...[
          SizedBox(height: 8),
          Text(
            message.content,
            style: TextStyle(color: isMe ? Colors.white : Colors.black87),
          ),
        ],
      ],
    );
  }

  Widget _buildAudioMessage() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.play_circle_filled,
          color: isMe ? Colors.white : Colors.blue,
          size: 32,
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voice Message',
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (message.metadata?['duration'] != null)
              Text(
                _formatDuration(message.metadata!['duration'] as int),
                style: TextStyle(
                  color: isMe ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocumentMessage() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.insert_drive_file,
          color: isMe ? Colors.white : Colors.blue,
          size: 32,
        ),
        SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (message.metadata?['fileSize'] != null)
                Text(
                  _formatFileSize(message.metadata!['fileSize'] as int),
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimestampAndStatus() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat('HH:mm').format(message.sentAt!),
          style: TextStyle(
            color: isMe ? Colors.white70 : Colors.black54,
            fontSize: 11,
          ),
        ),
        if (isMe) ...[SizedBox(width: 4), _buildStatusIcon()]
      ],
    );
  }

  Widget _buildStatusIcon() {
    final status = message.status;

    switch (status) {
      case MessageStatus.sent:
        return Icon(Icons.check, color: Colors.white70, size: 16);
      case MessageStatus.delivered:
        return Icon(Icons.done_all, color: Colors.white70, size: 16);
      case MessageStatus.read:
        return Icon(Icons.done_all, color: Colors.blue[200], size: 16);
    }
  }


  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
