import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:leam/src/config/di/service_locator.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/models/chat/recent_chat.dart';
import 'package:leam/src/models/chat/user_chat.dart';
import 'package:leam/src/models/profile_data.dart';

abstract class ChatRepository {
  // Stream< > getUserChats({required String chatId});

  Future<void> sendMessage({
    required String message,
    required String receiverId,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> getRecentChats();

  Future<DataState<List<ProfileData>>> getAllUserInfo();
}

class ChatRepositoryImpl extends ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepositoryImpl({required this.auth, required this.firestore});

  // @override
  // Stream<DataState<List<UserChat>>> getUserChats({
  //   required String chatId,
  // }) async* {
  //   try {
  //     final userEmail = auth.currentUser?.email;
  //
  //     final usersChats = await firestore
  //         .collection('chats')
  //         .doc(userEmail)
  //         .collection(chatId)
  //         .orderBy('createdAt', descending: true)
  //         .snapshots();
  //
  //     yield DataSuccess(data: usersChats);
  //   } on FirebaseException catch (e) {
  //     return DataError(message: e.message!);
  //   }
  // }

  @override
  Future<void> sendMessage({
    required String message,
    required String receiverId,
  }) async {
    try {
      final userEmail = auth.currentUser?.email;
      final String name = auth.currentUser!.displayName!;

      final String imageUrl = auth.currentUser?.photoURL ?? "";

      final UserChat chat = UserChat(
        name: name,
        senderId: userEmail!,
        receiverId: receiverId,
        message: message,
        type: 'text',
        isRead: false,
      );

      ///
      /// Insert Data Into Chats Collection
      ///
      await firestore
          .collection('chats')
          .doc(_getChatRoomId(userEmail, receiverId))
          .collection("messages")
          .add(chat.toJson());

      ///
      /// Insert Data Into Primary Users Recent Chats Collection
      ///
      final primaryUserId = await _getUserDocumentId(userEmail);

      await firestore
          .collection("users")
          .doc(primaryUserId)
          .collection("recent_chats")
          .doc(receiverId)
          .set(chat.toJson());

      ///
      /// Insert Data Into Secondary User Recent Chats Collection
      ///
      final secondaryUserId = await _getUserDocumentId(receiverId);

      await firestore
          .collection("users")
          .doc(secondaryUserId)
          .collection("recent_chats")
          .doc(userEmail)
          .set(chat.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String?> _getUserDocumentId(String email) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty ? snapshot.docs.first.id : null;
    } catch (e) {
      debugPrint('Error fetching user document: $e');
      return null;
    }
  }

  String _getChatRoomId(String userId1, userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();

    return ids.join("_");
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getRecentChats() {
    return firestore
        .collection('users')
        .doc("6qQYpwsVjnYai5Aa2Cw4dcMoZFf1")
        .collection('recent_chats')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }



  @override
  Future<DataState<List<ProfileData>>> getAllUserInfo() async {
    try {
      final String email = firebaseAuth.currentUser!.email!;

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
}
