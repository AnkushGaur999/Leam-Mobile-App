import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:leam/src/core/data/local/app_storage.dart';
import 'package:leam/src/core/data/remote/dio_client.dart';
import 'package:leam/src/repositories/auth_repository.dart';
import 'package:leam/src/viewmodels/auth/auth_view_model.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {

  final FirebaseAuth auth = FirebaseAuth.instance;

  ///
  /// Register your services here
  ///

  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<AppStorage>(() => AppStorage());

  ///
  /// Register Repositories
  ///

  getIt.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(client: getIt<DioClient>(), auth: auth),
  );

  ///
  /// Register ViewModels
  ///

  getIt.registerFactory<AuthViewModel>(
    () => AuthViewModel(
      repository: getIt<AuthRepository>(),
      appStorage: getIt<AppStorage>(),
    ),
  );
}
