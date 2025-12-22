import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:leam/src/core/config/di/service_locator.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/models/profile_data.dart';

abstract class ProfileRepository {
  Future<DataState<ProfileData>> getUserProfile();

  Future<DataState<bool>> uploadProfilePicture({required File file});

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

  @override
  Future<DataState<bool>> uploadProfilePicture({required File file}) async {
    try {
      final udi = firebaseAuth.currentUser?.uid;

      if (udi == null) return DataError(message: "User Not logged in");

      //getting image file extension
      final ext = file.path.split('.').last;

      //storage file ref with path
      final ref = firebaseStorage.ref().child('images/$udi/user_profile.$ext');

      //uploading image
      //  await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
      await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

      final imageUrl = await ref.getDownloadURL();

      await firebaseAuth.currentUser!.updatePhotoURL(imageUrl);

      //updating image in firestore database
      firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .update({"photoUrl": imageUrl});

      return DataSuccess(data: true);
    } on FirebaseException catch (e) {
      return DataError(message: e.message!);
    } catch (e) {
      return DataError(message: e.toString());
    }
  }

}
