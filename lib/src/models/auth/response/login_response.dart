import 'package:firebase_auth/firebase_auth.dart';

class LoginResponse {
  final bool status;
  final String message;
  final User? user;

  LoginResponse({
    required this.status,
    required this.message,
    required this.user,
  });
}
