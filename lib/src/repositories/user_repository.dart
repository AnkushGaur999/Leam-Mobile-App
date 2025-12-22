import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/models/user/user_data_model.dart';

abstract class UserRepository {
  Future<DataState<void>> createOrUpdateUser(UserDataModel user);

  Future<DataState<UserDataModel>> getUser(String userId);

  Future<DataState<List<UserDataModel>>> getAllUsers();

  Future<DataState<void>> updateUserStatus(bool isOnline);

  Future<DataState<void>> updateFcmToken(String token);

  String get currentUserId;
}

class UserRepositoryImpl extends UserRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  UserRepositoryImpl({required this.firestore, required this.auth});

  String get _currentUserId {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  @override
  String get currentUserId => _currentUserId;

  @override
  Future<DataState<void>> createOrUpdateUser(UserDataModel user) async {
    try {
      await firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson(), SetOptions(merge: true));
      return DataSuccess(data: null);
    } on FirebaseException catch (e) {
      return DataError(message: e.message ?? 'Failed to update user');
    } catch (e) {
      return DataError(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<DataState<UserDataModel>> getUser(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        return DataError(message: 'User not found');
      }

      return DataSuccess(data: UserDataModel.fromJson(doc.data()!));
    } on FirebaseException catch (e) {
      return DataError(message: e.message ?? 'Failed to get user');
    } catch (e) {
      return DataError(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<DataState<List<UserDataModel>>> getAllUsers() async {
    try {
      final snapshot = await firestore
          .collection('users')
          .where('uid', isNotEqualTo: _currentUserId)
          .get();

      final users = snapshot.docs
          .map((doc) => UserDataModel.fromJson(doc.data()))
          .toList();

      return DataSuccess(data: users);
    } on FirebaseException catch (e) {
      return DataError(message: e.message ?? 'Failed to get users');
    } catch (e) {
      return DataError(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<DataState<void>> updateUserStatus(bool isOnline) async {
    try {
      if (isOnline) {
        await firestore.collection('users').doc(_currentUserId).update({
          'isOnline': isOnline,
        });
      } else {
        await firestore.collection('users').doc(_currentUserId).update({
          'isOnline': isOnline,
          'lastSeen': FieldValue.serverTimestamp(),
        });
      }

      await firestore.collection('users').doc(_currentUserId).update({
        'isOnline': isOnline,
        'lastSeen': isOnline ? null : FieldValue.serverTimestamp(),
      });
      return DataSuccess(data: null);
    } on FirebaseException catch (e) {
      return DataError(message: e.message ?? 'Failed to update status');
    } catch (e) {
      return DataError(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<DataState<void>> updateFcmToken(String token) async {
    try {
      await firestore.collection('users').doc(_currentUserId).update({
        'fcmToken': token,
      });
      return DataSuccess(data: null);
    } on FirebaseException catch (e) {
      return DataError(message: e.message ?? 'Failed to update token');
    } catch (e) {
      return DataError(message: 'Unexpected error: $e');
    }
  }
}
