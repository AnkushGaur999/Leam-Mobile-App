import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppStorage {
  FlutterSecureStorage? _secureStorage;

  AppStorage._internal();

  static final AppStorage _instance = AppStorage._internal();

  final AndroidOptions _androidOptions = const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  final IOSOptions _iosOptions = const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  factory AppStorage() {
    _instance._secureStorage ??= FlutterSecureStorage(
      aOptions: _instance._androidOptions,
      iOptions: _instance._iosOptions,
    );

    return _instance;
  }

  Future<void> write({required String key, required String value}) async {
    await _secureStorage?.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    return await _secureStorage?.read(key: key);
  }

  Future<void> delete({required String key}) async {
    await _secureStorage?.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _secureStorage?.deleteAll();
  }
}
