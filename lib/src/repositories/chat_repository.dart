import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:leam/src/core/config/di/service_locator.dart';
import 'package:leam/src/core/data/data_state.dart';
<<<<<<< Updated upstream
import 'package:leam/src/models/chat/recent_chat.dart';
import 'package:leam/src/models/chat/user_chat.dart';
import 'package:leam/src/models/profile_data.dart';
=======
import 'package:leam/src/core/services/notification_service.dart';
import 'package:leam/src/models/chat/chat_room_model.dart';
import 'package:leam/src/models/chat/message_model.dart';
>>>>>>> Stashed changes

abstract class ChatRepository {
  /// Get messages stream for a specific chat
  Stream<List<MessageModel>> getMessages(String chatRoomId, {int limit = 50});

  String get currentUserId;

  /// Send a text message
  Future<DataState<MessageModel>> sendMessage({
    required String chatRoomId,
    required String content,
    required MessageType type,
    String? mediaUrl,
    String? thumbnailUrl,
    Map<String, dynamic>? metadata,
  });

  /// Get all chat rooms for current user
  Stream<QuerySnapshot<Map<String, dynamic>>> getRecentChats();

  Stream<List<ChatRoomModel>> getChatRooms();

  Future<DataState<ChatRoomModel>> getChatRoom(String otherUserId);

  Future<DataState<String>> createChatRoom(String otherUserId);

  Future<DataState<void>> markMessagesAsDelivered(String chatRoomId);

  Future<DataState<void>> markMessagesAsRead(String chatRoomId);

  Future<DataState<void>> deleteMessage(String chatRoomId, String messageId);
}

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepositoryImpl({required this.auth, required this.firestore});

  //  String get _currentUserId => auth.currentUser!.uid;

<<<<<<< Updated upstream

    return firestore
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots();
=======
  String get _currentUserId {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
>>>>>>> Stashed changes
  }

  @override
  String get currentUserId => _currentUserId;

  @override
  Future<DataState<MessageModel>> sendMessage({
    required String chatRoomId,
    required String content,
    required MessageType type,
    String? mediaUrl,
    String? thumbnailUrl,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final now = DateTime.now();
      final message = MessageModel(
        id: '',
        // Will be set by Firestore
        chatRoomId: chatRoomId,
        senderId: _currentUserId,
        content: content,
        type: type,
        sentAt: now,
        mediaUrl: mediaUrl,
        thumbnailUrl: thumbnailUrl,
        metadata: metadata,
        name: '',
        isRead: false,
      );

      // Get chat room to find other participant
      final chatRoomDoc = await firestore
          .collection('chatRooms')
          .doc(chatRoomId)
<<<<<<< Updated upstream
          .collection("messages")
          .add(chatJson);

      // ---------------- GET USERS ----------------
      final primaryUser = await _getUserDetails(userEmail);
      final secondaryUser = await _getUserDetails(receiverId);

      // ---------------- PRIMARY USER RECENT CHAT ----------------
      final primaryRecentChat = RecentChat(
        uid: secondaryUser!.email!,
        name: secondaryUser.name!,
        imageUrl: secondaryUser.photoUrl ?? "",
        senderId: userEmail,
        receiverId: receiverId,
        message: message,
        type: "text",
        isRead: false,
      );

      final primaryRecentChatJson = primaryRecentChat.toJson()
        ..addAll({
          "createdAt": FieldValue.serverTimestamp(),
          "updatedAt": FieldValue.serverTimestamp(),
        });

      await firestore
          .collection("users")
          .doc(primaryUser!.uid)
          .collection("recent_chats")
          .doc(receiverId)
          .set(primaryRecentChatJson);

      // ---------------- SECONDARY USER RECENT CHAT ----------------
      final secondaryRecentChat = RecentChat(
        uid: primaryUser.email!,
        name: primaryUser.name!,
        imageUrl: primaryUser.photoUrl ?? "",
        senderId: userEmail,
        receiverId: receiverId,
        message: message,
        type: "text",
        isRead: false,
      );

      await firestore
          .collection("users")
          .doc(secondaryUser.uid)
          .collection("recent_chats")
          .doc(userEmail)
          .set(secondaryRecentChat.toJson());
    } catch (e) {
      debugPrint("Send Message Error: $e");
    }
  }

  Future<ProfileData?> _getUserDetails(String email) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
=======
>>>>>>> Stashed changes
          .get();

      if (!chatRoomDoc.exists) {
        return DataError(message: 'Chat room not found');
      }

      final chatRoom = ChatRoomModel.fromJson(chatRoomDoc.data()!, chatRoomId);
      final otherUserId = chatRoom.getOtherParticipantId(_currentUserId);

      // Use batch for atomic operations
      final batch = firestore.batch();

      // Add message
      final messageRef = firestore.collection('messages').doc();
      batch.set(messageRef, message.toJson());

      // Update chat room
      final chatRoomRef = firestore.collection('chatRooms').doc(chatRoomId);
      batch.update(chatRoomRef, {
        'lastMessageContent': content,
        'lastMessageType': type.name,
        'lastMessageSenderId': _currentUserId,
        'lastMessageTime': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'unreadCounts.$otherUserId': FieldValue.increment(1),
      });

      await batch.commit();

      // Send notification (non-blocking)
      _sendNotification(otherUserId, content, type);

      return DataSuccess(data: message.copyWith(id: messageRef.id));
    } on FirebaseException catch (e) {
      return DataError(message: e.message ?? 'Failed to send message');
    } catch (e) {
      return DataError(message: 'Unexpected error: $e');
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String chatRoomId, {int limit = 50}) {
    return firestore
        .collection('messages')
        .where('chatRoomId', isEqualTo: chatRoomId)
        .orderBy('sentAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MessageModel.fromJson(doc.data(), doc.id))
              .toList();
        });
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getRecentChats() {
    return firestore
        .collection('chats')
        .where('participants', arrayContains: _currentUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  @override
  Future<DataState<void>> markMessagesAsRead(String chatRoomId) async {
    try {
      final now = DateTime.now();

      // Get unread messages
      final snapshot = await firestore
          .collection('messages')
          .where('chatRoomId', isEqualTo: chatRoomId)
          .where('senderId', isNotEqualTo: _currentUserId)
          .where('readAt', isNull: true)
          .get();

      if (snapshot.docs.isEmpty) {
        return DataSuccess(data: null);
      }

      final batch = firestore.batch();

      // Mark messages as read
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'readAt': Timestamp.fromDate(now),
          'deliveredAt': doc.data()['deliveredAt'] ?? Timestamp.fromDate(now),
        });
      }

      // Reset unread count
      final chatRoomRef = firestore.collection('chatRooms').doc(chatRoomId);
      batch.update(chatRoomRef, {'unreadCounts.$_currentUserId': 0});

      await batch.commit();
      return DataSuccess(data: null);
    } on FirebaseException catch (e) {
      return DataError(message: e.message ?? 'Failed to mark as read');
    } catch (e) {
      return DataError(message: 'Unexpected error: $e');
    }
  }

  @override
<<<<<<< Updated upstream
  Future<void> updateMessageStatus({required String chatId}) async{

    try{
      final chatRoomId = _getChatRoomId(auth.currentUser!.email!, chatId);

      firestore
          .collection("chats")
          .doc(chatRoomId)
          .collection("messages")
          .where("senderId", isEqualTo: chatId)
          .get()
          .then((value) {
        for (int i = 0; i < value.docs.length; i++) {

          firestore
              .collection("chats")
              .doc(chatRoomId)
              .collection("messages")
              .doc(value.docs[i].id)
              .update({"isRead": true});
        }
      });
    }catch(e){
      debugPrint("Error: e");
=======
  Future<DataState<void>> markMessagesAsDelivered(String chatRoomId) async {
    try {
      final now = DateTime.now();

      // Get undelivered messages
      final snapshot = await firestore
          .collection('messages')
          .where('chatRoomId', isEqualTo: chatRoomId)
          .where('senderId', isNotEqualTo: _currentUserId)
          .where('deliveredAt', isNull: true)
          .get();

      if (snapshot.docs.isEmpty) {
        return DataSuccess(data: null);
      }

      final batch = firestore.batch();

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'deliveredAt': Timestamp.fromDate(now)});
      }

      await batch.commit();
      return DataSuccess(data: null);
    } on FirebaseException catch (e) {
      return DataError(message: e.message ?? 'Failed to mark as delivered');
    } catch (e) {
      return DataError(message: 'Unexpected error: $e');
>>>>>>> Stashed changes
    }

  }

  // Private helper methods

  String _generateChatRoomId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return ids.join('_');
  }

  @override
  Future<DataState<String>> createChatRoom(String otherUserId) async {
    try {
      final chatRoomId = _generateChatRoomId(_currentUserId, otherUserId);
      final chatRoomRef = firestore.collection('chatRooms').doc(chatRoomId);

      final doc = await chatRoomRef.get();
      if (doc.exists) {
        return DataSuccess(data: chatRoomId);
      }

      final now = DateTime.now();
      final chatRoom = ChatRoomModel(
        id: chatRoomId,
        participantIds: [_currentUserId, otherUserId],
        unreadCounts: {_currentUserId: 0, otherUserId: 0},
        createdAt: now,
        updatedAt: now,
      );

      await chatRoomRef.set(chatRoom.toJson());
      return DataSuccess(data: chatRoomId);
    } on FirebaseException catch (e) {
      return DataError(message: e.message ?? 'Failed to create chat room');
    } catch (e) {
      return DataError(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<DataState<ChatRoomModel>> getChatRoom(String otherUserId) async {
    try {
      final chatRoomId = _generateChatRoomId(_currentUserId, otherUserId);
      final doc = await firestore.collection('chatRooms').doc(chatRoomId).get();

      if (!doc.exists) {
        return DataError(message: 'Chat room not found');
      }

      return DataSuccess(data: ChatRoomModel.fromJson(doc.data()!, doc.id));
    } on FirebaseException catch (e) {
      return DataError(message: e.message ?? 'Failed to get chat room');
    } catch (e) {
      return DataError(message: 'Unexpected error: $e');
    }
  }

  @override
  Stream<List<ChatRoomModel>> getChatRooms() {
    return firestore
        .collection('chatRooms')
        .where('participantIds', arrayContains: _currentUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ChatRoomModel.fromJson(doc.data(), doc.id))
              .toList();
        });
  }

  @override
  Future<DataState<void>> deleteMessage(
    String chatRoomId,
    String messageId,
  ) async {
    try {
      await firestore.collection('messages').doc(messageId).delete();
      return DataSuccess(data: null);
    } on FirebaseException catch (e) {
      return DataError(message: e.message ?? 'Failed to delete message');
    } catch (e) {
      return DataError(message: 'Unexpected error: $e');
    }
  }

  Future<void> _sendNotification(
    String receiverId,
    String content,
    MessageType type,
  ) async {
    try {
      final userDoc = await firestore.collection('users').doc(receiverId).get();
      if (!userDoc.exists) return;

      final userData = userDoc.data()!;
      final fcmToken = userData['fcmToken'] as String?;

      if (fcmToken == null || fcmToken.isEmpty) return;

      final senderName = firebaseAuth.currentUser!.displayName!;
      final messagePreview = type == MessageType.text
          ? content
          : '📎 ${type.name.toUpperCase()}';

      // Call your notification service here
      await NotificationService.sendPushNotification(
        fcmToken,
        senderName,
        messagePreview,
      );
    } catch (e) {
      // Silent fail - notification failure shouldn't break chat
      if (kDebugMode) {
        print('Notification error: $e');
      }
    }

  }
}
