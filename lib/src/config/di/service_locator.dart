import 'package:get_it/get_it.dart';
import 'package:leam/src/core/data/remote/dio_client.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  ///
  /// Register your services here
  ///

  getIt.registerLazySingleton(() => DioClient());
}
