import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/models/profile_data.dart';

abstract class ProfileRepository {
  Future<DataState<ProfileData>> getUserProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  ProfileRepositoryImpl({required this.auth, required this.store});

  @override
  Future<DataState<ProfileData>> getUserProfile() async {
    try {
      final user = await store
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();

      if (user.exists) {
        return DataSuccess(data: ProfileData.fromJson(user.data()!));
      }

      return DataError(message: 'User not found');
    } on FirebaseException catch (e) {
      return DataError(message: e.code);
    } catch (e) {
      return DataError(message: e.toString());
    }
  }
}
