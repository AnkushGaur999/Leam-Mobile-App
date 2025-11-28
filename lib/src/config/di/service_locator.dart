import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:leam/src/core/data/local/app_storage.dart';
import 'package:leam/src/core/data/remote/dio_client.dart';
import 'package:leam/src/repositories/auth_repository.dart';
import 'package:leam/src/repositories/chat_repository.dart';
import 'package:leam/src/repositories/profile_repository.dart';
import 'package:leam/src/viewmodels/auth/auth_view_model.dart';
import 'package:leam/src/viewmodels/chat/chat_view_model.dart';
import 'package:leam/src/viewmodels/profile/profile_view_model.dart';
import 'package:leam/src/viewmodels/user/user_view_model.dart';

final GetIt getIt = GetIt.instance;

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instanceFor(
  app: Firebase.app(),
  databaseId: "leam",
);

final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

Future<void> initDependencies() async {
  ///
  /// Register your all services here
  ///

  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<AppStorage>(() => AppStorage());

  ///
  /// Register All Repositories
  ///

  getIt.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      client: getIt<DioClient>(),
      auth: firebaseAuth,
      firebaseFirestore: firebaseFirestore,
    ),
  );

  getIt.registerFactory<ProfileRepository>(
    () => ProfileRepositoryImpl(auth: firebaseAuth, store: firebaseFirestore),
  );

  getIt.registerFactory<ChatRepository>(
    () => ChatRepositoryImpl(auth: firebaseAuth, firestore: firebaseFirestore),
  );

  ///
  /// Register All ViewModels
  ///

  getIt.registerFactory<AuthViewModel>(
    () => AuthViewModel(
      repository: getIt<AuthRepository>(),
      appStorage: getIt<AppStorage>(),
    ),
  );

  getIt.registerFactory<ProfileViewModel>(
    () => ProfileViewModel(repository: getIt<ProfileRepository>()),
  );

  getIt.registerFactory(
    () => ChatViewModel(chatRepository: getIt<ChatRepository>()),
  );

  getIt.registerFactory<UserViewModel>(
    () => UserViewModel(repository: getIt<ChatRepository>()),
  );
}
