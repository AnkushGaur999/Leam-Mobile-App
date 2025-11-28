import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/models/chat/recent_chat.dart';
import 'package:leam/src/models/chat/user_chat.dart';
import 'package:leam/src/models/profile_data.dart';

abstract class ChatRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChats({
    required String chatId,
  });

  Future<void> sendMessage({
    required String message,
    required String receiverId,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> getRecentChats();

  Future<DataState<List<ProfileData>>> getAllUserInfo();

  Future<void> updateMessageStatus({required String chatId});
}

class ChatRepositoryImpl extends ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepositoryImpl({required this.auth, required this.firestore});

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChats({
    required String chatId,
  }) {
    final chatRoomId = _getChatRoomId(auth.currentUser!.email!, chatId);


    return firestore
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  @override
  Future<void> sendMessage({
    required String message,
    required String receiverId,
  }) async {
    try {
      final user = auth.currentUser!;
      final userEmail = user.email!;
      final userName = user.displayName ?? "";

      final chatRoomId = _getChatRoomId(userEmail, receiverId);

      // ---------------- SEND MESSAGE ----------------
      final UserChat chat = UserChat(
        name: userName,
        senderId: userEmail,
        receiverId: receiverId,
        message: message,
        type: 'text',
        isRead: false,
      );

      final chatJson = chat.toJson()
        ..addAll({
          "createdAt": FieldValue.serverTimestamp(),
          "updatedAt": FieldValue.serverTimestamp(),
        });

      await firestore
          .collection('chats')
          .doc(chatRoomId)
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
          .get();

      return ProfileData.fromJson(snapshot.docs.first.data());
    } catch (e) {
      debugPrint('Error fetching user document: $e');
      return null;
    }
  }

  String _getChatRoomId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();

    return ids.join("_");
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getRecentChats() {
    String userId = auth.currentUser!.uid;

    return firestore
        .collection('users')
        .doc(userId)
        .collection('recent_chats')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Future<DataState<List<ProfileData>>> getAllUserInfo() async {
    try {
      final String email = auth.currentUser!.email!;

      final res = await firestore
          .collection("users")
          .where("email", isNotEqualTo: email)
          .get();

      if (res.docs.isEmpty) return DataError(message: "User not found");

      final List<ProfileData> allUserList = res.docs
          .map((e) => ProfileData.fromJson(e.data()))
          .toList();

      return DataSuccess(data: allUserList);
    } on FirebaseException catch (e) {
      return DataError(message: e.message!);
    } catch (e) {
      return DataError(message: e.toString());
    }
  }

  @override
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
    }

  }
}
