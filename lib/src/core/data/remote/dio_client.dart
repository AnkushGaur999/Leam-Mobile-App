import 'package:dio/dio.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/core/data/remote/interceptor/auth_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio()
      ..options.baseUrl = ""
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.sendTimeout = const Duration(seconds: 30)
      ..interceptors.addAll([AuthInterceptor()]);
  }

  Future<Response> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

}
