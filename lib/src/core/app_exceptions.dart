import 'dart:io';

import 'package:dio/dio.dart';

class AppExceptions {
  late String message;

  AppExceptions.fromException(Object exception) {
    if (exception is SocketException) {
      message = "No internet connection";
      return;
    } else if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
          message = "Connection timeout with API server";
          break;
        case DioExceptionType.sendTimeout:
          message = "Send timeout with API server";
          break;
        case DioExceptionType.receiveTimeout:
          message = "Receive timeout with API server";
          break;
        case DioExceptionType.badResponse:
          message = _handleError(
            exception.response?.statusCode,
            exception.response?.data,
          );
          break;
        case DioExceptionType.cancel:
          message = "Request to API server was cancelled";
          break;
        case DioExceptionType.unknown:
          message = "Unexpected error occurred";
          break;
        default:
          message = "Something went wrong";
          break;
      }
    } else {
      message = "Something went wrong! Please try again";
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return "Bad request";
      case 401:
        return "Unauthorized";
      case 403:
        return "Forbidden";
      case 404:
        return "Not found";
      default:
        return "Something went wrong";
    }
  }
}